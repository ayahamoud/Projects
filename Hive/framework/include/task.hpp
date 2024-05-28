/*******************************************************************************
* Name: Aya
* Date: 21.03.24
* Version: 0.1
* Description: Generic Task API
*******************************************************************************/
#ifndef __ILRD_TASK__
#define __ILRD_TASK__

/******************************************************************************/
namespace ilrd
{
enum class TaskPriority
{
    LOW = 0, 
    MED = 1,
    HIGH = 2,
    //NOTE: add priorities before admin
    ADMIN
};

class ITask
{
public:
    explicit ITask(TaskPriority p_ = TaskPriority::LOW);
    virtual ~ITask() = default;
    
    ITask(const ITask& other) = default;
    ITask& operator=(const ITask& other_) = default;
    ITask(const ITask&& other) = delete;
    ITask& operator=(const ITask&& other_) = delete;

    virtual void Execute() = 0;
    bool operator<(const ITask& other_) const;

private:
    TaskPriority m_priority;
};

}//namespace ilrd
/******************************************************************************/
#endif /*__ILRD_TASK__*/