/*1. Open a file from main, called “binary_output.txt”, and write it as a binary file.
Then pass this file stream operator by reference to another function.
In this function you will do the file output itself:
Create an array of 100 numbers, 1 through 100, and write this array to the binary file.
Close the binary file, open it again, and then read from the file. Copy the file contents into a second array, and then print the array.

2. Create a class named Myclass that has the interface and implementation. Also add a main function to use the class. The class must have one integer variable, accessor function, mutator function, default constructor, and value pass constructor.
Include screenshots of your running program(s).
*/

#include <iostream>
#include <fstream>

using namespace std;

// Class for pt. 2 of Assignment
class Myclass
  {
private:
  int x; int y;

public:
  Myclass();    // Default constructor
  Myclass(int start_x, int start_y);   // Value passing constructor

  void changeX(int something); void changeY(int something);

// Accessors
  int getX() const;
  int getY() const;
  };

// Implement.
Myclass::Myclass() { x = 0; y = 0;}
Myclass::Myclass(int start_x, int start_y){ x = start_x; y = start_y;}




int main()
{
  // Filestream objects
  ifstream inFile;
  ofstream outFile;

  // Initialize Array
  int GBarray[100];
  for(int x = 0; x < 100; x++)
    {
      GBarray[x] = (x+1);
    }
  cout << "To check, GBarray is: " << GBarray[99] << endl;

  // Open File, Write, Close
  outFile.open("binary_output.txt", ios::binary);
  //GBarray,sizeof(GBarray));
  outFile.write(reinterpret_cast<char *>(&GBarray),sizeof(GBarray));
  outFile.close();

  // Open File, Read, Close
  inFile.open("binary_output.txt", ios::binary);
  int secondArray[100];
  inFile.read(reinterpret_cast<char *>(&secondArray),sizeof(secondArray));
  inFile.close();
  
  // Display new array contents
  for(int x = 0; x < 100; x++)
    {
      cout << secondArray[x] << endl;
    }



  return 0;
}
