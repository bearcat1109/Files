#include <iostream>
#include <cstdlib>
#include <fstream>
#include <map>
#include "defineFunctions.cpp"
#include "list.cpp"



using namespace std;

int main() {
  
  // Greeting, size
  int vectSize = 50;
  // cout << "Welcome to Data Structures. How big should the array of random numbers be?" << endl;
  // cin >> vectSize;
  
  // Vector and list
  vector<int> berres = *makeRandomVect(vectSize);
  static List intList;

  // Make vector, add to List, then store duplicates 
  vector<int> dupes = *vecIntoList(berres, &intList);

  // Outputs (File & terminal)
  terminalOutput(berres, dupes, intList);
  fileOutput(berres, dupes, intList);

  ofstream outFile;
  outFile.open("output.txt");
  outFile << "test" << endl;
  outFile.close();
}