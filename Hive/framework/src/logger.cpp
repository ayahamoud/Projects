/*******************************************************************************
* Name: Aya
* Date: 19.03.24
* Version: 0.1
* Description: 
*******************************************************************************/
#include <system_error>

#include "logger.hpp"

namespace ilrd
{
void Logger::ThreadFunc()
{
    while(m_thread_running || !m_wqueue.Empty())
    {
        std::string msg;
        if(m_wqueue.Pop(std::chrono::milliseconds(2), msg))
        {
            m_file << msg << std::endl;
        }
    }
}

void Logger::Log(LevelType level, const std::string& message, size_t line, const std::string& file)
{    
    LevelType currentLevel = m_level.load(std::memory_order_acquire);
    
    if(static_cast<int>(level) < static_cast<int>(currentLevel))
    {
        return;
    }
    
    m_wqueue.Push(CreateMsg(message, line, file));
}

void Logger::SetLogFile(const std::string& file)
{
    std::unique_lock<std::mutex> lock(m_mutex);
    m_file.close();
    m_file.open(file, std::ios::app);
}

void Logger::SetLogLevel(LevelType level)
{
    std::unique_lock<std::mutex> lock(m_mutex);
    m_level = level;
}

Logger::Logger(const std::string& file_path, LevelType level): m_file(std::ofstream(file_path, std::ios::app)), m_level(level), m_thread_running(true)
{
    m_thread = std::thread(&Logger::ThreadFunc, this);
}

Logger::~Logger()
{
    m_thread_running = false;

    try
    {
        m_thread.join();
    }
    catch(const std::system_error& e)
    {
        std::cerr << e.what() << '\n';
    }
}

std::string Logger::CreateMsg(const std::string& message, size_t line, const std::string& file)
{
    time_t now = time(0);
    std::string dt = ctime(&now);
    std::string ret_msg = dt + message + ". at line" + std::to_string(line) + ", file: " + file+ "\n";

    return ret_msg;
}
}