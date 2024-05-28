#include <thread>
#include <iostream>
#include <memory>

#include "waitable_queue.hpp"


using namespace ilrd;
struct ARGS
{
    int x;
    float y;
    int z;
};

class ITask
{
public:
    ITask()= default;
    virtual ~ITask()= default;

    virtual void Execute()=0;

    ITask& operator=(const ITask& o_)= delete;
    ITask(const ITask& o_) = delete;
};

class Read:public ITask
{
public:
    Read(ARGS args_)
    {
        std::cout << "Read from read task ctor" << std::endl;
    }
    
    static std::shared_ptr<ITask> Create(ARGS args_)
    {
        return  std::make_shared<Read>(args_);
    }

    void Execute()override
    {
        std::cout << "Read executed" << std::endl;
    }

};

class Write:public ITask
{
public:
    Write(ARGS args_)
    {
        std::cout << "Write from Write task ctor" << std::endl;
    }

    static std::shared_ptr<ITask> Create(ARGS args_)
    {
        return  std::make_shared<Write>(args_);
    }

    void Execute()override
    {
        std::cout << "Write executed" << std::endl;
    }

};

void PushThread(WaitableQueue<ITask*>* queue, ITask* task)
{
    queue->Push(task);
}

void PopThread(WaitableQueue<ITask*>* queue)
{
    ITask* poped_task = nullptr;
    queue->Pop(poped_task);

}


int main()
{
    WaitableQueue<ITask*> w_queue;
    std::cout << "IsEmpty before push = " << w_queue.Empty() << std::endl;
    ITask* task = new Write({1,2,3});
    w_queue.Push(task);
    std::cout << "IsEmpty after push = " << w_queue.Empty() << std::endl;
    ITask* poped_task = nullptr;
    w_queue.Pop(std::chrono::milliseconds(2), poped_task);
    std::cout << "IsEmpty after pop = " << w_queue.Empty() << std::endl;
    poped_task->Execute();

    std::vector<std::thread> vector;

    for(size_t i = 0; i < 5 ; ++i)
    {
        vector.push_back(std::thread(PushThread, &w_queue, task)); 
    }

    for(size_t i = 0; i < 5 ; ++i)
    {
        vector.push_back(std::thread(PopThread, &w_queue)); 
    }

    for(size_t i = 0; i < 10 ; ++i)
    {
        vector[i].join();
    }

    return 0;
}

// using namespace std;
// using namespace ilrd;

// WaitableQueue<int> my_queue;

// void WriteThread(int val, int num)
// {
//     my_queue.Push(val);

//     cout << "thread number " << num << "pushed " << val << endl;

// }

// void ReadThread(int num)
// {
//     int ret;
//     my_queue.Pop(ret);

//     cout << "thread number " << num << "popped " << ret << endl;
// }

// int main()
// {
//     thread thread1(WriteThread, 74, 1);
//     thread thread2(WriteThread, 82, 2);
//     thread thread3(ReadThread, 3);
//     thread thread4(ReadThread, 4);

//     thread1.join();
//     thread2.join();
//     thread3.join();
//     thread4.join();
//     return 0;
// }
