#include <cstdlib>
#include <ctime>
#include <vector>
#include <fstream>
#include <string>
#include "list.cpp"


using namespace std;



vector<int> * makeRandomVect(int vectSize)
{
  vector<int> *berres = new vector<int>;

  // Seed rand with 0
  srand(time(0));

  for(int g = 0; g < vectSize; g++)
    {
      berres->push_back(rand() % 100 + 1);  
    }
  return berres;
}

vector<int> * vecIntoList(vector<int> inVector, List * inList)
{
  // Declare
  vector<int> * gabriel = new vector<int>;
  // If bool = 0 in duplicate logic, places number in gabriel vector
  for(int val: inVector)
    {
      if(!inList->listDuplicate(val))
      {
        gabriel->push_back(val);
      }
    }
  return gabriel;
}

void terminalOutput(vector<int> berres, vector<int> gabriel, List intList)
{
  // Output numbers
  cout << endl << "Random numbers: (berres):";
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
  cout << "With duplicates removed: (gabriel): ";
  for(int val: gabriel)
    {
      cout << val << " ";
    }

  // Line break
  cout << endl;
}

void fileOutput(vector<int> berres, vector<int> gabriel, List intList)
{
  ofstream outFile;
  outFile.open("output.txt", ios::out);
  // Was using outFile with the same commands as above, but this was causing some weird glitching issues when
  // outputting to file - so I used a buffer redirecting cout statements to the file.
  streambuf* cout_backup = cout.rdbuf();
  streambuf* file_buffer = outFile.rdbuf();
  cout.rdbuf(file_buffer);

  // Output numbers
  cout << endl << "Random numbers: (berres):";
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
  cout << "With duplicates removed: (gabriel): ";
  for(int val: gabriel)
    {
      cout << val << " ";
    }

  // Line break
  cout << endl;

  cout.rdbuf(cout_backup);

  outFile.close();
}
