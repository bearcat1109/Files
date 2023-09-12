#pragma once
#include "defineNode.h"
#include <string>

using namespace std;

// Header for list
class List
{
  public:
    List();
    // For duplicate/not duplicate logic
    bool listDuplicate(int hold);
    void listPrint();
    string listPrintString();
    int listLength();
  private:
    Node *head;
};
