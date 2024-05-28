#include <iostream>
#include <unistd.h>

#include "msg_broker.hpp"

using namespace ilrd;
using namespace std;

class Thermostat
{
public:
    Thermostat(Dispatcher<double>* dis_);
    ~Thermostat() = default;
    Dispatcher<double>* GetDis();
private:
    Dispatcher<double>* m_dis;
};

Thermostat::Thermostat(Dispatcher<double>* dis_): m_dis(dis_)
{
}

Dispatcher<double>* Thermostat::GetDis()
{
    return m_dis;
}

//----------------------------------------------------------------
class AC
{
public:
    AC() = default;
    ~AC() = default;
    void Update(const double& new_);
private:
};

void AC::Update(const double& new_)
{
    if(25 < new_)
    {
        cout << "turn on AC" << endl;
    }
    else
    {
        cout << "turn off AC" << endl;
    }
}

//----------------------------------------------------------------
class FA
{
public:
    FA() = default;
    ~FA() = default;
    void Update(const double& new_);
    void Disconnect();
private:
};

void FA::Update(const double& new_)
{
    if(30 < new_)
    {
        cout << "turn on FA" << endl;
    }
    else
    {
        cout << "turn off FA" << endl;
    }
}

void FA::Disconnect()
{
    cout << "Cleanup resources" << endl;
}

//----------------------------------------------------------------
int main()
{
    Dispatcher<double> dispatcher;
    Thermostat ther(&dispatcher);
    AC ac;
    FA fa;
    
    ICallBack<double>* ac_sub = new CallBack<double, AC>(ther.GetDis(), ac, &AC::Update);
    ICallBack<double>* fa_sub = new CallBack<double, FA>(ther.GetDis(), fa, &FA::Update, &FA::Disconnect);

    ther.GetDis()->NotifyAll(12);


    sleep(10);
    return 0;
}
