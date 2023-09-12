#include <iostream>
#include <vector>
using namespace std;

// 2
void swap(int &a, int &b) { int hold; hold = a; a = b; b = hold;}

int main()
{
  vector<int> x(5,0);
  x[0] = 14;
  x[1] = 3;
  x[2] = 9;

  
    swap(x[0], x[2]);
    swap(x[1], x[3]);

  for(int i = 0; i < 4; i++)
    {
      cout << x[i] << ", ";
    }
    

  return 0;
}


// 3
/*
void dostuff(vector<char> a[], vector<char> b[]);

int main()
{
  vector<char> s1 = "PAPOA";
  vector<char> s2 = "WEHLO";
  
  dostuff(s1, s2);
  cout << s1;

  return 0;
}

void dostuff(vector<char> a[], vector<char> b[])
{
  a[0] = 'Y';
  a[2] = b[2];
  a[4] = b[4];
  
}
*/

// 4
/*
int main()
{
  const int ROWS = 2, COLS = 3;
  vector<int> a[ROWS] [COLS] = { {2, 4, 6}, {7, 5, 3} };

  for(int i = 0; i < ROWS; i++) 
    {
      for(int j = 0; j < COLS; j++)
        cout << a[i] [j] << ", ";
    }

  cout << endl;

  return 0;
}

*/
// 5
/*
int main()
{
  const int ROWS = 2, COLS = 3;
  char a[ROWS] [COLS] = { {'P', 'A', 'S'}, {'A', 'U', 'N'} };

  for(int i = 0; i < ROWS; i++)
    {
        for(int j = 0; j < COLS; j++)
          if( i + j > 2)
              cout << a[i] [j];
      
    }
  cout << endl;

  return 0;
}
*/


// 2 : the sequel
/*
void swap(int &a, int &b) { int hold; hold = a; a = b; b = hold;}

int main()
{
  vector<int> x = {14, 3, 9};
    swap(x[0],x[2]);
    swap(x[1], x[3]);

  for(int i = 0; i <4; i++)
    {
      cout << x[i] << ", ";
    }
    

  return 0;
}
*/





/*
int main()
{
  int myArray[10]; 
  vector<int> myVector(10, 0);       // Make sure to put something in the vector.
  
  for(int i = 0; i < 10; i++)
    {
      myArray[i] = i*i;
      myVector[i] = i * i;
      
      cout << "myArray = " << myArray[i] << endl;
      cout << "myVector[i] = " << myVector[i] << endl;
    }


  
}
*/