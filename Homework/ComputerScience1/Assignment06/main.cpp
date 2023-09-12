// Assignment 06




#include <iostream>
#include <fstream>

using namespace std;

// Initialize prototypes
float ShowSmallest(float[], int);
float ShowLargest(float[], int);
void ShowSorted(float[], int);
void swap(int&, int&);

int main()
{
    // Variables
    const int SIZE = 25;
    float MyFloats[SIZE];
    float largest, smallest;
    
    // Get inFile command, open file
    ifstream inFile;
    inFile.open("floats.txt");

    // Input numbers into MyFloats
    for(int x = 0; x <= 24; x++)
    {
        inFile >> MyFloats[x];
    }

// Call functions
smallest = ShowSmallest(MyFloats, SIZE);
largest = ShowLargest(MyFloats, SIZE);
ShowSorted(MyFloats, SIZE);

// Output results
  
 // Display smallest/largest
   cout << "The smallest value was: " << smallest << ". " << endl;

   cout << "The largest value was: " << largest << ". " << endl;

 // Display the sorted array.
   cout << "The array in sorted order is:\n";
   for (auto element : MyFloats)
      cout << element << " ";
   cout << endl;

    return 0;
}


// Function ShowSmallest

float ShowSmallest(float MyFloats[], int size)
{
  float smallest = MyFloats[0];
  
    for(int i = 0; i <= 24; i++)
    {
        if(MyFloats[i] < smallest)
        {
            smallest = MyFloats[i];
        }
    }
    return smallest;
}

float ShowLargest(float MyFloats[], int size)
{
  float largest = MyFloats[0];
  
    for(int i = 0; i <= 24; i++)
    {
        if(MyFloats[i] > largest)
        {
            largest = MyFloats[i];
        }
    }
    return largest;
}

// Function ShowSorted

void ShowSorted(float MyFloats[], int size)
{
   int maxElement;
   int index;

   for (maxElement = size - 1; maxElement > 0; maxElement--)
   {
      for (index = 0; index < maxElement; index++)
      {
         if (MyFloats[index] > MyFloats[index + 1])
         {
            swap(MyFloats[index], MyFloats[index + 1]);
         }
      }
   }
}

// Function swap

void swap(int &a, int &b)
{
   int temp = a;
   a = b;
   b = temp;
}


/* display for sort
   // Display the sorted array.
   cout << "The sorted values:\n";
   for (auto element : values)
      cout << element << " ";
   cout << endl;
*/