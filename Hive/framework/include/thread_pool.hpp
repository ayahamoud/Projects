/*******************************************************************************
* Name: Aya
* Date: 21.03.24
* Version: 0.1
* Description: Thread Pool Design Pattern
*******************************************************************************/
#ifndef __ILRD_THREAD_POOL__
#define __ILRD_THREAD_POOL__

#include <cstddef> //size_t
#include <vector> //vector
#include <thread> //thread
#include <memory> //shared_ptr

#include "task.hpp"
#include "priority_queue.hpp"
#include "waitable_queue.hpp"
#include "logger.hpp"
/******************************************************************************/
namespace ilrd
{
enum class RunningStatus
{
    STOP = 0,
    RUNNING = 1,
    PAUSE = 2
};

class ThreadPool
{
public:
    explicit ThreadPool(size_t num_of_th_ = std::thread::hardware_concurrency());
    ~ThreadPool() noexcept;
    ThreadPool(const ThreadPool& other) = delete;
    ThreadPool& operator=(const ThreadPool& other_) = delete;
    ThreadPool(const ThreadPool&& other) = delete;
    ThreadPool& operator=(const ThreadPool&& other_) = delete;

    void AddTask(std::shared_ptr<ITask> task_);
    void Pause();
    void Resume();
    void SetThreadNum(size_t num_of_th_);

private:
    class Compare
    {
    public:
        bool operator()(const std::shared_ptr<ITask> t_, const std::shared_ptr<ITask> o_)
        {
            return *t_ < *o_;
        }
    };//used as functor to compare two shared pointers of tasks

    size_t m_thread_num;
    WaitableQueue<std::shared_ptr<ITask>,
                    PriorityQueue<std::shared_ptr<ITask>, 
                                    std::vector<std::shared_ptr<ITask>>,
                                    Compare>> m_task_queue;
    std::vector<std::thread> m_threads;
    volatile RunningStatus m_is_running;
    Logger *m_logger;

    void Run();
    void Stop() noexcept;
    void ThreadFunc();
};
}//namespace ilrd
/******************************************************************************/
#endif /*__ILRD_THREAD_POOL__*/