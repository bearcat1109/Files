#include <iostream> 
#include "car_header.h"


using namespace std;

int main()
{
  
Car c;
Car *x = new Car();
cout << "Contents of x are: " << c.get_x() << endl;
cout << "Contents of y are: " << c.get_y() << endl;

return 0;
}