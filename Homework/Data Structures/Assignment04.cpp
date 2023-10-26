// Assignment04, Data Structures, Due Oct.28
// Author: Gabriel Berres

// Setup
#include <iostream> 
#include <string>
#include <iomanip>
#include <sstream>
#include <vector>


using namespace std;

struct card 
{
    string suit, type, design;
    int points;
    string name() 
    {
     return type + " of " + suit + "s";   
    }
};

// Variables needed for functions
card deck1[52];
string suitOptions[4] = {"♠","♣","♡","♢",};
int playerPoints, botPoints = 0;

// Declare
void createCards(card deck1[], string suitOptions[]);
void swap(card &card1, card &card2);
void shuffleCards(card deck1[]);
void drawPlayerHand(card deck1[], int& playerPoints, int& botPoints);


int main()
{
  
    // Declarations
    string suit, type, design;
    int points;

    // Create, then output
    createCards(deck1, suitOptions);
  
    cout << "Cards, unshuffled: " << endl;
    for(int x = 0; x < 52; x++)
    {
        cout << deck1[x].type << " of " << deck1[x].suit << ",  ";
    }
    cout << endl;
    cout << "Unshuffled cards finished." << endl;
  
    // Shuffle, then output

    shuffleCards(deck1);
  
    cout << endl << "Cards, shuffled: " << endl;
    for(int x = 0; x < 52; x++)
    {
        cout << deck1[x].type << " of " << deck1[x].suit << ",  ";
    }
    cout << endl;
    cout << "Shuffled cards finished." << endl;

    drawPlayerHand(deck1, playerPoints, botPoints);
  
return 0;
}

// Define functions

void createCards(card deck1[], string suitOptions[])
{
    int cardNum = 0;
    // Create cards 2-10, J, Q, K, A of all suits
    for (int s = 0; s < 4; s++)
    {
        for (int x = 2; x <= 14; x++)
        {
            string type;
            card t; // temp

            if (x == 14)
            {
                type = "A";
            }
            else if (x == 13)
            {
                type = "K";
            }
            else if (x == 12)
            {
                type = "Q";
            }
            else if (x == 11)
            {
                type = "J";
            }
            else if (x < 11)
            {
                type = to_string(x);
            }

            // Assign values
            t.suit = suitOptions[s];
            t.type = type;
            t.points = x;

            // Generate card
            deck1[cardNum] = t;
            cardNum++;
        }
    }
}


  // Swap needed for shuffle
void swap(card &card1, card &card2)
  {
      card t; //temp
      t = card1;
      card1 = card2;
      card2 = t;
  }

  // Shuffle function
void shuffleCards(card deck1[])
{
    // Time for srand seed
    srand(time(0));
    // 208 = 52*4
    for(int x = 0; x < 208; x++)
    {
        // Shuffle deck x4 times
        int s1, s2;
        s1 = rand()%52;
        s2 = rand()%52;
        swap(deck1[s1], deck1[s2]);
    }
}

// Draw Hand, do winning math
void drawPlayerHand(card deck1[], int& playerPoints, int& botPoints)
{
  cout << "Player drew: ";
  for(int x = 0; x < 6; x++)
    {
      playerPoints += deck1[x].points;
      cout << deck1[x].type << " of " << deck1[x].suit << "s,";
    }
  cout << "... totalling " << playerPoints << " points." << endl;

  // Draw cards 6-10 for the bot
  for(int x = 6; x < 11; x++)
    {
      botPoints += deck1[x].points;
    }
  cout << "Robot's hand was worth " << botPoints << " points." << endl;

  if(playerPoints > botPoints)
  {
    cout << "Player wins! Thank you for playing assignment4." << endl;  
  }
  else if (playerPoints == botPoints)
  {
    cout << "It's a tie! Thank you for playing assignment4." << endl;
  }
  else
  {
    cout << "Bot wins.. :( Thank you for playing, though!" << endl;
  }
}
