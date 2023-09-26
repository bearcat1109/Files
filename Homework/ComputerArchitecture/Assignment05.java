// Assignment 05, written 9-25-2023, Gabriel Berres

import java.io.*;
import java.util.Scanner;

public class Main {

    // For error text to output as red

    public static void main(String[] args)
    {
        // Preparation - Variables/Declarations
        Scanner scan = new Scanner(System.in);
        boolean boolA = false, boolB = false, boolC = false;
        boolean outcome = false;
        int usrChoice = 0;

        // Greeting
        System.out.println("Welcome to assignment05. Please enter one of two options - [1. Carryout ] or [2. Sum]");

        try
        {
            usrChoice = scan.nextInt();
        }
        catch(Exception e)
        {
            System.out.println(berresLibrary.ANSI_RED + "Error" + berresLibrary.ANSI_RESET);
        }

        while(usrChoice < 1 || usrChoice > 2)
        {
            try
            {
                System.out.println("Invalid option. Please enter either 1 or 2.");
                scan.nextInt();
            }
            catch(Exception e)
            {
                System.out.println(berresLibrary.ANSI_RED + "Error in input validation. Restart, por favor" + berresLibrary.ANSI_RESET);
                System.exit(-1);
            }
        }

        // Carryout logic
        if(usrChoice == 1)
            {
                System.out.println("Enter value for A: ('true' or 'false')");
                try
                {
                    boolA = scan.nextBoolean();
                }
                catch(Exception e)
                {
                  System.out.println("Error in boolean entry");
                  System.exit(-1);
                }

                System.out.println("Enter value for B: ('true' or 'false')");
                try
                {
                    boolB = scan.nextBoolean();
                }
                catch(Exception e)
                {
                    System.out.println("Error in boolean entry");
                    System.exit(-1);
                }
                // C
                System.out.println("Enter value for C: ('true' or 'false')");
                try
                {
                    boolC = scan.nextBoolean();
                }
                catch(Exception e)
                {
                    System.out.println("Error in boolean entry");
                    System.exit(-1);
                }

                // Logic
                //  Carryout= B∙C_in+ A∙B + A∙C_in
                if( (boolB && boolC) || (boolA && boolB) || (boolA && boolC) )
                {
                    outcome = true;
                }
                else
                {
                    outcome = false;
                }

                // Exit
                System.out.println(berresLibrary.ANSI_CYAN + "Outcome of Carryout: " + outcome + berresLibrary.ANSI_RESET);
                System.exit(-1);
            }
        else if(usrChoice == 2)
        {
            System.out.println("Enter value for A: ('true' or 'false')");
            try
            {
                boolA = scan.nextBoolean();
            }
            catch(Exception e)
            {
                System.out.println("Error in boolean entry");
                System.exit(-1);
            }

            System.out.println("Enter value for B: ('true' or 'false')");
            try
            {
                boolB = scan.nextBoolean();
            }
            catch(Exception e)
            {
                System.out.println("Error in boolean entry");
                System.exit(-1);
            }
            // C
            System.out.println("Enter value for C: ('true' or 'false')");
            try
            {
                boolC = scan.nextBoolean();
            }
            catch(Exception e)
            {
                System.out.println("Error in boolean entry");
                System.exit(-1);
            }

            // Logic
            // Here for reference:  Sum= ¬A∙¬B∙C_in+ ¬A∙B∙¬C_in  + A∙B∙C_in+ A∙¬B∙¬C_in
            if ( (!boolA && !boolB && boolC) || (!boolA && boolB && !boolC) || (boolA && !boolB && !boolC) )
            {
                outcome = true;
            }
            else
            {
                outcome = false;
            }

            // Jaa Ne じゃあ ね
            System.out.println(berresLibrary.ANSI_YELLOW + "Outcome of Sum calculation: " + outcome + berresLibrary.ANSI_RESET);

        }
        else
        {
            System.out.println(berresLibrary.ANSI_RED + "No choice chosen, exiting." + berresLibrary.ANSI_RESET);
            System.exit(-1);
        }


    }
}
