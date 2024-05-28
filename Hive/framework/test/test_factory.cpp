#include <functional>
#include <memory>
#include <map>

#include "utils.hpp"
#include "singleton.hpp"
#include "factory.hpp"
#include "task.hpp"
/******************************************************************************/
using namespace ilrd;
struct ARGS
{
    int x;
    float y;
    int z;
};

enum KEYS{READ = 0, WRITE = 1};

class Read:public ITask
{
public:
    Read(ARGS args_)
    {
        (void)args_;
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
        (void)args_;
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


int main()
{
    Factory<ITask, KEYS, ARGS>* factory = Singleton<Factory<ITask, KEYS, ARGS>>::GetInstance();
    factory->Register(WRITE, Write::Create);
    std::shared_ptr<ITask> task = factory->CreateTask(WRITE, {1,2,3});
    task->Execute();

    return 0; 
}