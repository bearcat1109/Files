import java.util.Scanner;

public class Main {
    public static void main(String[] args)
    {
        // Variables/Declarations
        Scanner scan = new Scanner(System.in);
        String binNum, toggledBin;
        int decNum = 0;
        int togNum = 0;
        int mask = 0;

        // Greet, get binary number
        System.out.println("Welcome to Assignment06. Please input the binary number you would like to toggle in " +
                "8-digit number format. Ex: 10010011 ");
        binNum = scan.nextLine();

        // Convert binary to integer
        decNum = Integer.parseInt(binNum, 2);

        // Mask for Xor toggle
        mask = (1 << binNum.length()) - 1;

        // Use XOR to toggle bits
        togNum = decNum ^ mask;

        // Convert back to binary string
        toggledBin = Integer.toBinaryString(togNum);

        // Pad number with zeros if needed
        while(toggledBin.length() < binNum.length())
        {
            toggledBin = "0" + toggledBin;
        }

        // Output
        System.out.println("Original binary :" + binNum);
        System.out.println("Toggled binary : " + toggledBin);

    }
}
