/*******************************************************************************
* Author: Aya
* Date: 04.04.2024
* Version: 1.0
* Description: Plug and Play Design Pattern
*******************************************************************************/
#include <sys/inotify.h> //inotify
#include <unistd.h> //close, read
#include <dlfcn.h> //dlopen, dlclose
#include <algorithm> //foreach

#include "factory.hpp"
#include "task.hpp"
#include "plug_n_play.hpp"
namespace ilrd
{
PlugNPlay::PlugNPlay(const std::string &path_): m_dispatcher(Dispatcher<std::string>()) 
{
   m_monitor = std::make_unique<DirMonitor>(&m_dispatcher, path_);
   m_loader = std::make_unique<SOLoader>(&m_dispatcher);
}

// ----------------------------------------------------------------
PlugNPlay::DirMonitor::DirMonitor(Dispatcher<std::string> * const dispatcher_, const std::string &path_): m_dispatcher(dispatcher_)
{
    m_notify_init = inotify_init();
    m_notify_add_watch = inotify_add_watch(m_notify_init, path_.c_str(), IN_ALL_EVENTS);

    m_async_listener = std::thread(&PlugNPlay::DirMonitor::MonitorLoop, this, path_);
}

PlugNPlay::DirMonitor::~DirMonitor()
{
    inotify_rm_watch(m_notify_init, m_notify_add_watch);
    close(m_notify_init);

    m_async_listener.join();
}

void PlugNPlay::DirMonitor::MonitorLoop(const std::string &path_)
{
    char buf[BUFSIZ];

    while(true)
    {
        int bytesRead = read(m_notify_init, buf, BUFSIZ); 
        std::string temp_path = path_;
        char* ptr = buf;
        
        while (ptr < buf + bytesRead) 
        {
            struct inotify_event* event = reinterpret_cast<struct inotify_event*>(ptr);
            if (event->len > 0) 
            {
                std::string filename = event->name;

                if (filename != "." && filename != ".." && filename.find(".swp") == std::string::npos) 
                {
                    std::string temp_path =  temp_path +"/"+ filename;

                    if ((event->mask & IN_CLOSE_WRITE)||(event->mask & IN_MOVED_TO))
                    {
                        m_dispatcher->NotifyAll(temp_path);
                    }
                }
            }
            ptr += sizeof(struct inotify_event) + event->len;
        }
    }
}

// ----------------------------------------------------------------
PlugNPlay::SOLoader::SOLoader(Dispatcher<std::string> * const dispatcher_) : m_call_back(dispatcher_, *this, &PlugNPlay::SOLoader::Load)
{   
}

PlugNPlay::SOLoader::~SOLoader()
{  
    std::for_each(m_dlopen_handles.begin(), m_dlopen_handles.end(), [](void *handle){ dlclose(handle); });
}

void PlugNPlay::SOLoader::Load(const std::string &file_name_)
{
    void* handle = dlopen(file_name_.c_str(), RTLD_LAZY);
    if(NULL == handle)
    {
        //wirte to logger
    }
    else
    {
        m_dlopen_handles.push_back(handle);
    }
}
} // namespace ilrd