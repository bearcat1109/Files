// Gabriel Berres.
// Dr. Bekkering - no need to change anything here. This is just the instructor name
// Fall 2022
// assignment04
// My program reads 12 numbers at a time in each row of Sales.txt, then gives a total per line (year). The program does this 10 times for 10 years. It then gives a grand total from all 10 years of sales.
// Status: Working Perfectly
// Compiler Used: I use the site Replit mostly for code writing and some use of Visual Studio Code w/ built in Linux compiler on my laptop.
// No files used
// Help: Just some idea bouncing between myself and Jonathan.

#include <iostream>
#include <fstream>
#include <iomanip>
#include <cstdlib> 
#include <array>
using namespace std;


// This program reads the numbers from a file Sales.txt.

// Variables:

double yearTotal;      // Total of an entire line, one year
double fullTotal;      // Total of all ten years
string file;           // Used for valid file check

const int NUMS = 12;   // Number count for Arrays

double row[NUMS];      // Row Array 
                       // Ints x and y used in their appropriate for() loops.

// Main function. 

int main()
{
  cout << "This program shows sales data for ten years. " << endl;
  cout << "Please enter the name of the file to be read. (Sales.txt)" << endl;
  cin >> file;

// Check for file name validity

  while(file != "Sales.txt")
  {
    cout << "This is not a valid file. Please enter the correct name." << endl;
    cin >> file;
  }

// Initializing file reading
  
ifstream inFile;
inFile.open("Sales.txt");

// Output organization
  
cout << fixed << showpoint;
setprecision(144);

// Months output 
  
cout << "JAN     FEB     MAR     APR     MAY     JUN      JUL     AUG     SEPT      OCT     NOV      DEC   Year " << endl;
  
// File reading and writing
  
for(int x = 1; x < 10; x++)
  {
    yearTotal = 0;
    for(int y = 0; y < 11; y++)
      {
      inFile >> row[x];
      yearTotal += row[x];
      cout << row[x] << " ";
      }
    fullTotal += yearTotal;
    cout << yearTotal << endl;
  }
cout << "Total for all ten years: " << fullTotal << endl;

return 0;
}