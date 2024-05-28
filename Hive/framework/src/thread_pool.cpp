/*******************************************************************************
* Name: Aya
* Date: 21.03.24
* Version: 0.1
* Description: Thread Pool Design Pattern
*******************************************************************************/
#include <algorithm> //for_each
#include <mutex> //mutex
#include <condition_variable> // condition variable

#include "thread_pool.hpp"
#include "singleton.hpp"

namespace ilrd
{
static std::mutex g_mutex;
static std::condition_variable cond_var;

ThreadPool::ThreadPool(size_t num_of_th_): m_thread_num(num_of_th_), m_is_running(RunningStatus::RUNNING), m_logger(Singleton<Logger>::GetInstance())
{
    // resize vector
    m_threads.resize(m_thread_num);
    // run TP
    Run();
}

ThreadPool::~ThreadPool() noexcept
{
    // stop TP
    Stop();
}

void ThreadPool::AddTask(std::shared_ptr<ITask> task_)
{
    // push task to the waitable priority queue
    m_task_queue.Push(task_);
}

void ThreadPool::Pause()
{
    // change TP's state to PAUSE - (TODO: atomic (store)???)
    m_is_running = RunningStatus::PAUSE;
}

void ThreadPool::Resume()
{
    // change TP's state to RUNNING - (TODO: atomic (store)???)
    m_is_running = RunningStatus::RUNNING;
}

void ThreadPool::SetThreadNum(size_t num_of_th_)
{
    // stop TP
    Stop();
    // set new thread number
    m_thread_num = num_of_th_;
    // resize vector
    m_threads.resize(m_thread_num);
    // run TP
    Run();
}

//stop should handle this use case: the thread is in an infinity loop
//check decreasing then increasing threads (if still have the same number of threads) 
//check the pause and resume
void ThreadPool::Run()
{
    // create and initialize vector's threads with ThreadFunc
    std::for_each(m_threads.begin(), m_threads.end(), [this](std::thread& thread_){thread_ = std::thread(&ThreadPool::ThreadFunc, this);});
}

void ThreadPool::Stop() noexcept
{
    // change TP's state to STOP - (TODO: atomic (store)???)
    m_is_running = RunningStatus::STOP;

    /* std::unique_lock<std::mutex> lock(g_mutex);
    cond_var.wait(lock, [this]{return false == this->m_task_queue.Empty();}); */

    //while m_task_future is not empty
        //pop future task
        //wait_for future task to be available 
        //if falis 
            //repush future task

    
    // wait for the threads to finish (join) try catch and write to logger 
    try
    {
       
    }
    catch(const std::system_error& e)
    {
        m_logger->Log(Logger::LevelType::ERROR, e.what(), __LINE__, "thread_pool.cpp");
    }
}

void ThreadPool::ThreadFunc()
{
    // while  m_is_running is not STOP or (TODO: m_task_queue is not empty???)
    while(RunningStatus::STOP != m_is_running)
    {
        if (m_is_running != RunningStatus::PAUSE)
        {
            std::shared_ptr<ITask> ret_task;
            // timed pop a task from m_task_queue
            if(m_task_queue.Pop(std::chrono::milliseconds(2), ret_task))
            {
                // if success execute the task
                ret_task->Execute();
            }
        }
    }
}
}//namespace ilrd
