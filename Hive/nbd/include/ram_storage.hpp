/*******************************************************************************
* Name: Aya
* Date: 29.02.24
* Version: 0.1
* Description: define RAM Storage Communicator 
*******************************************************************************/
#ifndef __ILRD_HRD32_RAM_STORAGE_HPP__
#define __ILRD_HRD32_RAM_STORAGE_HPP__

#include <cstddef> //size_t
#include <memory> //shared_pointer 
#include <vector>

#include "driver_data.hpp"
#include "i_storage.hpp"

namespace ilrd
{

class RAMStorage: public IStorageComm
{
public:
    explicit RAMStorage(size_t size_);
    explicit RAMStorage(size_t block_size_, size_t num_blocks_);
    ~RAMStorage() = default;
    
    void Read(std::shared_ptr<DriverData>) const override;
    void Write(std::shared_ptr<DriverData>) override;

private:
    const size_t m_len;
    std::vector<unsigned char> m_pool;
};
}

#endif// __ILRD_HRD32_RAM_STORAGE_HPP__