// CSV->SQL Insert Statement, Gabriel Berres 4/12/2024

#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <string>

using namespace std;

vector<string> parseLine(const string& line)
{
	// Input/holder for line(value)
	stringstream ss(line);
	vector<string> result;
	string value;
	while (getline(ss, value, ','))
	{
		// Remove double quotes from the row if it's there
		value.erase(remove(value.begin(), value.end(), '"'), value.end());
		// Send back to results vecotr
		result.push_back(value);
	}
	return result;
}

string createInsertStatement(const vector<string>& values, const string& tableName)
{
	// Grab fields
	string sql = "INSERT INTO " + tableName + " VALUES (";
	for (size_t x = 0; x < values.size(); x++)
	{
		if (x > 0) sql += ", ";
		sql += "'" + values[x] + "'";
	}
	sql += ");";
	
	return sql;
}

int main()
{
	using namespace std;
	string filename;
	string tableName;
	
	// File read/write
	string line;

	// Greet, get filename
	cout << "Hello, please enter the filename for the csv:";
	cin >> filename;

	// Initialize after getting file name
	ifstream inFile(filename);
	if (!inFile)
	{
		cerr << "File open error - " << filename << endl;
	}
	ofstream outFile("insert.sql");


	// Get SQL table info
	cout << "Please enter string to place before the INSERT values, all column names after the table name. " << "\n";
	cout << "Example: 'nsudev.wm_sll_crse (wm_sll_crse_subj_code, wm_sll_crse_node_name, wm_sll_crse_crse_numb, wm_sll_crse_coll_code)'";
	cin >> tableName;


	// Skip header line
	getline(inFile, line);

	while (getline(inFile, line))
	{
		auto values = parseLine(line);
		auto sql = createInsertStatement(values, tableName);
		outFile << sql << endl;
	}

	inFile.close();
	outFile.close();

	return 0;

}
