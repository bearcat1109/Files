// Assignment 4 Operating Systems, Gabriel Berres
// Salvaged what I could of both files and combined to do the multithreaded
// addition with concurrent threads
// Rewrote it so I understood it better so some function names may be slightly different

import java.util.Scanner;
import java.util.concurrent.*;

class Sum
{
    private int value;

    public int getValue()
    {
        return value;
    }

    public void setValue(int sum)
    {
        this.value = sum;
    }
}
class Summation implements Runnable
{
    private int upper, lower;
    private Sum sumValue;

    public Summation(int upper, int lower, Sum sumValue)
    {
        this.upper = upper;
        this.lower = lower;
        this.sumValue = sumValue;
    }

    public void run()
    {
        int sum = 0;

        for(int x = lower; x <= upper; x++)
        {
            sum += x;
        }
        sumValue.setValue(sum);
        System.out.println(Thread.currentThread().getName() + " " + sum);
    }
}

public class MultiThreadedAdditionCombined
{
    public static void main(String[] args)
    {
        // Scaanner + greeting/input
        Scanner scan = new Scanner(System.in);
        System.out.println("Welcome to assignment 4. Please enter an integer: ");
        int max = scan.nextInt();
        System.out.println("Enter how many threads to use: ");
        int threadsNum = scan.nextInt();

        if(threadsNum < max && threadsNum > 0)
        {
            // Declarations -
            ExecutorService exec = Executors.newFixedThreadPool(threadsNum);
            Sum[] sums = new Sum[threadsNum];
            int increment = max / threadsNum;
            int lower = 1;

            for(int x = 0; x < threadsNum; x++)
            {
                int upper = lower + increment;
                if(upper > max)
                {
                    upper = max;
                }
                sums[x]  = new Sum();
                exec.execute(new Summation(upper, lower, sums[x]));
                lower = upper + 1;
            }

            // stop
            exec.shutdown();

            try
            {
                exec.awaitTermination(Long.MAX_VALUE, TimeUnit.NANOSECONDS);
            } catch (InterruptedException E)
            {
                System.out.println("Error : " + E.toString());
            }

            int total = 0;
            for(int x = 0; x < threadsNum; x++)
            {
                total += sums[x].getValue();
                System.out.println("Thread Number " + x +" sum is: " + sums[x].getValue());
            }

            System.out.println("The sum of all numbers between 1 and the max of: " + max + " is: " + total);
            int check = max * (max + 1) / 2;
            System.out.println("Checksum is: " + check);

        } else
        {
            System.out.println("Number of threaads must be less than max value and greater than 0");
        }
    }
}
