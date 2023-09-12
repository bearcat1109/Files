/*
Create one .cpp file that contains a class: it needs the interface and list of functions/methods, the contents of those functions/methods, including a default and value pass constructor, and then implement the class in main() by creating objects using the default and value pass constructors. Use all the methods/functions appropriately. Name the class Book and give it variables for current page, title, author. Include screenshots of your running program. 
*/

#include <iostream>
#include <string>

using namespace std;

// Class 'Book'
class Book
  {
public:
  Book(); // Default constructor
  Book(int starting_pageNum, string starting_title, string starting_author);

// 'Getters' aka Accessors
int get_page() const;
string get_title() const;
string get_author() const;

// Setters
void set_page(int what);
void set_title(string what);
void set_author(string what);

private:
  // Page number, title, author
  int pageNum;
  string title, author;
};

 Book::Book()
{
  pageNum = 250;
  title = "The Lord of the Rings";
  author = "JRR Tolkien";
}
// Default constructor
Book::Book(int starting_pageNum, string starting_title, string starting_author)
{
  author = starting_author;
  title = starting_title;
  pageNum = starting_pageNum;
  
}


// Implementations
int Book::get_page() const
{
  return pageNum;
}
string Book::get_title() const
{  
  return title;
}
string Book::get_author() const
{ 
  return author;
}
void Book::set_page(int what)
{
  pageNum = what;
}
void Book::set_title(string what)
{
  title = what;
}
void Book::set_author(string what)
{
  author = what;
}

int main() 
{
  // Implement class
  Book c;
  Book a_class(250, "The Lord of the Rings", "JRR Tolkien");
  cout << "Book 1 contents: " << endl;
  cout << c.get_title() << endl;
  cout << "Written by: " << c.get_author() << endl;
  cout << " Page count: " << c.get_page() << endl;
  c.set_page(300); 
  c.set_title("Halo: The Fall of Reach");
  c.set_author("Eric Nylund");
  cout << "Book 2 Contents: " << endl;
  cout << c.get_page() << " Pages, " << c.get_title() << " Written by " <<  c.get_author() << endl;

  
  return 0;
}
/*

Example from class 4/10:

 The_class c; The_class a_class("bob", 100);
 cout << "class c contents": << endl;
 cout << c.get_the_name() << " " << c.return_the_variable() << endl;
 c.change_value(800); c.set_name("who");
 cout << "contents of c are now:" << endl;
 cout << c.get_the_name() << " " << c.return_the_variable() << endl;

cout << endl;
cout << "class \"a_class\" contents:" << endl;
cout << a_class.get_the_name() << " " << a_class.return_the_variable() << endl;
a_class.change_value(200)
 */