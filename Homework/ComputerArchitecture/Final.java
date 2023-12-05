// Computer Architecture Final, started 12/3//2023 Gabriel Berres
// SR Latch references p.209 in the textbook
// Imports
import java.util.Scanner;

public class Main
{
    public static void main(String[] args)
    {
        //System.out.println("Ohayou, sekai");
        // Declarations
        boolean S = true;
        boolean R = true;
        boolean Q = true;
        boolean Qn = true;
        Scanner scan = new Scanner(System.in);
        String input;

        // Greeting
        System.out.println("Welcome to the Computer Architecture Final. Input 0/1 (false/True) for S and R to " +
                "continue.");
        // Protect input. Trying small commands on their own line to save space.
        // Inpouts are opposite since SR Latches are Active Low
        for(int g = 0; g < 2; g++)
        {
            if(g == 0) {System.out.print("Current state of S - ");}
            else if(g == 1){System.out.print("Current state of R - ");}
            else {System.out.println("Step done.");}
            // Get input
            input = scan.nextLine();
            if(input.equals("1"))
            {
                if(g == 0) {S = false;}
                else{R = false;}
            }
            else if(input.equals("0"))
            {
                if(g == 0) {S = true;}
                else{R = true;}
            }
            else
            {
                System.out.println("Invalid entry. Please enter '1' or '0'");
                g--;
            }
        }

        // Book mentions U+U is "undefined" (But is really just 1+1) p.209
        if(!S && !R)
        {
            System.out.println("Output undefined.");
        } else if(S != R)          // If S/R are different (The middle two cases)
        {
            Q = !S;
            Qn = !R;
            System.out.println("S and R are : " + S + " and " + R + ". (Keep in mind SR Latch is active low)");
        } else                     // 1+1 case
        {
            System.out.println("S and R are Q and Q0.");
        }

    }
}
