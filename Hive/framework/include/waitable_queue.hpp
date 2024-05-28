/*******************************************************************************
* Name: Aya
* Date: 18.03.24
* Version: 0.1
* Description: API for thread-safe waitable queueu design pattern
*******************************************************************************/
#ifndef ILRD_WAITABLE_QUEUE
#define ILRD_WAITABLE_QUEUE

#include <queue>              // std::queue
#include <mutex>              // std::timed_mutex, std::lock_guard, std::unique_lock
#include <condition_variable> //std:condition_variable

namespace ilrd
{
/*
Concepts:
- T should be copyable and assignable.
- CONTAINER should support an API identical to std::queue's API: push(), pop(), front(), empty().
*/
template <typename T, typename CONTAINER = std::queue<T>>
class WaitableQueue
{
public:
    WaitableQueue() = default;
    WaitableQueue(const WaitableQueue &other) = delete;
    WaitableQueue &operator=(const WaitableQueue &other) = delete;
    WaitableQueue(WaitableQueue &&other) = delete;
    WaitableQueue &operator=(WaitableQueue &&other) = delete;

    void Push(const T &item);
    void Pop(T &out_item);
    bool Pop(std::chrono::milliseconds timeout_ms, T &out_item);
    bool Empty() const;

private:
    CONTAINER m_container;
    mutable std::timed_mutex m_mutex;
    std::condition_variable_any m_cond;
};

template <typename T, typename CONTAINER>
void WaitableQueue<T, CONTAINER>::Push(const T &item)
{
    {
        //mutex lock
        std::unique_lock<std::timed_mutex> lock(m_mutex);

        //push to container
        m_container.push(item);
    }

    //unlock??

    m_cond.notify_one();
}

template <typename T, typename CONTAINER>
void WaitableQueue<T, CONTAINER>::Pop(T &out_item)
{
    //mutex lock
    std::unique_lock<std::timed_mutex> lock(m_mutex);

    //wait
    m_cond.wait(lock, [this]{return !this->m_container.empty();});

    //save and pop from container
    out_item = m_container.front(); 
    m_container.pop();
}

template <typename T, typename CONTAINER>
bool WaitableQueue<T, CONTAINER>::Pop(std::chrono::milliseconds timeout_ms, T &out_item)
{
	std::chrono::time_point<std::chrono::system_clock> end_time = 
    std::chrono::system_clock::now()  + timeout_ms;

    //mutex lock
    std::unique_lock<std::timed_mutex> lock(m_mutex);

    //wait until timeout exipred or container isn't empty
    while (m_container.empty())
    {
        // if timeout expired return false, else iterate to another wait_until 
        if (std::cv_status::timeout == m_cond.wait_until(lock, end_time))
        {
            return false;
        }
    }

    //save and pop from container
    out_item = m_container.front();
    m_container.pop();

    return true;
}

template <typename T, typename CONTAINER>
bool WaitableQueue<T, CONTAINER>::Empty() const
{
    //mutex lock
    std::unique_lock<std::timed_mutex> lock(m_mutex);

    return m_container.empty();
}

}
#endif// ILRD_WAITABLE_QUEUE