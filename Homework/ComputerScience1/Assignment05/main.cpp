// Mickey Mouse
// Dr. Bekkering.
// Fall 2022.
// assignment05
// This program takes a user-given amount of seconds, then gives how many days, hours, minutes, and seconds are in that amount.
// Working flawlessly from my testing
// Written on Replit, browser-based cloud storage coding site
// Referenced 7-19 for reminder on formatting functions.


#include <iostream>
#include <iomanip>

using namespace std;


// Functions.

int getDays(int secondsGiven)
{
  // Variables necessary
  int seconds;
  int days;
  int secondsCache;
  
  // Sort days first since they come first in output
  secondsCache = secondsGiven % 86400;
  seconds = secondsGiven - secondsCache;
  days = seconds / 86400;
  return days;
}
int getHours(int secondsGiven)
{
  // Variables
  int secondsCache;
  int seconds;
  int days; 
  int hours;

  // Calculate, excluding days with this if statement
  if(secondsGiven >= 86400) 
  {
    secondsCache = secondsGiven % 86400;
    seconds = secondsGiven - secondsCache;
    hours = seconds / 3600;
    return hours;
    
  }
}
int getMinutes(int secondsGiven)
{
  // Variables
  int seconds, minutes, secondsCache;

  // Calulate, exclude seconds > 1 hr
  if(secondsGiven >= 3600)
  {
    secondsCache = secondsGiven % 3600;
    seconds = secondsGiven - secondsCache;
    minutes = seconds / 60;
  }

  secondsCache = secondsGiven % 60;
  seconds = secondsGiven - secondsCache;
  minutes = seconds / 60;
  return minutes;
}
int getSeconds(int secondsGiven)
{
  // Variables
  int seconds, remainingSeconds;
  
  // Not much to do here. Just one modulo.
  remainingSeconds = secondsGiven % 60;
  return remainingSeconds;
}

int main()
{

// Variables - Store time units.
int seconds          = 0;
int minutes          = 0;
int hours            = 0;
int days             = 0;
int secondsGiven     = 0;
int secondsCache     = 0;
int remainingSeconds = 0;

// Cout formatting (No decimals)
cout << fixed << setprecision(0);
  
// Initial message.
cout << "This program takes a given number of seconds and converts to minutes, hours, and days." << endl;
cout << "Please enter a (Positive) number of seconds." << endl;
cin >> secondsGiven;

// Validate given number of seconds is positive.
while (secondsGiven < 0)
  {
    cout << "Number of seconds to use cannot be negative." << endl;
    cin >> secondsGiven;
  }

// Call functions for calculations.
days     = getDays(secondsGiven);
hours    = getHours(secondsGiven);
minutes  = getMinutes(secondsGiven);
seconds  = getSeconds(secondsGiven);

// Output if statement

cout << secondsGiven << " seconds is: ";
if(days != 0) 
{
  cout << days << " days, " << hours << " hours, "
       << minutes << " minutes, " << remainingSeconds << " seconds. "
       << endl;
} else if (hours != 0) 
{
   cout << hours << " hours, "
        << minutes << " minutes, " << remainingSeconds << " seconds. " << endl;
} else if (minutes != 0)
{
  cout << minutes << " minutes, " << remainingSeconds << " seconds. " << endl;
} else 
{
  cout << seconds << " seconds. " << endl;
}

  return 0;
}
