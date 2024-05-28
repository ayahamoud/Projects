/*******************************************************************************
* Name: Aya
* Date: 20.03.24
* Version: 0.1
* Description: Singleton Design Pattern
*******************************************************************************/
#ifndef __ILRD_SINGLETONE__
#define __ILRD_SINGLETONE__

#include <memory>//shared pointer
#include <mutex>//mutex
#include <cassert>//assert
#include <iostream>
#include <atomic>//atomic
#include <cstdlib>//atexit

namespace ilrd
{

template <typename T>// T must be uncopyable, unassignable, must have private default ctor and it must have singltone friend   
class Singleton
{
public:
    static T* GetInstance();
    ~Singleton()= delete;
    
    Singleton()= delete;
    Singleton(const Singleton& o_) = delete;
    Singleton& operator=(const Singleton& o_) = delete;

private:
    static void CleanUp();
    static std::atomic<T*> m_instance_ptr;
    static std::mutex m_mutex;
};

template<typename T>
std::atomic<T*> Singleton<T>::m_instance_ptr(nullptr);

template<typename T>
std::mutex Singleton<T>::m_mutex;

template<typename T>
T* Singleton<T>::GetInstance()
{
    T* tmp = m_instance_ptr.load(std::memory_order_relaxed);
    std::atomic_thread_fence(std::memory_order_acquire);

    if(nullptr == tmp)
    {
        m_mutex.lock();
        tmp = m_instance_ptr.load(std::memory_order_relaxed);

        if(nullptr == tmp)
        {
            tmp = new T;
            //check throw bad alloc
            std::atomic_thread_fence(std::memory_order_release);
            m_instance_ptr.store(tmp, std::memory_order_relaxed);

            int status = std::atexit(&Singleton::CleanUp);
            assert(status == 0 && "atexit failed\n");
        }

        m_mutex.unlock();
    }

    return tmp;
}

template<typename T>
void Singleton<T>::CleanUp()
{
    T* temp = m_instance_ptr;
    m_instance_ptr.store(reinterpret_cast<T*>(0xDEADBEEF), std::memory_order_acquire);
    delete temp;
}

}//namespace ilrd

/******************************************************************************/
#endif /*__ILRD_SINGLETONE__*/