/*
#include <iostream>
#include <string>
#include <array>

using namespace std;

void ArraySwap(char[], char[]);

int main()
{
// Make Arrays - size of 12 to avoid being too short.
char array1[] = "sasazuki";
char array2[] = "haruna";
// Initial
cout << "Array 1 initially is: " << array1 << ", and Array 2 initially is: " << array2 << endl;

ArraySwap(array1, array2);    // Change 

// Display 
cout << "Array 1 now is: " << array1 << ", and Array 2 now is: " << array2 << endl;

return 0;
}

// Function Definition
void ArraySwap(char* array1, char* array2)
{    
  int x = 0;
  while(true)
    {
      char holder = array1[x];
      array1[x] = array2[x];
      array2[x] = holder;
      x++;
      if(array1[x] == '\0' && array2[x] == '\0')
      {
        break;
      }
    }
};

*/

// Old code

//cout << "Array 1 is: " << array1[] << ", and Array 2 is: " << array2[] << endl;

/*
    
    char holder[12];
    holder[] = array1[];
    array1[] = array2[];
    array2[] = holder[];
  return array1[];
  return array2[];
*/