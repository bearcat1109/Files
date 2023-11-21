// Implementation file
#include "score.h"
#include <iostream>
#include <sstream>
#include <fstream>
#include <algorithm>

using namespace std;

vector<Score> fillList(const string& filename)
{
        // Open file, check to make sure it opened.
    ifstream inFile(filename);

    if(!inFile.is_open())
    {
        cerr << "File open error" << endl;
        // Exit if not
        return {};
    }

    // Array
    vector<Score> List;

    // Input data into list1
    string input;

    while(getline(inFile, input))
    {
        // Stringstream, object
         stringstream sFile(input);
         Score hold;

        // If there are values to read, fill them
        if(getline(sFile, hold.alphaTeam, ',')
           && getline(sFile, hold.bravoTeam, ',')
           && getline(sFile, hold.aScore, ',')
           && getline(sFile, hold.bScore, ','))
           {
                List.push_back(hold);
           }
        //else
        //{
        //    cerr << "Error in line parsing: " << input << endl;
        //}
    }

    // Finish
    inFile.close();
    return List;
}

// Display contents of list
void outputList(vector<Score> List)
{
    for(const auto& hold : List)
    {
        cout << hold.alphaTeam << " vs. " << hold.bravoTeam <<
        ": Score was " << hold.aScore << " to " << hold.bScore << "."  << endl;
    }
}

// Combine lists 1,2,3 to make list4
vector<Score> combineLists(vector<Score> list1, vector<Score> list2, vector<Score> list3)
{
  vector<Score> list4;

  //list4.insert(list4.end(), list1.begin(), list1.end());
  //list4.insert(list4.end(), list2.begin(), list2.end());
  //list4.insert(list4.end(), list2.begin(), list3.end());

  for(const auto& hold : list1)
    {
      list4.push_back(hold);
    }

  for(const auto& hold : list2)
  {
    list4.push_back(hold);
  }

  for(const auto& hold : list3)
  {
    list4.push_back(hold);
  }
  
  return list4;
}

// Used to sort list4 elements
bool teamCompare(const Score& x, const Score& y)
{
  return x.alphaTeam < y.alphaTeam;
}

// Sort list 4 (Or technically whichever one is passed)
void bubbleSortList4(vector<Score>& List)
{
  // Int g = Gabriel
  int g = List.size();
  for(int x = 0; x < g -1; x++)
    {
      for(int y = 0; y < g - x - 1; y++)
        {
          if(List[y].alphaTeam > List[y + 1].alphaTeam)
          {
            swap(List[y], List[y + 1]);
          }
        }
    }

}

// Output list 4 to file
void berresOutput(vector<Score> List)
{
  ofstream outFile;
  outFile.open("berres.txt");
  
  // To file
  for(const auto& hold : List)
  {
      outFile << hold.alphaTeam << " vs. " << hold.bravoTeam <<
      ": Score was " << hold.aScore << " to " << hold.bScore << "."  << endl;
  }

  // To terminal
  for(const auto& hold : List)
  {
      cout << hold.alphaTeam << " vs. " << hold.bravoTeam <<
      ": Score was " << hold.aScore << " to " << hold.bScore << "."  << endl;
  }

  outFile.close();
}
