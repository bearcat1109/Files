#pragma once

class Car
{
public:
  Car();   // Default constructor
  Car(int starting_x, int starting_y);   // Value Pass

// Get copies of x, y
int get_x() const;
int get_y() const;

// Adjust x, y
int set_x();
int set_y();

private:
int x, y;
};