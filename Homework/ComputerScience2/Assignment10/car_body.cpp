#include <iostream>
#include "car_header.h"
using namespace std;

Car::Car()
{
  x = 1;
  y = 2;
}

Car::Car(int starting_x, int starting_y)
{
  x = starting_x;
  y = starting_y;
}

int Car::get_x() const
{
  return x;
}

int Car::get_y() const
{
  return y;
}