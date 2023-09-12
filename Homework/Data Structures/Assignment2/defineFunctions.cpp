#include <cstdlib>
#include <ctime>
#include <vector>
#include <fstream>
#include "list.cpp"


using namespace std;



vector<int> * makeRandomVect(int vectSize)
{
  vector<int> *berres = new vector<int>;

  // Seed rand with 0
  srand(time(0));

  for(int g = 0; g < vectSize; g++)
    {
      berres->push_back(rand() % 58 + 1);  
    }
  return berres;
}

vector<int> * vecIntoList(vector<int> inVector, List * inList)
{
  // Declare
  vector<int> * dupes = new vector<int>;
  // If bool = 0 in duplicate logic, places number in dupes vector
  for(int val: inVector)
    {
      if(!inList->listDuplicate(val))
      {
        dupes->push_back(val);
      }
    }
  return dupes;
}

void terminalOutput(vector<int> berres, vector<int> dupes, List intList)
{
  // Output numbers
  cout << endl << "Random numbers: ";
  for(int val : berres)
    {
      cout << val << " ";
    }
  cout << endl;
  
  // Print list
  cout << "Contents of list:  " ;
  intList.listPrint();
  
  // Length 
  cout << "Length of list:  " << intList.listLength() << endl;

  // Remove duplicates
  cout << "With duplicates removed:  ";
  for(int val: dupes)
    {
      cout << val << " ";
    }

  // Line break
  cout << endl;
}

void fileOutput(vector<int> berres, vector<int> dupes, List intList)
{
  ofstream outFile;
  outFile.open("output.txt", ios::out);


  outFile << "Random numbers:   ";
  for(int val: berres)
    {
      outFile << val << " ";
    }
  outFile << endl;

  cout << "Contents of List:   ";
  intList.listPrint();

  outFile << "Length of list: " << intList.listLength() << endl;

  outFile << "With duplicates removed: ";
  for(int val : dupes)
    {
      outFile << val << " ";
    }
  outFile.close();
}