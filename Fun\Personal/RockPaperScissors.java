// Game to simulate Rock, Paper, Scissors!
// Authored 9-26-2023

import java.util.Scanner;
import java.io.*;

public class Main {
    public static void main(String[] args)
    {
        // Variables/declarations
        Scanner scan = new Scanner(System.in);
        String p1 = "", p2 = "";


        System.out.println("Welcome to Rock, Paper, Scissors! Player one will go first. Please enter the option for " +
                "player one, as 'rock'', 'paper'', or 'scissors'." );
        try
        {
            p1 = scan.nextLine();
        }
        catch(Exception e)
        {
            System.out.println("Error grabbing p1 choice");
            System.exit(-1);
        }

        while( !(p1.equals("rock") || p1.equals("paper") || p1.equals("scissors")) )
        {
            System.out.println("Please enter a valid choice from the list. Options are 'rock', 'paper', or 'scissors'");
            try
            {
                p1 = scan.nextLine();
            }
            catch(Exception e )
            {
                System.out.println("Error grabbing p1 choice");
            }
        }

        // p2 choice

        System.out.println("Now, please enter player 2's choice, the same rules apply: ");
        try
        {
            p2 = scan.nextLine();
        }
        catch(Exception e)
        {
            System.out.println("Error grabbing p2 choice");
            System.exit(-1);
        }


        while( !(p2.equals("rock") || p2.equals("paper") || p2.equals("scissors")) )
        {
            System.out.println("Please enter a valid choice from the list. Options are 'rock'', 'paper'', or 'scissors'");
            try
            {
                p2 = scan.nextLine();
            }
            catch(Exception e )
            {
                System.out.println("Error grabbing p2 choice");
            }
        }

        // Logic
        if(p1.equals("rock"))
        {
            if(p2.equals("rock"))
            {
                System.out.println(berresLibrary.ANSI_GREEN + "This match is a tie!" + berresLibrary.ANSI_RESET);
            }
            else if(p2.equals("paper"))
            {
                System.out.println(berresLibrary.ANSI_RED + "Player 2 wins this match. " + berresLibrary.ANSI_RESET);
            }
            else
            {
                System.out.println(berresLibrary.ANSI_BLUE + "Player 1 wins this match!" + berresLibrary.ANSI_RESET);
            }
        }
        else if(p1.equals("paper"))
        {
            if(p2.equals ("paper"))
            {
                System.out.println(berresLibrary.ANSI_GREEN + "This match is a tie!" + berresLibrary.ANSI_RESET);
            }
            else if(p2.equals("scissors"))
            {
                System.out.println(berresLibrary.ANSI_RED + "Player 2 wins this match. " + berresLibrary.ANSI_RESET);
            }
            else
            {
                System.out.println(berresLibrary.ANSI_BLUE + "Player 1 wins this match!" + berresLibrary.ANSI_RESET);
            }
        }
        else
        {
            if(p2.equals("scissors"))
            {
                System.out.println(berresLibrary.ANSI_GREEN + "This match is a tie!" + berresLibrary.ANSI_RESET);
            }
            else if(p2.equals("rock"))
            {
                System.out.println(berresLibrary.ANSI_RED + "Player 2 wins this match. " + berresLibrary.ANSI_RESET);
            }
            else
            {
                System.out.println(berresLibrary.ANSI_BLUE + "Player 1 wins this match!" + berresLibrary.ANSI_RESET);
            }
        }

        // End code

    }
}
