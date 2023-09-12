#include <iostream>
#include <fstream> 
#include <cstdlib>

using namespace std;

int main()
{
// Variables
int nums[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
int *ptr = &nums[0];
int i = 0;
int x = 1;
// Code
while(x < 11)
{
cout<<"The values in the array are: ";
   for(int i = 0; i < 10; i++) {
      cout<< *ptr <<" ";
      ptr++;
     x++;
   }
 }
return 0;
}

