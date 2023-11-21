// Header file

#pragma once
#include <iostream>
#include <string>
#include <vector>

using namespace std;

// Score struct
struct Score 
{
    string alphaTeam;
    string bravoTeam;
    string aScore;
    string bScore;
};

vector<Score> fillList(const string& filename);
void outputList(vector<Score> List);
vector<Score> combineLists(vector<Score> list1, vector<Score> list2, vector<Score> list3);
bool teamCompare(const Score& x, const Score& y);
void bubbleSortList4(vector<Score>& List);
void berresOutput(vector<Score> List);
