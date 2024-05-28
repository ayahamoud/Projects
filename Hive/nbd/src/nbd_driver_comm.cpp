/*******************************************************************************
* Aya: Aya
* Date: 29.02.24
* Version: 0.1
* Description: define Network Block Device Driver Communicator 
*******************************************************************************/
#include <sys/socket.h> //socketpair
#include <cassert> //assert
#include <fcntl.h> //open
#include <linux/nbd.h> //NBD_SET_SIZE, NBD_CLEAR_SOCK
#include <sys/ioctl.h> //ioctl
#include <unistd.h> //close
#include <csignal> //signalmask
#include <arpa/inet.h> //htonl
#include <cstring> //c_str
#include <iostream> //cout

#include "nbd_driver_comm.hpp"

namespace ilrd
{

/*************************** Helper Functions *********************************/
static ActionType CmdToAction(__be32 cmd_type_);
static __be32 StatusToError(Status status_);
static u_int64_t ntohll(u_int64_t a);
static int ReadAll(int fd, char* buf, size_t count);
static int WriteAll(int fd, char* buf, size_t count);
/******************************************************************************/

NBDDriverComm::NBDDriverComm(const std::string& path_dev_file, size_t size_)
{
    int socket_pair[2] = {0};

    // Create Socket Pair
    assert(0 == socketpair(AF_UNIX, SOCK_STREAM, 0, socket_pair));

    m_user_sk = socket_pair[0];
    m_kernel_sk = socket_pair[1];

    // Open device
    m_nbd = open(path_dev_file.c_str(), O_RDWR);
    assert("open failed\n" && (m_nbd != -1)); //add throw to check the failure

    // Set size
    assert("ioctl failed\n" && (ioctl(m_nbd, NBD_SET_SIZE, size_) != -1)); //add throw to check the failure

    //clear socket
    assert("ioctl failed\n" && (ioctl(m_nbd, NBD_CLEAR_SOCK) != -1)); //add throw to check the failure

    m_child_thread = std::thread(&NBDDriverComm::DoItThread, this);
}

NBDDriverComm::NBDDriverComm(const std::string& path_dev_file_, size_t      block_size, size_t num_of_blocks) : 
                NBDDriverComm(path_dev_file_, block_size * num_of_blocks) 
{

}

void NBDDriverComm::DoItThread()
{
    sigset_t sigset;
    //Set all signals
    assert("sigfillset failed \n" && 0 == sigfillset(&sigset));

    // Mask all the signals
    assert("pthread_sigmask failed \n" && 0 == pthread_sigmask(SIG_SETMASK, &sigset, NULL));

    //set the socket sp[1] to be connected to nbd
    assert("ioctl(nbd, NBD_SET_SOCK, sk) failed\n" && -1 != ioctl(m_nbd, NBD_SET_SOCK, m_kernel_sk));
    
    //start listening on nbd
    int status = ioctl(m_nbd, NBD_DO_IT);
    DEBUG_ONLY(fprintf(stderr, "nbd device terminated with code %d\n", status);)
    assert("NBD_DO_IT terminated with error\n" && (-1 != status));
}

NBDDriverComm::~NBDDriverComm()
{
    // Cleanup the sockets
    assert(-1 != ioctl(m_nbd, NBD_CLEAR_QUE));
    assert(-1 != ioctl(m_nbd, NBD_CLEAR_SOCK));

    // Disconnect the nbd driver
    Disconnect();

    // Join thread
    m_child_thread.join();

    // Close the sockets
    close(m_user_sk);
    close(m_kernel_sk);

    // Close the device
    close(m_nbd);
}

std::shared_ptr<DriverData> NBDDriverComm::RecvReq()
{
    struct nbd_request req;
    //read the reqest from the socket
    ssize_t bytes_read = read(m_user_sk, &req, sizeof(req));
    assert("failed to read request\n" && bytes_read == sizeof(req));

    //initialize new driver data and fill it with requested data 
    std::shared_ptr<DriverData> driver_data_ptr = std::make_shared<DriverData>
    (CmdToAction(req.type), req.handle, ntohll(req.from), ntohl(req.len));

    //check if the request is write then write to the driver data vector
    if(ntohl(req.type) == NBD_CMD_WRITE)
    {
        char* temp_buffer = new char[driver_data_ptr->m_len];
        
        //read the data from user_sk to temp_buffer
        bytes_read = ReadAll(m_user_sk, temp_buffer, driver_data_ptr->m_len);
        assert("failed to read from socket\n" && bytes_read != -1);

        //clear the m_buffer
        driver_data_ptr->m_buff.clear();

        //copy the data from the temp buffer to the driver data buffer 
        driver_data_ptr->m_buff.assign(temp_buffer, temp_buffer + driver_data_ptr->m_len + 1);

        delete [] temp_buffer;
    }

    return driver_data_ptr;
}
   
void NBDDriverComm::SendRep(const std::shared_ptr<DriverData> data_)
{
    struct nbd_reply rep;
    rep.error = StatusToError(data_->m_status);
    std::copy(data_->m_handle, data_->m_handle + sizeof(rep.handle), rep.handle);
    rep.magic = htonl(NBD_REPLY_MAGIC);

    ssize_t bytes_written = WriteAll(m_user_sk, (char*)&rep, sizeof(struct nbd_reply));
    assert("failed to write reply\n" && bytes_written != -1);

    //if the action type is read - must write to socket
    if(data_->m_type == ActionType::READ)
    {
        char* temp_buffer = new char[data_->m_len];

        std::copy(data_->m_buff.begin(), data_->m_buff.end(), temp_buffer);

        data_->m_buff.clear();

        bytes_written = WriteAll(m_user_sk, temp_buffer, data_->m_len);
        assert("failed to write to socket\n" && bytes_written != -1);

        delete [] temp_buffer;
    }
}

void NBDDriverComm::Disconnect()
{
    static int is_connected = 1;

    if(is_connected)
    {
        assert(-1 != ioctl(m_nbd, NBD_DISCONNECT));
        is_connected = 0;
    }
}

int NBDDriverComm::GetFD() const
{
    return m_user_sk;
}

// Function that converts NBD_COMMANDS to ActionType commands
static ActionType CmdToAction(__be32 cmd_type_)
{
    switch (ntohl(cmd_type_))
    {
        case NBD_CMD_READ:
            return ActionType::READ;
        
        case NBD_CMD_WRITE:
            return ActionType::WRITE;
        
        case NBD_CMD_DISC:
            return ActionType::DISCONNECT;

        case NBD_CMD_FLUSH:
            return ActionType::FLUSH;
        
        case NBD_CMD_TRIM:
            return ActionType::TRIM;
    }

    return ActionType(-1);
}

// Function that converts our defined Status to NBD defined error(status)
static __be32 StatusToError(Status status_)
{
    if(Status::SUCCESS == status_)
    {
        return htonl(0);
    }
    
    return htonl(1);
}

static u_int64_t ntohll(u_int64_t a)
{
  u_int32_t lo = a & 0xffffffff;
  u_int32_t hi = a >> 32U;
  lo = ntohl(lo);
  hi = ntohl(hi);
  return ((u_int64_t) lo) << 32U | hi;
}

static int ReadAll(int fd, char* buf, size_t count)
{
    int bytes_read = 0;

    while (count > 0) 
    {
        bytes_read = read(fd, buf, count);
        assert(bytes_read > 0);
        buf += bytes_read;
        count -= bytes_read;
    }

    assert(count == 0);
    return 0;
}

static int WriteAll(int fd, char* buf, size_t count)
{
    int bytes_written;

    while (count > 0) 
    {
        bytes_written = write(fd, buf, count);
        assert(bytes_written > 0);
        buf += bytes_written;
        count -= bytes_written;
    }
    
    assert(count == 0);
    return 0;
}
}