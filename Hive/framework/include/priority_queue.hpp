/*******************************************************************************
* Name: Aya
* Date: 18.03.24
* Version: 0.1
* Description: API for thread-safe priority queueu design pattern
*******************************************************************************/
#ifndef ILRD_PRIORITY_QUEUE
#define ILRD_PRIORITY_QUEUE

#include <queue>              // std::queue

namespace ilrd
{
/*
wrapper that adds front() to std::priority_queue
Concepts:
T should be copyable and assignable.
*/
template <typename T,
          typename CONTAINER = std::vector<T>,
          typename COMPARE = std::less<typename CONTAINER::value_type>
         >
class PriorityQueue: private std::priority_queue<T,CONTAINER,COMPARE>
{
public:
    using priority_queue = std::priority_queue<T, CONTAINER, COMPARE>;

    PriorityQueue() = default;
    ~PriorityQueue() = default;
    PriorityQueue(const PriorityQueue&) = default;
    PriorityQueue& operator=(const PriorityQueue&) = delete;
    PriorityQueue(const PriorityQueue&&) = delete;
    PriorityQueue& operator=(const PriorityQueue&&) = delete;

    const T& front() const;

    using priority_queue::push;
    using priority_queue::pop;
    using priority_queue::empty;
};

template <typename T,
          typename CONTAINER,
          typename COMPARE>
const T& PriorityQueue<T,CONTAINER,COMPARE>::front() const
{
    return priority_queue::top();
}

}

#endif// ILRD_PRIORITY_QUEUE