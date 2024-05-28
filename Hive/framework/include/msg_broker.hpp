/*******************************************************************************
* Author: Aya
* Date: 01.04.24
* Version: 1.0 
* Description: Publisher-SUBSCRIBERr, Dispatcher-Callback API
*******************************************************************************/
#ifndef __ILRD_HRD32_MSG_BROKER_HPP__
#define __ILRD_HRD32_MSG_BROKER_HPP__

#include <cstddef> //size_t 
#include <vector> //vector 
#include <algorithm> //for_each
namespace ilrd
{

template<typename MSG>    
class ICallBack;

template <typename MSG>
class Dispatcher
{
public:
    explicit Dispatcher() = default;
    ~Dispatcher();

    Dispatcher(const Dispatcher&) = delete;
    Dispatcher& operator=(const Dispatcher&) = delete;
    Dispatcher(Dispatcher&&) = delete;
    Dispatcher& operator=(Dispatcher&&) = delete;

    void NotifyAll(const MSG& msg_);

private:
    friend class ICallBack<MSG>;
    void Subscriber(ICallBack<MSG>* cb_);
    void UnSubscriber(ICallBack<MSG>* cb_);
    void NotifyDisc();
    
    std::vector<ICallBack<MSG>*> m_subscribers;
};


template <typename MSG>
class ICallBack
{
public:
    explicit ICallBack(Dispatcher<MSG> * const  disp_);
    virtual ~ICallBack();

    ICallBack(const ICallBack&) = delete;
    ICallBack& operator=(const ICallBack&) = delete;
    ICallBack(ICallBack&&) = delete;
    ICallBack& operator=(ICallBack&&) = delete;

private:
    friend class Dispatcher<MSG>;
    virtual void Notify(const MSG& msg_) = 0;
    virtual void NotifyDisc() = 0; 
    
    Dispatcher<MSG> * const  m_dispatcher;
};

// SUBSRIBER must have Update method (for Notify)
// SUBSRIBER Disconnect method is optional (for NotifyDisc)
template <typename MSG, typename SUBSCRIBER>
class CallBack : public ICallBack<MSG>
{
public:
    using ActionMethod = void(SUBSCRIBER::*)(const MSG&);
    using DisconnectMethod = void(SUBSCRIBER::*)();
    
    explicit CallBack(Dispatcher<MSG> * const disp_,
                     SUBSCRIBER& sub_,
                     ActionMethod action_,
                     DisconnectMethod disconnect_= nullptr);
    ~CallBack() = default;

private:
    void Notify(const MSG& msg_) override;
    void NotifyDisc() override; 

    SUBSCRIBER& m_sub;
    ActionMethod m_action;
    DisconnectMethod m_disconnect;
};

////////////////////////////// Implementation //////////////////////////////////
//ICallBack
template <typename MSG>
ICallBack<MSG>::ICallBack(Dispatcher<MSG> * const  disp_): m_dispatcher(disp_)
{
    m_dispatcher->Subscriber(this);
}

template <typename MSG>
ICallBack<MSG>::~ICallBack()
{
    m_dispatcher->UnSubscriber(this);
}
// -----------------------------------------------------------------------------
//CallBack
template <typename MSG, typename SUBSCRIBER>
CallBack<MSG, SUBSCRIBER>::CallBack(Dispatcher<MSG> * const  disp_, SUBSCRIBER& sub_, ActionMethod action_, DisconnectMethod disconnect_): ICallBack<MSG>(disp_) ,m_sub(sub_), m_action(action_), m_disconnect(disconnect_)
{
}

template <typename MSG, typename SUBSCRIBER>
void CallBack<MSG, SUBSCRIBER>::Notify(const MSG& msg_)
{
    (m_sub.*m_action)(msg_);
}

template <typename MSG, typename SUBSCRIBER>
void CallBack<MSG, SUBSCRIBER>::NotifyDisc()
{
    if(nullptr != m_disconnect)
    {
        (m_sub.*m_disconnect)();
    }
}

// -----------------------------------------------------------------------------
//Dispatcher
template <typename MSG>
Dispatcher<MSG>::~Dispatcher()
{
    NotifyDisc();
}

template <typename MSG>
void Dispatcher<MSG>::NotifyAll(const MSG& msg_)
{
    std::for_each(m_subscribers.begin(),m_subscribers.end(), [&](ICallBack<MSG>* sub_){sub_->Notify(msg_);});
}

template <typename MSG>
void Dispatcher<MSG>::Subscriber(ICallBack<MSG>* cb_)
{
    m_subscribers.push_back(cb_);
}

template <typename MSG>
void Dispatcher<MSG>::UnSubscriber(ICallBack<MSG>* cb_)
{
    //TODO: check the find
    m_subscribers.erase(std::find(m_subscribers.begin(), m_subscribers.end(), cb_));
}

template <typename MSG>
void Dispatcher<MSG>::NotifyDisc()
{
    std::for_each(m_subscribers.begin(),m_subscribers.end(), [](ICallBack<MSG>* sub_){sub_->NotifyDisc();});
}

}
#endif// __ILRD_HRD32_MSG_BROKER_HPP__