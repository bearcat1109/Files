// Computer Architecture Exam 3. Written by Gabriel Berres, 10-25-2023.

import java.util.Scanner;

public class Main {
    public static void main(String[] args)
    {
        // Greeting
        System.out.println("Welcome to Exam 03. Please continue to enter values for J/K.");

        // Declarations
        Scanner scan = new Scanner(System.in);
        boolean J = false;
        boolean K = false;

        for(int g = 0; g < 2; g++)
        {
            if(g == 0) {System.out.print("Current state of A (Please enter false/true)- ");}
            else if(g == 1){System.out.print("Current state of B (Please enter false/true)- ");}
            // Get input, make lowercase
            String input = scan.nextLine().toLowerCase();

            if(input.equals("true"))
            {
                if(g == 0) {J = true;}
                else if(g== 1) {K = true;}
            }
            else if(input.equals("false"))
            {
                if(g == 0) {J = false;}
                else if(g== 1) {K = false;}
            }
            else
            {
                System.out.println("Invalid entry. Please enter 'true' or 'false'");
                g--;
            }
        }

        // Math for output of Q,!Q
        String Q;
        String notQ;

        // I couldn't get a math calculator to give me the line above the Q.
        // Also when I tried to do superscript 0 it wouldn't let me :(
        if(!J && !K)
        {
            System.out.println("J and K were both 0. Q = Q0 and !Q = !Q0");
        }
        else if(!J && K)
        {
            System.out.println("J was 0 and K was 1. Q = 0 and !Q = 1.");
        }
        else if(J && !K)
        {
            System.out.println("J was 1 and K was 0. Q = 1 and !Q = 0.");
        }
        else
        {
            System.out.println("J & K were both 1. Q = !Q0 and !Q = Q.");
        }

    }
}
