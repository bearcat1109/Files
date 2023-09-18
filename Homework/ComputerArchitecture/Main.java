// Gabriel Berres
// Computer Architecture Assignment 04
// Dr. Harrington, CS 3173

import java.util.Scanner;
import java.io.PrintWriter;

public class Main {
    public static void main(String[] args)
    {
        // Variables, scanner object
        boolean userA, userB, result1, result2;
        Scanner scan = new Scanner(System.in);

        // Greeting, get values
        System.out.println("Ohayou, welcome to Computer Architecture. Please enter " +
                "values for bool A: ('true', 'false'')");
        userA = scan.nextBoolean();
        System.out.println("And now, bool B: ");
        userB = scan.nextBoolean();

        // Logic Gate 1
        if((userA == true) && (userB == true))
        {
            result1 = true;
        }
        else
        {
            result1 = false;
        }
        System.out.println("Result of A && B : " + result1);

        // Logic Gate 2
        if((userA == true) || (userB == true))
        {
            result2 = true;
        }
        else
        {
            result2 = false;
        }
        System.out.println("Result of A || B : " + result2);

        // Logic Gate 3
        if((result1 == true) && (result2 == true))
        {
            System.out.println("Result of (A && B) && (A || B) : true");
        }
        else
        {
            System.out.println("Result of (A && B) && (A || B) : false");
        }

        // Logic Gate 4
        if((result1 == true) || (result2 == true))
        {
            System.out.println("Result of (A && B) || (A || B): true");
        }
        else
        {
            System.out.println("Result of (A && B) || (A || B): false");
        }

        // Ja na (See you later)
        System.out.println("Thank you for using assignment04. Have a blessed day!");
    }
}