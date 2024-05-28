/*******************************************************************************
* Name: Aya
* Date: 19.03.24
* Version: 0.1
* Description: 
*******************************************************************************/
#ifndef ILRD_HRD32_LOGGER_HPP
#define ILRD_HRD32_LOGGER_HPP

#include <string>   //  string
#include <thread>   //  std::thread
#include <fstream>
#include <mutex>

#include "singleton.hpp"
#include "waitable_queue.hpp"

namespace ilrd
{

class Logger
{
public:
    enum class LevelType
    {
        INFO = 0,
        WARNING = 1,
        ERROR
    };

    Logger(const Logger& o) = delete;
    Logger& operator=(const Logger& o) = delete;
    Logger(Logger&& o) = delete;
    Logger& operator=(Logger&& o) = delete;

    void Log(LevelType level, const std::string& message, size_t line, const std::string& file);
    void SetLogFile(const std::string& file);  // Support thread safe.
    void SetLogLevel(LevelType level); // Support thread safe.

private:
    Logger(const std::string& file_path = "./log.txt", LevelType level = LevelType::ERROR );
    ~Logger();

    static std::string CreateMsg(const std::string& message, size_t line, const std::string& file);

    std::mutex m_mutex;
    std::ofstream m_file;
    std::atomic<LevelType> m_level;
    std::thread m_thread;
    ilrd::WaitableQueue<std::string> m_wqueue;

    bool m_thread_running;

    friend class Singleton<Logger>;

    void ThreadFunc();
};

}//namesapce ilrd

#endif  //  __ILRD_HRD32_LOGGER_HPP