#include <iostream>
#include <cstdlib>
#include <fstream>
#include <map>
#include "defineFunctions.cpp"
#include "list.cpp"



using namespace std;

int main() {
  
  // Initialize file output -
  ofstream outFile;
  outFile.open("output.txt");
  outFile.close();

  // Greeting, size
  int vectSize = 50;
  // cout << "Welcome to Data Structures. How big should the array of random numbers be?" << endl;
  // cin >> vectSize;
  
  // Vector and list
  vector<int> berres = *makeRandomVect(vectSize);
  static List intList;

  // Make vector, add to List, then store duplicates 
  vector<int> gabriel = *vecIntoList(berres, &intList);

  // Outputs (File & terminal)
  terminalOutput(berres, gabriel, intList);
  fileOutput(berres, gabriel, intList);

}
