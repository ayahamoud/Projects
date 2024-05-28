/*******************************************************************************
* Name: Aya
* Date: 29.02.24
* Version: 0.1
* Description: define Storage Communicator abstract class
*******************************************************************************/
#ifndef __ILRD_HRD32_I_STORAGE_HPP__
#define __ILRD_HRD32_I_STORAGE_HPP__

#include <memory> //shared_pointer 

#include "driver_data.hpp"

namespace ilrd
{

class IStorageComm 
{
public:
    IStorageComm()=default;
    virtual ~IStorageComm()=default;
   
    virtual void Read(std::shared_ptr<DriverData>) const = 0;
    virtual void Write(std::shared_ptr<DriverData>) = 0;

    IStorageComm(const IStorageComm&) = delete;
    IStorageComm& operator=(const IStorageComm&) = delete; 
};

}

#endif// __ILRD_HRD32_I_STORAGE_HPP__