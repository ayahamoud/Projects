/*******************************************************************************
* Name: Aya
* Date: 29.02.24
* Version: 0.1
* Description: define driver data struct
*******************************************************************************/
#ifndef __ILRD_HRD32_DRIVER_DATA_HPP__
#define __ILRD_HRD32_DRIVER_DATA_HPP__

#include <cstddef> //size_t
#include <vector> //vector

namespace ilrd
{
// Driver Data Enums:
enum class ActionType 
{
    READ = 0,
    WRITE = 1,
    FLUSH,
    TRIM,
    DISCONNECT
};

enum class Status
{
    FAILURE = -1,
    SUCCESS = 0
};

struct DriverData
{
    explicit DriverData(ActionType type_, char* handle_, size_t offset_, size_t len_);

    ~DriverData() = default;
    DriverData(const DriverData& other) = delete;
    DriverData& operator=(const DriverData& other) = delete;

    std::vector<unsigned char> m_buff;
    Status m_status;
    ActionType m_type;
    char m_handle[8];
    const size_t m_offset;
    const size_t m_len;
}; 
}

#endif// __ILRD_HRD32_DRIVER_DATA_HPP__