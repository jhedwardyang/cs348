import java.sql.*;
import java.util.Properties;

public class A3 {
	
/* Do not hard code this connection string. Your program must accept the connection string provided as input parameter (arg 0) to your program!
    private static final String CONNECTION_STRING ="jdbc:mysql://127.0.0.1/cs348?user=root&password=cs348&Database=cs348;";
  */  
    
    public static void main(String[] args) throws
                             ClassNotFoundException,SQLException
    {
        // Get connection string and file name
	String CONNECTION_STRING =args[0];
	String INPUT_FILE =args[1];

        Connection con = DriverManager.getConnection(CONNECTION_STRING);
        
/*	//REMOVE THIS! THIS IS JUST TO MAKE SURE THAT YOU
	//CAN CONNECT TO THE DATABASE!
        String query = "SELECT COUNT(*) FROM MATRIX";
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery(query);
        while (rs.next()) {

            System.out.println(rs.getString(1));
        }
*/       
        con.close();
    }
    
    
}
    	

	


