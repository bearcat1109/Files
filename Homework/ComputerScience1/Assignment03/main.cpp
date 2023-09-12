// Gabriel Berres
// Dr. Bekkering.
// Fall 2022.
// assignment03
// This assignment takes x amount of times to generate a number between 1-25 and then calculate average results.
// Not functioning yet but getting there.
// I used VS Code with "PopOS!" Linux's default compiler.
// Files used : Pr3-17 for reference on output charts, pr3-25 for reference on random numbers, Textbook Ch. 5
// Help: Dr. Bekkering


#include <iostream>
#include <cstdlib>
#include <iomanip>
#include <fstream>
#include <random>
using namespace std;


int main()
{

    // Variables for user's selected number of numbers

    int numChoice;
    int loopTimes;

    // Variables used for averaging process

    int total;
    int line;
    int firstFifty;
    int firstTwoFifty;

    // Minimum, Maximum. Changing here will edit throughout the program.

    const int MIN = 1;
    const int MAX = 25;

    // Setting up random number generation

    random_device engine;
    uniform_int_distribution<int> output(MIN, MAX);


    // Initial user interaction

    cout << "This program generates randomm numbers between 1 and 25." << endl;
    cout << "How many times should the process run? Please enter a number between 100 and 999." << endl;
    cin >> loopTimes;
    while (loopTimes < 100 || loopTimes > 999)          // Make sure entry is valid
    {
        cout << "Invalid number, please enter one between 100 and 999." << endl;
        cin >> loopTimes;
    }
    cout << loopTimes << " numbers will be written to the file random.txt" << endl;


    //Open file

    ofstream outFile;
    outFile.open("random.txt");

    //Calculation

    for (int x = 0; x < loopTimes; x++)
    {
        outFile << output(engine) << endl;
    }

    outFile.close();

    // Open File

    ifstream inFile;
    inFile.open("random.txt");

    // Display results 

    cout << "Reading from file random.txt." << endl;
    cout << "The results from the first 50 numbers have the following frequencies: " << endl;
    cout << "Number        Occurences" << endl;
    // The number of occurences for numbers would go here but I could not find a solution.

    // Grab average of first 50

    for (int x = 1; x < 50; x++)
    {
        inFile >> line;
        total += line;
    }
    firstFifty = (total / 50);
    cout << "The average of these numbers is: " << firstFifty << "." << endl;

    // Results of first 250

    cout << "Reading from file random.txt." << endl;
    cout << "The results from the first 250 numbers have the following frequencies: " << endl;
    cout << "Number        Occurences" << endl;
    // The number of occurences for numbers would go here but I could not find a solution.


    // Average

    for (int x = 1; x < 50; x++)
    {
        inFile >> line;
        total += line;
    }
    firstTwoFifty = (total / 250);
    cout << "The average of these numbers is: " << firstTwoFifty << "." << endl;

    return 0;

}