#pragma once
#include "defineList.h"
#include "defineNode.h"
#include <iostream>

using namespace std;


List::List()
{
  Node *head;
}

// Insert into list
bool List::listDuplicate(int hold)
{
  Node *currentNode = head;
  Node *newNode = new Node();
  newNode->hold = hold;

  // Logic
  if(!head)
  {
    head = new Node();
    head->next = newNode;
    return true;
  }
  else while(currentNode->next)
    {
      if(currentNode->next->hold == hold)
      {
        return false;
      }
      else if(currentNode->next->hold > hold)
      {
        newNode->next = currentNode->next;
        currentNode->next = newNode;
        return true;
      }
      else
      {
        currentNode = currentNode->next;
      }
    }

  // If new element is largest, do:
  currentNode->next = newNode;

  return true;
}

int List::listLength()
{
  Node *currentNode = head;
  int x = 0;

  while (currentNode->next)
    {
      x++;
      currentNode = currentNode->next;
    }
  return x;
}

void List::listPrint()
{
  Node *currentNode = head;
  
  while(currentNode->next)
    {
      cout << currentNode->next->hold << " ";
      currentNode = currentNode->next;
      
    }
  cout << endl;
}