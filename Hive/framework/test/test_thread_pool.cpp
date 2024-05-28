#include <unistd.h>

#include "thread_pool.hpp"
#include "factory.hpp"
#include "task.hpp"

using namespace ilrd;

enum KEYS{READ = 0, WRITE = 1};

class Read:public ITask
{
public:
    explicit Read(int num_, TaskPriority p_ = TaskPriority::LOW) : ITask(p_), m_num(num_) {}

    static std::shared_ptr<ITask> Create(int num_, TaskPriority p_ = TaskPriority::LOW)
    {
        return  std::make_shared<Read>(num_, p_);
    }

    void Execute() override
    {
        std::cout << "Read executed: "<< m_num << std::endl;
        fflush(stdout);
        sleep(10);

    }
private:
    int m_num;
};

class Write:public ITask
{
public:
    explicit Write(int num_, TaskPriority p_ = TaskPriority::LOW) : ITask(p_), m_num(num_) {}

    static std::shared_ptr<ITask> Create(int num_, TaskPriority p_ = TaskPriority::LOW)
    {
        return  std::make_shared<Read>(num_, p_);
    }

    void Execute() override
    {
        std::cout << "Write executed " << m_num << std::endl;
        fflush(stdout);
        sleep(10);
    }
private:
    int m_num;
};

int main()
{
    Factory<ITask, KEYS, int, TaskPriority>* factory = Singleton<Factory<ITask,KEYS, int, TaskPriority>>::GetInstance();
    factory->Register(WRITE, Write::Create);
    factory->Register(READ, Read::Create);

    std::shared_ptr<ITask> rtask1 = factory->CreateTask(READ, 1, TaskPriority::LOW);
    std::shared_ptr<ITask> rtask2 = factory->CreateTask(READ, 2, TaskPriority::HIGH);
    std::shared_ptr<ITask> wtask1 = factory->CreateTask(WRITE, 1, TaskPriority::MED);
    std::shared_ptr<ITask> wtask2 = factory->CreateTask(WRITE, 2, TaskPriority::LOW);

    ThreadPool tp(1);

    /* tp.Pause(); */
    tp.AddTask(rtask1);
    tp.AddTask(rtask2);
    tp.AddTask(wtask1);
    tp.AddTask(wtask1);

    /* sleep(5);
    tp.Resume(); */

    sleep(5);
    fflush(stdout);
    return 0;
}
