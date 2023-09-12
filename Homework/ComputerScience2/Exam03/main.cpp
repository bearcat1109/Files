#include <iostream>
#include <string>
#include <fstream>

using namespace std;

class Myclass
  {

public:
  int x; int y;
  Myclass();    // Default constructor
  Myclass(int start_x, int start_y);   // Value passing constructor

  void changeX(int something); void changeY(int something);
// Accessors
  int getX() const;
  int getY() const;
  };


int main()
{
  // Implement.
Myclass::Myclass() { x = 0; y = 0;}
Myclass::Myclass(int start_x, int start_y){ x = start_x; y = start_y;}

  return 0;
}








 /* // Array of structure
  struct GBStruct
  {
  string exam3[9];
  };
  // Input into GBarray
  ifstream inFile;
  inFile.open("input.txt");
  for(int x = 0; x < 10; x++)
    {
      inFile >> GBStruct.exam3[x];
    }
  */
  // Filestream