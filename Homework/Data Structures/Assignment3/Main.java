import java.io.*;
import java.util.Scanner;
import java.util.Queue;
import java.util.LinkedList;

public class Main {
    public static void main(String[] args) throws Exception
    {
        // Point to file
        File payrollCSV = new File("C:\\Users\\berresg\\Desktop\\Coding\\java\\DataStructuresAssignment03\\src" +
                "\\payroll.csv");
        File output = new File("berres.txt");
        File summaryFile = new File("summary.txt");
        // inputQueue class
        inputQueue[] employees = inputQueue.readCSV(payrollCSV);
        FileWriter outWriter = null;

        // Output setup
        try
        {
            outWriter = new FileWriter(output);
        }
        catch(Exception e)
        {
            System.out.println("Error.");
            System.exit(-1);
        }

        // Queue setup
        Queue<inputQueue> payStubs = new LinkedList<>();
        for(inputQueue e : employees)
        {
            payStubs.add(e);
        }

        // Queue operation
        while(payStubs.peek() != null)
        {
            inputQueue e = payStubs.remove();

            String berres = inputQueue.berresOutput(e);
            inputQueue.printRows(berres, outWriter);
        }

        // Do summary
        inputQueue.printSummary();

    }
}



/*String summary = null;
        summary = summaryOutput(summary);*/
