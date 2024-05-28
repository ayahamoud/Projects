/*******************************************************************************
* Name: Aya
* Date: 21.03.24
* Version: 0.1
* Description: Generic Task API
*******************************************************************************/
#include "task.hpp"

namespace ilrd
{
ITask::ITask(TaskPriority p_):m_priority(p_)
{
}

bool ITask::operator<(const ITask& other_) const
{
    return m_priority < other_.m_priority;
}

}//namespace ilrd