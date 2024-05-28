/*******************************************************************************
* Aya: Aya
* Date: 29.02.24
* Version: 0.1
* Description: define Network Block Device Driver Communicator 
*******************************************************************************/
#ifndef __ILRD_HRD32_NBD_DRIVER_HPP__
#define __ILRD_HRD32_NBD_DRIVER_HPP__

#include <cstddef> //size_t
#include <string> //string
#include <memory> //shared_pointer
#include <thread> //thread



#include "i_driver_comm.hpp"
#include "utils.hpp"

namespace ilrd
{

class NBDDriverComm: public IDriverComm 
{
public:
    explicit NBDDriverComm(const std::string& path_dev_file, size_t size);
    explicit NBDDriverComm(const std::string& path_dev_file_, size_t block_size,
                     size_t num_of_blocks); //may throw opening socket exception
    ~NBDDriverComm() noexcept;

    NBDDriverComm(const NBDDriverComm& other_) = delete;
    NBDDriverComm& operator=(const NBDDriverComm& other_) = delete;
    
    std::shared_ptr<DriverData> RecvReq() override; // can throw read exception
    void SendRep(const std::shared_ptr<DriverData>) override; // can throw write exception
    void Disconnect() override;  // can throw close exception
    int GetFD() const override;

private:
    int m_user_sk;
    int m_kernel_sk;
    int m_nbd;
    std::thread m_child_thread;

    void DoItThread();
};
}

#endif// __ILRD_HRD32_NBD_DRIVER_HPP__