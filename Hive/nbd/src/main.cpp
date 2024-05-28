#include <cstring>//strcmp
#include <iostream>//stdin
#include <signal.h>//sigaction
#include <sys/epoll.h>//epoll
#include <memory>//shared_ptr
#include <unistd.h>//read, write, close
#include <cassert>//assert

#include "driver_data.hpp"
#include "ram_storage.hpp"
#include "nbd_driver_comm.hpp"

using namespace ilrd;
/******************************************************************************/
enum{FALSE = 0, TRUE = 1};
enum{MAX_EVENTS = 100};

int g_is_running = TRUE;

/******************************************************************************/
static void SigHandler(int signal_);
static void SetSignalHandler();
static void CreateNSetEpoll(int* epollfd_, struct epoll_event* ev_, int user_sk_);
static void HandleEventByType(struct epoll_event* events_, int events_count_, 
                            IDriverComm* nbd_driver_, IStorageComm* ram_storage_);
/******************************************************************************/

int main()
{
    std::string nbd_dev_path; 
    std::cout << "please enter the dev path :" <<std::endl;
    std::cin >> nbd_dev_path;

    size_t nbd_size = 0;
    std::cout << "please enter a size in megabytes :" <<std::endl;
    std::cin >> nbd_size;
    nbd_size *= 1024 * 1024;

    IDriverComm* nbd_driver = new NBDDriverComm(nbd_dev_path, nbd_size);
    IStorageComm* ram_storage = new RAMStorage(nbd_size);

    SetSignalHandler();
    
    //epoll
    struct epoll_event ev, events[MAX_EVENTS];
    int epollfd;

    CreateNSetEpoll(&epollfd, &ev, nbd_driver->GetFD());

    while(g_is_running)
    {
        int events_count = epoll_wait(epollfd, events, MAX_EVENTS, -1);

        if((-1 == events_count) && g_is_running)
        {
            perror("epoll_wait ");
            break;
        }

        HandleEventByType(events, events_count, nbd_driver, ram_storage);

    }

    DEBUG_ONLY(std::cout << "exit the loop" << std::endl;)

    close(epollfd);
    delete nbd_driver;
    delete ram_storage;

    return 0;
}

/******************************************************************************/

static void SigHandler(int signal_)
{
    DEBUG_ONLY(std::cout << "\nreccieved signal : " << signal_ << std::endl;)
    g_is_running = FALSE;
}

static void SetSignalHandler()
{
    struct sigaction act;
    act.sa_handler = SigHandler;
    act.sa_flags = SA_RESTART;

    int status = sigemptyset(&act.sa_mask);
    assert("sigemptyset failed" && 0 == status);

    status = sigaction(SIGINT, &act, NULL);
    assert("set_sigaction failed" && 0 == status);

    status = sigaction(SIGTERM, &act, NULL);
    assert("set_sigaction failed" && 0 == status);
}

static void CreateNSetEpoll(int* epollfd_, struct epoll_event* ev_, int user_sk_)
{
    *epollfd_ = epoll_create1(0);
    assert("epoll_create1() failed" && -1 != *epollfd_);

    //add user_sk fd to the epoll to lesten to it 
    ev_->events = EPOLLIN;
    ev_->data.fd = user_sk_;
    int status = epoll_ctl(*epollfd_, EPOLL_CTL_ADD, user_sk_, ev_);
    assert("epoll_ctl() failed" && -1 != status);

    //add stdin fd to the epoll to lesten to it 
    ev_->data.fd = STDIN_FILENO;
    status = epoll_ctl(*epollfd_, EPOLL_CTL_ADD, STDIN_FILENO, ev_);
    assert("epoll_ctl() failed" && -1 != status);
}

static void HandleEventByType(struct epoll_event* events_, int events_count_, IDriverComm* nbd_driver_, IStorageComm* ram_storage_)
{
    //iterate all the events serach for incomming event
    for (int i = 0; i < events_count_; ++i)
    {   
        //check if there is incomming event from stdin/user_socket
        if(STDIN_FILENO == events_[i].data.fd)
        {
            DEBUG_ONLY(std::cout << "Rrcieve event from STDIN" << std::endl;)
                
            char buffer[1000] = {0};
            fgets(buffer, 2, stdin);
            buffer[strcspn(buffer, "\n")] = 0;

            if (0 == strcmp(buffer, "q") || 0 == strcmp(buffer, "quit"))
            {
                DEBUG_ONLY(std::cout << "shutting down..." << std::endl;)
                g_is_running = 0;
                    
            }
        }

        if (nbd_driver_->GetFD() == events_[i].data.fd)
        {
            DEBUG_ONLY(std::cout << "Rrcieve event from NBD" << std::endl;)

            std::shared_ptr<DriverData> driver_data_ptr = nbd_driver_->RecvReq();

            if(driver_data_ptr->m_type == ActionType::READ)
            {
                DEBUG_ONLY(std::cout << "Recieved Read Request" << std::endl;)
                ram_storage_->Read(driver_data_ptr);
            }
            else if(driver_data_ptr->m_type == ActionType::WRITE)
            {
                DEBUG_ONLY(std::cout << "Recieved write Request" << std::endl;)
                ram_storage_->Write(driver_data_ptr);
            }
            else if(driver_data_ptr->m_type == ActionType::DISCONNECT)
            {
                DEBUG_ONLY(std::cout << "Recieved DISCONNECT Request" << std::endl;)
                nbd_driver_->Disconnect();
            }

            //we will not update the status here the ram storage must do that 
            driver_data_ptr->m_status = Status::SUCCESS;

            nbd_driver_->SendRep(driver_data_ptr);
        }

    }
}