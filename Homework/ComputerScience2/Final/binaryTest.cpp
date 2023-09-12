//This program tests a binary function for question 5 of the final.
#include <iostream>
#include <fstream>
#include <cstdlib>

using namespace std;

int main()
{
  // Initialize array
  float binary1[10];
  float binary2[10];

  // Make Binary1 decimals
  for(int x = 0; x < 10; x++)
    {
      binary1[x] = (x * 1.11);
     // cout << binary1[x] << endl;   // Test number assignment is working. 
    }
  
  // Initialize filestream, Open file
  ofstream outFile;
  outFile.open("binary-output.txt", ios::binary);
  for(int x = 0; x < 10; x++)
    {
      outFile << binary1[x] << endl;
    }
  outFile.close();

  // Open File for input
  ifstream inFile;
  inFile.open("binary-output.txt", ios::binary);
  for(int x = 0; x < 10; x++)  // Read in from file, change binary2 contents
    {
      inFile >> binary2[x];
      cout << "Contents of binary2 index " << x << " is: " << binary2[x] << "." << endl;
    }
  inFile.close();

  return 0;
}