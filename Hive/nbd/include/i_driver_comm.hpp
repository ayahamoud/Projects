/*******************************************************************************
* Name: Aya
* Date: 29.02.24
* Version: 0.1
* Description: define Driver Communicator abstract class
*******************************************************************************/
#ifndef __ILRD_HRD32_I_DRIVER_HPP__
#define __ILRD_HRD32_I_DRIVER_HPP__

#include <memory> //shared_pointer

#include "driver_data.hpp"

namespace ilrd
{

class IDriverComm
{
public:
    explicit IDriverComm() = default;
    virtual ~IDriverComm() = default;

    virtual std::shared_ptr<DriverData> RecvReq() = 0;
    virtual void SendRep(const std::shared_ptr<DriverData> data_) = 0;
    virtual void Disconnect() =0; 
    virtual int GetFD() const =0; //added for the reactor

    IDriverComm(const IDriverComm&) = delete; 
    IDriverComm& operator=(const IDriverComm&) = delete; 
};
}

#endif// __ILRD_HRD32_I_DRIVER_HPP__