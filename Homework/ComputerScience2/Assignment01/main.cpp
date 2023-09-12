
#include <iostream>
#include <fstream>
using namespace std;

float CalculateTotal(float price, int quantity)
{
    // Calculate total.
  return price * quantity;
}

int main()
{

  float   price;
  int  quantity;
  
// Ask for units
  cout << "How many units of given thing have you purchased?" << endl;
  cin >> quantity;

// Ask for price
  cout << "What was the price per unit?" << endl;
  cin >> price;

// Calculate total.
  float total = CalculateTotal(price, quantity);

// Display results.
  cout << "Your total was: " << total << "." << endl;

// File writing with for() loop
// Open file
  ofstream outFile;  outFile.open("input.txt");
  
// Write to file
  cout << "File opened, beginning writing." << endl;
  for(int i = 1; i < 11; i++)
    {
      cout << i * i << endl;
      outFile << i * i << endl;
    }
// Close file
  outFile.close();
  cout << "File closed, done writing." << endl;

// Read the file using for-loop.
// Open file.
  ifstream inFile; inFile.open("input.txt");

// Read the file.
  cout << "Opened the file for reading. (For-loop)" << endl;
  int x;   // Used in reading process
  for(int i = 1; i < 11; i++)
    {
      inFile >> x;
      cout << x << " ";
    }
  cout << endl;
// Close the file.
  inFile.close();
  cout << "File closed, done reading." << endl;
// Reset for While-Loop
  cout << "***************************************" << endl;
  inFile.open("input.txt");
  cout << "Opened file to read using while-loop." << endl;
  while (inFile >> x)        // Read until no longer possible
    {
      cout << x << " ";
    }
  cout << endl;
  inFile.close();
  cout << "Closed file for while-loop reading." << endl;

  char ch; cin >> ch;    // This will keep the window open until a key press.
}
