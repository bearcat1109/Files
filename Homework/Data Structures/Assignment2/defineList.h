#pragma once
#include "defineNode.h"

// Header for list
class List
{
  public:
    List();
    // For duplicate/not duplicate logic
    bool listDuplicate(int hold);
    void listPrint();
    int listLength();
  private:
    Node *head;
};