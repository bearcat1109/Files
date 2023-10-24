// Assignment 8, due 10/25, written by Gabriel Berres.

import java.util.Scanner;

public class Main {
    public static void main(String[] args)
    {
        // Scanner object, bools
        Scanner scan = new Scanner(System.in);
        boolean A = false;
        boolean B = false;
        boolean in = false;

        System.out.println("Welcome to Assignment 08. Please enter 'true' or 'false' - (A>B>In) -");
        // Get A, B, and In - trying out a new way to do this with a loop, if entry is not valid, do g-- to
        // keep it going.
        for(int g = 0; g < 3; g++)
        {
            if(g == 0) {System.out.print("Current state of A - ");}
            else if(g == 1){System.out.print("Current state of B - ");}
            else if(g == 2){System.out.print("Input - ");}
            // Get input, make lowercase
            String input = scan.nextLine().toLowerCase();

            if(input.equals("true"))
            {
                if(g == 0) {A = true;}
                else if(g== 1) {B = true;}
                else if(g == 2) {in = true;}
            }
            else if(input.equals("false"))
            {
                if(g == 0) {A = false;}
                else if(g== 1) {B = false;}
                else if(g == 2) {in = false;}
            }
            else
            {
                System.out.println("Invalid entry. Please enter 'true' or 'false'");
                g--;
            }

        }

        boolean nA = false;
        boolean nB = false;

        // Next A states
        // false
        if((A == false) && (B == false) && (in == false)) {nA = false;}
        if((A == false) && (B == false) && (in == true)) {nA = false;}
        if((A == false) && (B == true) && (in == false)) {nA = false;}
        if((A == true) && (B == true) && (in == true)) {nA = false;}
        // true
        if((A == false) && (B == true) && (in == true)) {nA = true;}
        if((A == true) && (B == false) && (in == false)) {nA = true;}
        if((A == true) && (B == false) && (in == true)) {nA = true;}
        if((A == true) && (B == true) && (in == false)) {nA = true;}

        // Next B states
        // false
        if((A == false) && (B == false) && (in == false)) {nB = false;}
        if((A == false) && (B == false) && (in == true)) {nB = false;}
        if((A == false) && (B == true) && (in == false)) {nB = false;}
        if((A == true) && (B == true) && (in == true)) {nB = false;}
        // true
        if((A == false) && (B == true) && (in == true)) {nB = true;}
        if((A == true) && (B == false) && (in == false)) {nB = true;}
        if((A == true) && (B == false) && (in == true)) {nB = true;}
        if((A == true) && (B == true) && (in == false)) {nB = true;}

        // Output
        System.out.println("NextA - " + nA);
        System.out.println("Next B - " + nB);

    }
}
