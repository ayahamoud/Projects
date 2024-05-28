/*******************************************************************************
* Name: Aya
* Date: 29.02.24
* Version: 0.1
* Description: define driver data struct
*******************************************************************************/
#include "driver_data.hpp"

namespace ilrd
{
DriverData::DriverData(ActionType type_, char* handle_, size_t offset_, size_t len_):
m_offset(offset_), m_len(len_), m_status(Status::SUCCESS), m_type(type_)
{
    std::copy(handle_, handle_+ sizeof(handle_), m_handle);
    m_buff.clear();
}
}