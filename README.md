# DatabaseManagement_RailwayReservation
How to compile:
1. Open postgres sql server.

2. Create a database named rails using ‘CREATE DATABASE rails;’

3. Switch to rails (\c rails;) and copy the contents of the sql file.
 
4. Now compile all java files present : client, invokeWorkers, sendQuery, ServiceModule, TrainsAdd.
 
5. Make sure you have added the TrainScheduling.txt. Add all user inputs files in the folder named ‘Input’.
 
6. Run TrainsAdd file (java TrainsAdd) to store the trains in the database.
 
7. Run ServiceModule (java ServiceModule) which will then wait for clients.
 
8. Run the client (java client) on a separate terminal to run all output files concurrently on the database.
 
9. Now output files will be generated in folder ‘Output’ for each respective


Output:

Each output file will tell the status of the user ticket. If the train is not available or seats are not available then no booking and will be shown in the output file. If the booking operation is successful, output will have the ticket description for each passenger requested by the user.

Note that: output folder is not in repository as folder should be empty after running inputs (and blank folders can not be uploaded on repo). So make a 'Output' folder before running.
