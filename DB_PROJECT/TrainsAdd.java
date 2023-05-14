
import java.io.BufferedReader;
import java.io.IOException;
import java.sql.*;
import java.io.*;

//Class.forName("com.psql.jdbc.Driver");

public class TrainsAdd {

    public static void main(String[] args) throws SQLException 
    {
        try
        {
            final String DB_URL="jdbc:postgresql://localhost:5432/rails";
            final String USER="postgres";
            final String PASS="root";
        
            BufferedReader br = new BufferedReader(new FileReader( "./TrainScheduling.txt"));
           
            

            String line = "";
            while ((line = br.readLine()) != "#") 
            {
                
                Connection c = DriverManager.getConnection(DB_URL,USER,PASS);
                String[] arr = line.split("[ ]+");                        
                PreparedStatement cStmt=c.prepareCall("insert into train(train_num,dtofj ,AC_coach, SL_coach, AC_seat_booked, SL_seat_booked ) values(?,?::DATE,?,?,0,0);");
                Date dt= Date.valueOf(arr[1]);
                cStmt.setInt(1, Integer.parseInt(arr[0]));
                cStmt.setDate(2, dt);
                cStmt.setInt(3,Integer.parseInt(arr[2]));
                cStmt.setInt(4,Integer.parseInt(arr[3]));
                cStmt.execute();
                c.close();     
                cStmt.close();
            } 

            br.close();            
        } 
        catch (IOException e) 
        {
            e.printStackTrace();
        }
    }

}
