// Code for Exam 01 for Computer Architecture.  Writing began 8-30-2023.

import java.io.File;
import java.util.Scanner;
import java.io.FileReader;
import java.io.PrintWriter;
import java.io.*;


public class Main {
    public static void main(String[] args)
    {
        // Duty Cycle of periodic pulse train if pulseDuration = .1, Period = 10.1.
        double period = 2147483641;
        double tW = 10;
        double result = (tW / period);

        System.out.println("Welcome to computer architecture. The duty cycle of a periodic pulse train " +
                " t_w of " + tW + " and a period of " + period + " is: " + result + ".");

        try
        {
            PrintWriter outFile = new PrintWriter("CA-Exam01.txt");
            outFile.println("The results of the calculation is a periodic pulse train with duty of " + result + ".");
            outFile.close();
        }
        catch(Exception e)
        {
            System.out.println("Error. Please restart.");
        }
    }
}