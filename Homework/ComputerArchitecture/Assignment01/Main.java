// Gabriel Berres
// Computer Architecture Assignment 01 (And later, 02)
// Dr. Harrington, CS 3173

import java.io.File;
import java.util.Scanner;
import java.io.FileReader;
import java.io.PrintWriter;
import java.io.*;



public class Main {

    public static String
    baseConverter(String num, int baseSource, int baseNew)
    {
        // Parse number given with source and turn it into new base
        return Integer.toString(
                Integer.parseInt(num, baseSource), baseNew);
    }

    public static void main(String[] args) {
    // Question 1
    // Scanner
        Scanner scan = new Scanner(System.in);
        System.out.println("Welcome to Computer Architecture. (This is a test)");
        System.out.println("Please enter the number of the function you would like to utilize. The options are:");
        System.out.println("-----------------------------------------------------------------------------------");
        System.out.println("1. Frequency/Period(Assignment01 functions)      //      2. Base to Base conversion");
        int choice = scan.nextInt();
        if(choice == 1)
        {
            // Executed if user input 1.
            // Variables
            float period = 0;
            // Greeting
            System.out.println("This program calculates periodic pulse trains.");
            System.out.println("What is the frequency of the pulse? (Please enter a float)");
            float frequency = scan.nextFloat();
            // Divide 1 by Frequency to get Period
            period = 1 / frequency;
            // Print
            System.out.println("If the periodic pulse train has a frequency of " + frequency + ", it has a period of " + period + ".");

            // Question 2
            // Pulse Duration
            System.out.println("Now we will calculate Duty Cycle. Please enter the Pulse Duration(tw): ");
            float pulseDuration = scan.nextFloat();
            // Period
            System.out.println("Please enter the period: ");
            float period2 = scan.nextFloat();
            scan.nextLine();
            // Calculate
            float duty = (pulseDuration / period2) * 100;
            // Output
            System.out.println("The Duty Cyle for a period pulse train with frequency " + pulseDuration + " and period " + period2 + " is: " + duty + "%.");

            // Question 3
            // Create file
            System.out.println("Please enter the name of the file for results to be written to.");
            String filename = scan.nextLine();
            File file = new File(filename + ".txt");

            // Execute
            try {
                PrintWriter outFile = new PrintWriter(file);
                outFile.println("A periodic pulse train with frequency " + frequency + " has a period of " + period + ". ");
                outFile.println("The duty cycle of a periodic pulse train with a Pulse Duration of " + pulseDuration + " " +
                        "and a period of " + period2 + " is " + duty + "%.");
                outFile.close();
                System.out.println("Wrote to file " + filename + " successfully, closing program. ");
            }
            catch(Exception e) {
                System.out.println("Error in file write process, stopping.");
            }
        }
        else if(choice == 2)
            {
                try {
                    // Executed if user input 2.
                    // Variables
                    Scanner scan2 = new Scanner(System.in);
                    String holder;
                    String num;
                    // Ask for given number
                    System.out.println("Please enter your number:");
                    num = scan2.nextLine();
                    // Get base of old number
                    System.out.println("Please enter the source base.");
                    holder = scan2.nextLine();
                    int baseSource = Integer.parseInt(holder);
                    // Get base of new number
                    System.out.println("Please enter the new base.");
                    holder = scan2.nextLine();
                    int baseNew = Integer.parseInt(holder);
                    // Deliver results
                    System.out.println("Your original number: " + num);
                    System.out.println("Your number in the new supplied base: " + baseConverter(num, baseSource, baseNew));
                    baseNew = 16;
                    System.out.println("Your number in hex: " + baseConverter(num, baseSource, baseNew));
                }
                catch(Exception e){
                    System.out.println("Error. Please try again.");
                }
            }
        else
            {
                // Executed if user put in anything else.
                System.out.println("Other error. Please try again.");
            }
        }

}