// Lab 7-2 Friday, October 28, 2022


// Libraries
#include <iostream>
#include <fstream> 

using namespace std;

// Array constant
const int ARRAY_SIZE = 9;

// Arrays
void getBiggest(int nums[])
{
  // Variable for inside here only
  int biggest;
  biggest = nums[0];

  // Get biggest number
  for(int y = 0; y < ARRAY_SIZE; y++)
    {
      if(nums[y] > biggest)
      {
        biggest = nums[y];
      }
    }

  cout << "Biggest number in the file is: " << biggest << endl;
}
void getSmallest(int nums[])
{
  // Variables for getSmallest
  int smallest;
  smallest = nums[0];
  
    for(int y = 0; y < ARRAY_SIZE; y++)
    {
      if(nums[y] < smallest)      // If statement for getSmallest
      {
        smallest = nums[y];
      }
    }
  cout << "Smallest number in the file is: " << smallest << endl;
  
}

int main()
{
  // Get inFile command, declare variables
  ifstream inFile;
  int nums[ARRAY_SIZE], biggest, smallest;

  // Initialize file
  inFile.open("TenNumbers.txt"); 

  // Ask initial prompt
  cout << "Let's get 10 numbers. \n";
  
  // Counted loop
  for(int g = 0; g < ARRAY_SIZE; g++)
    {
      // Input numbers from file into array
      inFile >> nums[g]; 
    }

  // Call functions
  getBiggest(nums);
  getSmallest(nums);

  return 0;
}


