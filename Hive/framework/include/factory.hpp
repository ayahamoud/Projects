/*******************************************************************************
* Name: Aya
* Date: 21.03.24
* Version: 0.1
* Description: Factory Design Pattern
*******************************************************************************/
#ifndef __ILRD_FACTORY__
#define __ILRD_FACTORY__
/******************************************************************************/
#include <functional>
#include <memory>
#include <map>

#include "utils.hpp"
#include "singleton.hpp"
/******************************************************************************/
namespace ilrd
{

template<typename BASE, typename KEY, typename... ARGS>//BASE must have 
class Factory
{
public:
    //typedef
    using CreateTaskFunc_ty = std::function<std::shared_ptr<BASE>(ARGS ...)>;

    void Register(KEY key_, CreateTaskFunc_ty creator_); 
    std::shared_ptr<BASE> CreateTask(KEY key_, ARGS... args_);

    Factory(const Factory& o_)=delete;
    Factory& operator=(const Factory& o_)=delete;
private:
    std::map<KEY, CreateTaskFunc_ty> m_map_creators;

    ~Factory()=default; //To prevent inhertance
    Factory()=default;
    friend class Singleton<Factory<BASE, KEY, ARGS...>>;
};


template<typename BASE, typename KEY, typename... ARGS>
void Factory<BASE, KEY, ARGS...>::Register(KEY key_, CreateTaskFunc_ty creator_)
{
    m_map_creators[key_] = creator_;
}

template<typename BASE, typename KEY, typename... ARGS>
std::shared_ptr<BASE> Factory<BASE, KEY, ARGS...>::CreateTask(KEY key_, ARGS... args_)
{
    //m_map_creators[key] retrun creator function and we call it with (args...)parameters
    //and the return value is an object from the BASE(task) type
    return m_map_creators[key_](args_...);
}

}//namespace ilrd
/******************************************************************************/
#endif /*__ILRD_FACTORY__*/