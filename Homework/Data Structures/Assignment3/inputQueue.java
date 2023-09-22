import java.io.FileWriter;
import java.util.Scanner;
import java.io.File;

// inputQueue object/struct
public class inputQueue
{
    // Variables
    public int id;
    public String name;
    public String title;
    public double hours;
    public double pay;
    public double fedTax;
    public double stateTax;
    public double socialTax;
    public double medicTax;
    public double perGross = (hours * pay);

    // "per" group is used to calculate these amounts per employee
    public double perFed = (perGross * fedTax);
    public double perState = (perGross * stateTax);
    public double perSocial = (perGross * socialTax);
    public double perMedic = (perGross * medicTax);
    public double netPay = (perGross - ((perGross*fedTax) + (perGross*stateTax) + (perGross*socialTax) + (perGross*medicTax)));

    // totalGross and Withheld group are for calculating global totals
    public static double totalGross;
    public static double fedWithheld;
    public static double stateWithheld;
    public static double socialWithheld;
    public static double medicWithheld;
    public static double netWithheld;


    static inputQueue[] readCSV(File file)
    {
        // get length of csv to determine how many lines
        int lineCt = 0;
        try
        {
            Scanner scan = new Scanner(file);
            while (scan.hasNextLine())
            {
                scan.nextLine();
                lineCt++;
            }
        }
        catch(Exception e)
        {
            System.out.println("Error in file length process.");
            e.printStackTrace();
            System.exit(-1);
        }

    inputQueue[] retArray = new inputQueue[lineCt];

    // Read file into array
        try
        {
            Scanner scan = new Scanner(file);
            for(int g = 0; g < lineCt; g++)
            {
                // Setup
                inputQueue tempEmployee = new inputQueue();
                String lineHold = scan.nextLine();
                Scanner scanLine = new Scanner(lineHold);
                scanLine.useDelimiter(",");

                if(scanLine.hasNextInt()) tempEmployee.id = scanLine.nextInt();
                if(scanLine.hasNext()) tempEmployee.name = scanLine.next();
                if(scanLine.hasNext()) tempEmployee.title = scanLine.next();
                if(scanLine.hasNextDouble()) tempEmployee.hours = scanLine.nextDouble();
                if(scanLine.hasNextDouble()) tempEmployee.pay = scanLine.nextDouble();
                if(scanLine.hasNextDouble()) tempEmployee.fedTax = scanLine.nextDouble();
                if(scanLine.hasNextDouble()) tempEmployee.stateTax = scanLine.nextDouble();
                if(scanLine.hasNextDouble()) tempEmployee.socialTax = scanLine.nextDouble();
                if(scanLine.hasNextDouble()) tempEmployee.medicTax = scanLine.nextDouble();

                retArray[g] = tempEmployee;
            }
        }
        catch(Exception e)
        {
            System.out.println("Error in file>array process.");
            e.printStackTrace();
            System.exit(-1);
        }

        return retArray;
    }

    // Print info from each inputQueue's array data
    static String berresOutput(inputQueue employees)
    {
        // Calculate numbers that need calculating
        employees.perGross = (employees.hours * employees.pay);
        employees.perFed = (employees.perGross * employees.fedTax);
        employees.perState = (employees.perGross * employees.stateTax);
        employees.perSocial = (employees.perGross *  employees.socialTax);
        employees.perMedic = (employees.perGross * employees.medicTax);
        employees.netPay = (employees.perGross - (employees.perFed + employees.perState +
                            employees.perSocial + employees.perMedic));

        String berres = String.format(
                "Employee %d %s , %s, worked %f hours @ %f dollars/hr. They paid %f in Federal Tax, %f in State Tax, " +
                        "%f in Social Security Tax, and %f in Medicaid Tax  - For a net pay of %f dollars. \n",
                employees.id,
                employees.name,
                employees.title,
                employees.hours,
                employees.pay,
                employees.perFed,
                employees.perState,
                employees.perSocial,
                employees.perMedic,
                employees.netPay
        );

        totalGross = (totalGross + employees.perGross);
        fedWithheld = (fedWithheld + employees.perFed);
        stateWithheld = (stateWithheld + employees.perState);
        socialWithheld = (socialWithheld + employees.perSocial);
        medicWithheld = (medicWithheld + employees.perMedic);
        netWithheld = (netWithheld + employees.netPay);

        return berres;
    }

    // Method for printing of normal employee rows
    public static void printRows(String str, FileWriter fw)
    {
        System.out.print(str);
        try
        {
            fw.write(str);
            fw.flush();
        }
        catch(Exception e)
        {
            System.out.println("Error occured.");
            System.exit(-1);
        }
    }

    // Method for output of Summary
    public static void printSummary()
    {
        //Format string
        String summary = String.format(
                "Summary~ \n Total Gross Pay: %f \n Total Federal Tax: %f \n Total State Tax: %f \n Total Social " +
                        "Security: %f \n Total Medicaid: %f \n Total Net Pay: %f ",
                inputQueue.totalGross,
                inputQueue.fedWithheld,
                inputQueue.stateWithheld,
                inputQueue.socialWithheld,
                inputQueue.medicWithheld,
                inputQueue.netWithheld
        );

        // Output
        System.out.println(summary);

        try
        {
            FileWriter fw = new FileWriter("summary.txt");
            fw.write(summary);
            fw.flush();
        }
        catch(Exception e)
        {
            System.out.println("Error occured in summary process.");
            System.exit(-1);
        }
    }
}

