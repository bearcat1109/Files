#include <fstream>
#include <iostream>

using namespace std;


int main() {

  // Variables/Creation
  int GBarray[10];

  // Write
  ofstream outFile;
  ifstream inFile;

  // Function
  void task1(fstream& outFile);
{
  outFile.open("output.txt");
  for(int x = 1; x < 11; x++)
    {
      outFile << x << endl;
    }
  outFile.close();
  cout << "File Write Success!" << endl;
}
  // Read
  inFile.open("output.txt");
  while(inFile)
    {
      int x = 0;
      inFile >> GBarray[x];
      cout << GBarray[x] << endl;
      x++;
    }   
  return 0;
}