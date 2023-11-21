// Assignment 5 Data Structures
// Started 11-15 Gabriel Berres

// Setup
#include <iostream>
#include <cstdlib>
#include <map>
#include <sstream>
#include <fstream>
#include <vector>
#include <algorithm>
#include "score.h"

using namespace std;

int main()
{
    // Declare arrays of Score and fill
    string filename;
    vector<Score> list1 = fillList("list1.txt");
    vector<Score> list2 = fillList("list2.txt");
    vector<Score> list3 = fillList("list3.txt");
    
    // Display filled arrays
    //outputList(list1);
    //outputList(list2);
    //outputList(list3);

    // Make list4
    vector<Score> list4 = combineLists(list1, list2, list3);
    // Sort list4, output sorted list to berres.txt
    bubbleSortList4(list4);
    berresOutput(list4);


    return 0;
}


/*
Panthers,Bears,13,16
Colts,Patriots,10,6
Browns,Ravens,33,31
Saints,Vikings,19,27
49ers,Jaguars,34,3
Texans,Bengals,30,27
Packers,Steelers,19,23
Titans,Buccaneers,6,20
Lions,Chargers,41,38
Falcons,Cardinals,23,25

Nets,Heat,115,122
Thunder,Warriors,128,109
Mavericks,Wizards,130,117
Celtics,79ers,117,107
Knicks,Hawks,116,114
Bucks,Raptors,128,112
Magic,Bulls,96,94
Timberwolves,Suns,115,133
Kings,Lakers,125,110
Cavaliers,TrailBlazers,109,95

Australia,Bangladesh,7,0
Thailand,ChinaPR,1,2
Qatar,Afghanistan,8,1
Gabon,Kenya,2,1
Cyprus,Spain,1,3
Bolivia,Peru,2,0
Venezuela,Ecuador,0,0
Columbia,Brazil,2,1
Argentina,Uruguay,0,2
LosEstadosUnidos(USA),Trinidad,3,0
*/
