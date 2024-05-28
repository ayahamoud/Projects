#include <ctime>
#include <iostream>

#include "logger.hpp"

int main()
{
    using namespace ilrd;

    Logger *logger = Singleton<Logger>::GetInstance();

    logger->SetLogLevel(Logger::LevelType::INFO);
    logger->Log(Logger::LevelType::ERROR, "ERROR1", __LINE__, "test_logger.cpp");
    logger->Log(Logger::LevelType::INFO, "INFO", __LINE__, "test_logger.cpp");
    return 0;
}

