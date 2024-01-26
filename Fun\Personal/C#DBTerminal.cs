using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SQLite;

namespace SQLiteTerminalSandbox
{
    internal class Program
    {
        static void Main(string[] args)
        {
            // Console setup
            Console.Title = "Super fun terminal!";
            Console.ForegroundColor = ConsoleColor.Blue;

            // Greet
            Console.WriteLine("Welcome. What would you like to do? The options are:");
            Console.WriteLine("1. Query the database");
            Console.WriteLine("2. Enter a new member who will be assigned an ID");


            // SQLite setup
            string connectionString = "Data Source=C:\\Users\\berresg\\Desktop\\Coding\\c#\\SQLiteTerminalSandbox\\SQLiteTerminalSandboxdb1.db;Version=3;";
            using (SQLiteConnection connection = new SQLiteConnection(connectionString)) 
            {
                connection.Open();

                // Create table
                using (SQLiteCommand createTable = new SQLiteCommand("CREATE TABLE IF NOT EXISTS spriden (pidm INTEGER PRIMARY KEY, name TEXT);", connection))
                {
                    createTable.ExecuteNonQuery();
                }

                // Insert me
                using (SQLiteCommand insertCommand = new SQLiteCommand("INSERT OR IGNORE INTO spriden (pidm, name) VALUES (1, 'Gabriel Berres');", connection))
                {
                    insertCommand.ExecuteNonQuery();
                }

                // Query 
                using (SQLiteCommand selectCommand = new SQLiteCommand("SELECT * FROM spriden;", connection))
                {
                    Console.WriteLine("Spriden data:");
                    using (SQLiteDataReader reader = selectCommand.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Console.WriteLine($"Id: {reader["pidm"]}, Name: {reader["name"]}");
                        }
                    }
                }

                // Close connection
                connection.Close();
            }

            Console.WriteLine("Press any key to exit...");
            Console.ReadKey();

            //Console.WriteLine("Welcome, please enter x:");
            //int x = Int32.Parse(Console.ReadLine());
            //int y = x * 2;
            //Console.WriteLine("Ohayou, sekai");
            //Console.WriteLine(y);
            //Console.ReadKey();
        }
    }
}
