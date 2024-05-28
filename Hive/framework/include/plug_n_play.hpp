/*******************************************************************************
* Author: Aya
* Date: 04.04.2024
* Version: 1.0
* Description: Plug and Play Design Pattern
*******************************************************************************/
#ifndef __ILRD_HRD32_PNP_HPP__
#define __ILRD_HRD32_PNP_HPP__

#include <string>
#include <thread>
#include <sys/inotify.h>
#include <vector>

// #include "logger.hpp"
#include "msg_broker.hpp"

namespace ilrd
{
class PlugNPlay
{
public:
    explicit PlugNPlay(const std::string &path_ = "./pnp");
    ~PlugNPlay() = default;
    PlugNPlay(const PlugNPlay &other_) = delete;
    PlugNPlay &operator=(const PlugNPlay &other_) = delete;

private:
    class DirMonitor;
    class SOLoader;

    Dispatcher<std::string> m_dispatcher;
    std::unique_ptr<DirMonitor> m_monitor;
    std::unique_ptr<SOLoader> m_loader;
};

class PlugNPlay::DirMonitor
{
public:
    explicit DirMonitor(Dispatcher<std::string> * const dispatcher_,
                        const std::string &path_ = "./pnp");
    ~DirMonitor();
    DirMonitor(const DirMonitor &other_) = delete;
    DirMonitor &operator=(const DirMonitor &other_) = delete;

private:
    Dispatcher<std::string> * const m_dispatcher;
    std::thread m_async_listener;
    int m_notify_init;
    int m_notify_add_watch;

    void MonitorLoop(const std::string &path_);
};

class PlugNPlay::SOLoader
{
public:
    explicit SOLoader(Dispatcher<std::string> * const dispatcher_);
    ~SOLoader();
    SOLoader(const SOLoader &other_) = delete;
    SOLoader &operator=(const SOLoader &other_) = delete;

private:
    CallBack<std::string, SOLoader> m_call_back;
    std::vector<void*> m_dlopen_handles;

    void Load(const std::string &file_name_);
};

} // namespace ilrd

#endif // __ILRD_HRD32_PNP_HPP__