#include <iostream>
#include <fstream>

using namespace std;

int dailyCycles;
float hold;
float lifetimeMileage;
float moonPercent;

int main() 
{
// Enter number of cycles done today.
  cout << "BikeCyclesTracker v1.0." << endl;
  cout << "Hello, Gabriel. How many cycles did you run on your stationary bike today?" << endl;
  cin >> dailyCycles;
// Read from File
  ifstream inFile;
  inFile.open("record.txt");
  inFile >> hold;
  inFile.close();
// Add today's total to cache
  hold += dailyCycles;
// Output updated total.
  ofstream outFile;
  outFile.open("record.txt");
  outFile << hold;
  outFile.close();
// Make lifetime cycles into miles.
  lifetimeMileage = hold / 1500;
// Calculate percent of distance to the moon.
  moonPercent = hold / 238855;
// Update user.
  cout << "Thank you. Today you ran " << dailyCycles << " cycles on your bike. This brings your lifetime total to " << hold << " cycles on your bike. That's " << lifetimeMileage << " Miles. Or, if you're interested, " << moonPercent << "% of the way to the moon. Get those leg gains!" << endl;
// 238,855
return 0;

}