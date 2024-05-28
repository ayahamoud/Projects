/*******************************************************************************
* Name: Aya
* Date: 29.02.24
* Version: 0.1
* Description: define RAM Storage Communicator 
*******************************************************************************/
#include <cassert> //assert

#include "ram_storage.hpp"

namespace ilrd
{
RAMStorage::RAMStorage(size_t size_): m_len(size_)
{
    m_pool.resize(m_len);
}

RAMStorage::RAMStorage(size_t block_size_, size_t num_blocks_) :
                                        RAMStorage(block_size_ * num_blocks_)
{

}

void RAMStorage::Read(std::shared_ptr<DriverData> data_) const 
{
    size_t check_in_range = data_->m_len + data_->m_offset;
    assert(m_len >= check_in_range);

    data_->m_buff.assign(m_pool.begin() + data_->m_offset, m_pool.begin() + data_->m_offset + data_->m_len +1);
    
    data_->m_status = Status::SUCCESS;
}

void RAMStorage::Write(std::shared_ptr<DriverData> data_)
{
    std::copy(data_->m_buff.begin(), data_->m_buff.begin() + data_->m_len, m_pool.begin() + data_->m_offset);
    data_->m_status = Status::SUCCESS;
}
}