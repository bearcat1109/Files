// Computer Architecture Assignment 09
// Gabriel Berres 11-5-2023
/*
Explanation from book of gate -
Remember from our example where we examined the addressing of
a 16 Meg memory device in the 256 Meg memory space of a processor
that the four most significant bits needed to remain 00112 . In other
words, if the four bits a27, a26 , a25 , and a24 equaled 00002 , 00012 , 00102 ,
01002 , 01012 , 01102 , 01112 , 10002 , 10012 , 10102 , 10112 , 11002 , 11012 ,
11102 , or 11112 , the 16 Meg memory device would be disabled.
Therefore, we want a circuit that is active when a27 = 0, a26 = 0, a25 = 1,
and a24 = 1. This sounds like the product from an AND gate with a27
and a26 inverted. Chip select circuits are typically active low, however,
so we need to invert the output. This gives us a NAND gate.
 */

import java.util.Scanner;


public class Main {
    public static void main(String[] args)
    {
        // Declare variables/object
        boolean a27, a26, a25, a24 = false;
        boolean result, actLowResult = false;
        Scanner scan = new Scanner(System.in);

        // Greet
        System.out.println("Welcome to Assignment 09. Please prepare to input 1/0 (True/false) for bits a24-a27.");
        System.out.println("a27: (Options: 1, 0");
        // Starting to like this new form of input protection I tried in Assignment08
        // where a string is taken in, so doing it again here.
        for(int g = 0; g < 4; g++) {
            if (g == 0)
            {
                System.out.print("Input a27 (1/0) - ");
            } else if (g == 1)
            {
                System.out.print("Input a26 (1/0)- ");
            } else if (g == 2)
            {
                System.out.print("Input a25 (1/0)- ");
            } else if (g == 3)
            {
                System.out.print("Input a24 (1/0)");
            }
            // Get input, make lowercase
            String input = scan.nextLine();

            if (input.equals("1"))
            {
                if (g == 0)
                {
                    a27 = true;
                } else if (g == 1)
                {
                    a26 = true;
                } else if (g == 2)
                {
                    a25 = true;
                } else if (g == 3)
                {
                    a24 = true;
                }
            } else if (input.equals("0")) {
                if (g == 0)
                {
                    a27 = false;
                } else if (g == 1)
                {
                    a26 = false;
                } else if (g == 2)
                {
                    a25 = false;
                } else if (g == 3)
                {
                    a24 = false;
                }
            } else
            {
                System.out.println("Invalid entry. Please enter '1' or '0'");
                g--;
            }

        }
    }
}
