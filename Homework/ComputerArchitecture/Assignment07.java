// Computer Architecture Assignment 7
// Authored 10/15/2023

import java.util.Scanner;

public class Main {
    public static void main(String[] args)
    {
        // Declarations
        Scanner scan = new Scanner(System.in);
        boolean s = false
                ,r = false;

        // Greeting, verify true/false
        System.out.println("Welcome to Assignment7. Please enter 'true' or 'false for s'");
        try{s = scan.nextBoolean();}
        catch(Exception e) {System.out.println("Error, please try again.");}

        System.out.println("And now r - ");
        try{r = scan.nextBoolean();}
        catch(Exception e) {System.out.println("Error, please try again.");}

        // Undefined SR latch
        if(s && r)
        {
            System.out.println("SR-latch -");
            System.out.println(" ");
            System.out.println("!S  !R  |  Q  !Q ");
            System.out.println("__________________");
            System.out.println(" 0   0  |  U   U ");
        }

        // Q0 SR latch
        else if(!(s || r))
        {
            System.out.println("SR-latch -");
            System.out.println(" ");
            System.out.println("!S  !R  |  Q  !Q ");
            System.out.println("__________________");
            System.out.println(" 1   1  |  Q0 !Q0");
        }
        else
        {
            // Variables/work
            boolean q0 = true;
            boolean q = (!(s && q0));
            char qChar = q ? '0' : '1';
            char notQ_Char = q ? '1' : '0';
            char notS_Char = !s ? '1' : '0';
            char notR_Char = !r ? '1' : '0';

            System.out.println("SR-latch -");
            System.out.println(" ");
            System.out.println("!S  !R  |  Q  !Q ");
            System.out.println("__________________");
            System.out.println(" " + notS_Char + "   " + notR_Char + "  |  " + qChar + "   " + notQ_Char + " ");
        }
    }
}
