/* 
** Edward Yang, Fall 2014 - CS348
** A03 Q01
*/


import java.sql.*;
import java.util.Properties;
import java.util.Scanner;
import java.io.*;

public class A3 {

	public static Connection conn;
    public static final boolean debug = false;
    
    public static void error() {
    	System.out.println("ERROR");
    	return;
    }

    public static void print() throws SQLException {
        String query = "SELECT MATRIX_ID, ROW_DIM, COL_DIM FROM MATRIX";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(query);
        System.out.println("ID\tROW\tCOL");
        System.out.println("===\t===\t===");
        while (rs.next()) {
            System.out.printf("%s\t%s\t%s\n", rs.getString(1), rs.getString(2), rs.getString(3));
        }
        System.out.println("");

        query = "SELECT MATRIX_ID, ROW_NUM, COL_NUM, VALUE FROM MATRIX_DATA";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(query);
        System.out.println("ID\tROW\tCOL\tVAL");
        System.out.println("===\t===\t===\t===");
        while (rs.next()) {
            System.out.printf("%s\t%s\t%s\t%s\n", rs.getString(1), rs.getString(2), rs.getString(3), rs.getString(4));
        }
        System.out.println("");
    }


    public static boolean getv(boolean print, String MATRIX_ID, String ROW_NUM, String COLUMN_NUM) throws SQLException {
    	Integer rows = Integer.parseInt(ROW_NUM);
    	Integer cols = Integer.parseInt(COLUMN_NUM);
    	if( rows <= 0 || cols <= 0 ) return false;

    	String query = "SELECT ROW_DIM, COL_DIM FROM MATRIX WHERE MATRIX_ID = " + MATRIX_ID;
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(query);
        Integer x = 0, y = 0;
        while (rs.next()) {
            x = Integer.parseInt(rs.getString(1));
            y = Integer.parseInt(rs.getString(2));
        }

        if( rows > x || cols > y ) return false;

        query = "SELECT VALUE FROM MATRIX_DATA WHERE MATRIX_ID = " + MATRIX_ID + " AND ROW_NUM = " + ROW_NUM + " AND COL_NUM = " + COLUMN_NUM;
        stmt = conn.createStatement();
        rs = stmt.executeQuery(query);
        while (rs.next()) {
        	String t = rs.getString(1);
        	String[] split = t.split("\\.");
        	if(print) System.out.printf("%s.%c\n", split[0], split[1].charAt(0));
        	return true;
        }

        return false;
    }
    public static boolean setv(boolean print, String MATRIX_ID, String ROW_NUM, String COLUMN_NUM, String VALUE) throws SQLException {
    	Integer rows = Integer.parseInt(ROW_NUM);
    	Integer cols = Integer.parseInt(COLUMN_NUM);
    	if( rows <= 0 || cols <= 0 ) return false;

    	String query = "SELECT ROW_DIM, COL_DIM FROM MATRIX WHERE MATRIX_ID = " + MATRIX_ID;
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(query);
        Integer x = 0, y = 0;
        while (rs.next()) {
            x = Integer.parseInt(rs.getString(1));
            y = Integer.parseInt(rs.getString(2));
        }

        if( rows > x || cols > y ) return false; // deals with x = 0, y = 0 or not existent


        query = "SELECT VALUE FROM MATRIX_DATA WHERE MATRIX_ID = " + MATRIX_ID + " AND ROW_NUM = " + ROW_NUM + " AND COL_NUM = " + COLUMN_NUM;
        stmt = conn.createStatement();
        rs = stmt.executeQuery(query);
        boolean exists = false;
        while (rs.next()) {
        	exists = true;
        }

        int res;
        if(exists) {
        	query = "UPDATE MATRIX_DATA SET VALUE = " + VALUE + " WHERE MATRIX_ID = " + MATRIX_ID + " AND ROW_NUM = " + ROW_NUM + " AND COL_NUM = " + COLUMN_NUM;
	        stmt = conn.createStatement();
	        res = stmt.executeUpdate(query);
        } else {
        	query = "INSERT INTO MATRIX_DATA VALUES (" + MATRIX_ID + ", " + ROW_NUM + ", " + COLUMN_NUM + ", " + VALUE + ")";
	        stmt = conn.createStatement();
	        res = stmt.executeUpdate(query);
        }

        query = "DELETE FROM MATRIX_DATA WHERE VALUE = 0";
        stmt = conn.createStatement();
        stmt.executeUpdate(query);

        if(print) System.out.println("DONE");
        return true;
    }
    public static boolean setm(boolean print, String MATRIX_ID, String ROW_DIM, String COLUMN_DIM) throws SQLException {
        Integer rows = Integer.parseInt(ROW_DIM);
        Integer cols = Integer.parseInt(COLUMN_DIM);
        if( rows <= 0 || cols <= 0 ) return false;

        String query = "SELECT ROW_DIM, COL_DIM FROM MATRIX WHERE MATRIX_ID = " + MATRIX_ID;
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(query);
        int res;
        Integer x = 0, y = 0;
        while (rs.next()) {
            x = Integer.parseInt(rs.getString(1));
            y = Integer.parseInt(rs.getString(2));
        }

        // check x and y for eixst
        if( x != 0 && y != 0 ) { // exists
            query = "SELECT VALUE FROM MATRIX_DATA WHERE MATRIX_ID = " + MATRIX_ID + " AND (ROW_NUM > " + rows + " OR  COL_NUM > " + cols + ")";
            stmt = conn.createStatement();
            rs = stmt.executeQuery(query);
            while (rs.next()) {
                return false;
            }

            query = "UPDATE MATRIX SET ROW_DIM = " + ROW_DIM + ", COL_DIM = " + COLUMN_DIM + " WHERE MATRIX_ID = " + MATRIX_ID;
            stmt = conn.createStatement();
            res = stmt.executeUpdate(query);

        } else { // DNE
            query = "INSERT INTO MATRIX VALUES (" + MATRIX_ID + ", " + ROW_DIM + ", " + COLUMN_DIM + ")";
            stmt = conn.createStatement();
            res = stmt.executeUpdate(query);
        }
        if(print) System.out.println("DONE");
        return true;
    }
    public static boolean delete(boolean print, String MATRIX_ID) throws SQLException {
        String query = "DELETE FROM MATRIX_DATA WHERE MATRIX_ID = " + MATRIX_ID;
        Statement stmt = conn.createStatement();
        int res = stmt.executeUpdate(query);

        query = "DELETE FROM MATRIX WHERE MATRIX_ID = " + MATRIX_ID;
        stmt = conn.createStatement();
        res = stmt.executeUpdate(query);

        if(print) System.out.println("DONE");
        return true;
    }
    public static boolean delete_all(boolean print) throws SQLException {
        String query = "TRUNCATE MATRIX_DATA";
        Statement stmt = conn.createStatement();
        int res = stmt.executeUpdate(query);

        query = "TRUNCATE MATRIX";
        stmt = conn.createStatement();
        res = stmt.executeUpdate(query);

        if(print) System.out.println("DONE");
        return true;
    }
    public static boolean add(boolean print, String MATRIX_1, String MATRIX_2, String MATRIX_3) throws SQLException {
        String query = "SELECT ROW_DIM, COL_DIM FROM MATRIX WHERE MATRIX_ID = " + MATRIX_2;
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(query);
        int x1 = 0, y1 = 0, x2 = 0, y2 = 0;
        while (rs.next()) {
            x1 = Integer.parseInt(rs.getString(1));
            y1 = Integer.parseInt(rs.getString(2));
        }
        query = "SELECT ROW_DIM, COL_DIM FROM MATRIX WHERE MATRIX_ID = " + MATRIX_3;
        stmt = conn.createStatement();
        rs = stmt.executeQuery(query);
        while (rs.next()) {
            x2 = Integer.parseInt(rs.getString(1));
            y2 = Integer.parseInt(rs.getString(2));
        }

        if( x1 <= 0 || y1 <= 0 || x2 <= 0 || y2 <= 0 ) return false;
        if( x1 != x2 || y1 != y2 ) return false;

        delete(false, MATRIX_1);
        setm(false, MATRIX_1, String.valueOf(x1), String.valueOf(y1));

        query = "SELECT ROW_NUM, COL_NUM, VALUE FROM MATRIX_DATA WHERE MATRIX_ID = " + MATRIX_2;
        stmt = conn.createStatement();
        rs = stmt.executeQuery(query);
        while (rs.next()) {
            setv(false, MATRIX_1, rs.getString(1), rs.getString(2), rs.getString(3));
        }

        query = "SELECT ROW_NUM, COL_NUM, VALUE FROM MATRIX_DATA WHERE MATRIX_ID = " + MATRIX_3;
        stmt = conn.createStatement();
        rs = stmt.executeQuery(query);
        String query2;
        Statement stmt2;
        while (rs.next()) {
            if( getv(false, MATRIX_1, rs.getString(1), rs.getString(2)) ) {
                query2 = "UPDATE MATRIX_DATA SET VALUE = VALUE + " + rs.getString(3) + " WHERE MATRIX_ID = " + MATRIX_1 + " AND ROW_NUM = " + rs.getString(1) + " AND COL_NUM = " + rs.getString(2);
                stmt2 = conn.createStatement();
                stmt2.executeUpdate(query2);
            } else {
                setv(false, MATRIX_1, rs.getString(1), rs.getString(2), rs.getString(3));
            }
        }

        query = "DELETE FROM MATRIX_DATA WHERE VALUE = 0";
        stmt = conn.createStatement();
        stmt.executeUpdate(query);

        if(print) System.out.println("DONE");
        return true;
    }
    public static boolean sub(boolean print, String MATRIX_1, String MATRIX_2, String MATRIX_3) throws SQLException {
        String query = "SELECT ROW_DIM, COL_DIM FROM MATRIX WHERE MATRIX_ID = " + MATRIX_2;
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(query);
        int x1 = 0, y1 = 0, x2 = 0, y2 = 0;
        while (rs.next()) {
            x1 = Integer.parseInt(rs.getString(1));
            y1 = Integer.parseInt(rs.getString(2));
        }
        query = "SELECT ROW_DIM, COL_DIM FROM MATRIX WHERE MATRIX_ID = " + MATRIX_3;
        stmt = conn.createStatement();
        rs = stmt.executeQuery(query);
        while (rs.next()) {
            x2 = Integer.parseInt(rs.getString(1));
            y2 = Integer.parseInt(rs.getString(2));
        }


        if( x1 <= 0 || y1 <= 0 || x2 <= 0 || y2 <= 0 ) return false;
        if( x1 != x2 || y1 != y2 ) return false;

        delete(false, MATRIX_1);
        setm(false, MATRIX_1, String.valueOf(x1), String.valueOf(y1));

        query = "SELECT ROW_NUM, COL_NUM, VALUE FROM MATRIX_DATA WHERE MATRIX_ID = " + MATRIX_2;
        stmt = conn.createStatement();
        rs = stmt.executeQuery(query);
        while (rs.next()) {
            setv(false, MATRIX_1, rs.getString(1), rs.getString(2), rs.getString(3));
        }

        query = "SELECT ROW_NUM, COL_NUM, VALUE FROM MATRIX_DATA WHERE MATRIX_ID = " + MATRIX_3;
        stmt = conn.createStatement();
        rs = stmt.executeQuery(query);
        String query2;
        Statement stmt2;
        while (rs.next()) {
            if( getv(false, MATRIX_1, rs.getString(1), rs.getString(2)) ) {
                query2 = "UPDATE MATRIX_DATA SET VALUE = VALUE - " + rs.getString(3) + " WHERE MATRIX_ID = " + MATRIX_1 + " AND ROW_NUM = " + rs.getString(1) + " AND COL_NUM = " + rs.getString(2);
                stmt2 = conn.createStatement();
                stmt2.executeUpdate(query2);
            } else {
                setv(false, MATRIX_1, rs.getString(1), rs.getString(2), String.valueOf(0.0-Double.parseDouble(rs.getString(3))));
            }
        }

        query = "DELETE FROM MATRIX_DATA WHERE VALUE = 0";
        stmt = conn.createStatement();
        stmt.executeUpdate(query);

        if(print) System.out.println("DONE");
        return true;
    }
    public static boolean mult(boolean print, String MATRIX_1, String MATRIX_2, String MATRIX_3) throws SQLException {
        String query = "SELECT ROW_DIM, COL_DIM FROM MATRIX WHERE MATRIX_ID = " + MATRIX_2;
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(query);
        Integer x1 = 0, y1 = 0;
        while (rs.next()) {
            x1 = Integer.parseInt(rs.getString(1));
            y1 = Integer.parseInt(rs.getString(2));
        }

        if( x1 <= 0 || y1 <= 0 ) return false;

        query = "SELECT ROW_DIM, COL_DIM FROM MATRIX WHERE MATRIX_ID = " + MATRIX_3;
        stmt = conn.createStatement();
        rs = stmt.executeQuery(query);
        Integer x2 = 0, y2 = 0;
        while (rs.next()) {
            x2 = Integer.parseInt(rs.getString(1));
            y2 = Integer.parseInt(rs.getString(2));
        }

        if( x2 <= 0 || y2 <= 0 ) return false;

        if ( y1 != x2 ) return false; // columns rows test

        delete(false, MATRIX_1);
        setm(false, MATRIX_1, String.valueOf(x1), String.valueOf(y2));

        Double[][] m2 = new Double[x1][y1];
        query = "SELECT ROW_NUM, COL_NUM, VALUE FROM MATRIX_DATA WHERE MATRIX_ID = " + MATRIX_2;
        stmt = conn.createStatement();
        rs = stmt.executeQuery(query);
        while (rs.next()) {
            m2[Integer.parseInt(rs.getString(1))-1][Integer.parseInt(rs.getString(2))-1] = Double.parseDouble(rs.getString(3));
        }

        Double[][] m3 = new Double[x2][y2];
        query = "SELECT ROW_NUM, COL_NUM, VALUE FROM MATRIX_DATA WHERE MATRIX_ID = " + MATRIX_3;
        stmt = conn.createStatement();
        rs = stmt.executeQuery(query);
        while (rs.next()) {
            m3[Integer.parseInt(rs.getString(1))-1][Integer.parseInt(rs.getString(2))-1] = Double.parseDouble(rs.getString(3));
        }

        if(debug) {
            for( int i = 0; i < x1; ++i ) {
                for( int j = 0; j < y1; ++j ) {
                    System.out.printf("%f ", m2[i][j]);
                }
                System.out.println();
            }
            System.out.println();
            for( int i = 0; i < x2; ++i ) {
                for( int j = 0; j < y2; ++j ) {
                    System.out.printf("%f ", m3[i][j]);
                }
                System.out.println();
            }
            System.out.println();
        }

        Double sum = 0.0;
        Double[][] m4 = new Double[x1][y2];
        for( int i = 0; i < x1; ++i ) {
            for( int j = 0; j < y2; ++j ) {
                for( int k = 0; k < y1; ++k ) {
                    if(m2[i][k] != null && m3[k][j] != null) sum+= m2[i][k] * m3[k][j];
                }
                if(sum != 0.0) {
                    m4[i][j] = sum;
                    setv(false, MATRIX_1, String.valueOf(i+1), String.valueOf(j+1), String.valueOf(m4[i][j]));
                }
                if(debug) System.out.printf("%f ", m4[i][j]);
                sum = 0.0;
            }
            if(debug) System.out.println();
        }

        if(print) System.out.println("DONE");
        return true;
    }
    public static boolean transpose(boolean print, String MATRIX_1, String MATRIX_2) throws SQLException {
        String query = "SELECT ROW_DIM, COL_DIM FROM MATRIX WHERE MATRIX_ID = " + MATRIX_2;
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(query);
        Integer x = 0, y = 0;
        while (rs.next()) {
            x = Integer.parseInt(rs.getString(1));
            y = Integer.parseInt(rs.getString(2));
        }

        if( x <= 0 || y <= 0 ) return false;

        delete(false, MATRIX_1);

        query = "INSERT INTO MATRIX VALUES (" + MATRIX_1 + ", " + y + ", " + x + ")";
        stmt = conn.createStatement();
        int res = stmt.executeUpdate(query);

        query = "SELECT ROW_NUM, COL_NUM, VALUE FROM MATRIX_DATA WHERE MATRIX_ID = " + MATRIX_2;
        stmt = conn.createStatement();
        rs = stmt.executeQuery(query);
        while (rs.next()) {
            setv(false, MATRIX_1, rs.getString(2), rs.getString(1), rs.getString(3));
        }

        if(print) System.out.println("DONE");
        return true;
    }
    public static boolean sql(boolean print, String query) throws SQLException {
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(query);
        while(rs.next()) {
            if(print) {
                System.out.println(rs.getString(1));
            }
            return true;
        }
        return false;
    }



    public static void main(String[] args) throws ClassNotFoundException, SQLException {

        if( args.length < 2 ) {
            error();
            return;
        }
    	String CONNECTION_STRING = args[0];
    	String INPUT_FILE = args[1];

    	conn = DriverManager.getConnection(CONNECTION_STRING);
    	Scanner s;
    	try {
    		s = new Scanner(new File(INPUT_FILE));
    		String line;
	    	while(s.hasNextLine()) {
	    		line = s.nextLine();
                if(debug) System.out.println("'" + line + "'");
	    		String[] split = line.split(" ");

	    		if( split[0].equals("GETV") && split.length == 4 ) { 
                    if(!getv(true, split[1], split[2], split[3])) error(); 
                } else if( split[0].equals("SETV") && split.length == 5 ) {
	    			if(!setv(true, split[1], split[2], split[3], split[4])) error();
                } else if( split[0].equals("SETM") && split.length == 4 ) {
	    			if(!setm(true, split[1], split[2], split[3])) error();
                } else if( split[0].equals("DELETE") && split.length == 2 ) {
	    			if( split[1].equals("ALL") ) {
	    				if(!delete_all(true)) error();
                    } else {
	    				if(!delete(true, split[1])) error();
                    }
	    		} else if( split[0].equals("ADD") && split.length == 4 ) {
	    			if(!add(true, split[1], split[2], split[3])) error();
                } else if( split[0].equals("SUB") && split.length == 4 ) {
	    			if(!sub(true, split[1], split[2], split[3])) error();
                } else if( split[0].equals("MULT") && split.length == 4 ) {
					if(!mult(true, split[1], split[2], split[3])) error();
                } else if( split[0].equals("TRANSPOSE") && split.length == 3 ) {
					if(!transpose(true, split[1], split[2])) error();
                } else if( split[0].equals("SQL") && split.length >= 2 ) {
					if(!sql(true, line.substring(4))) error();
				}
	    		else error();
                if(debug) print();
	    	}
    	} catch (FileNotFoundException e) {
    		System.out.println("ERROR: Unable to open file.");
    	}

        conn.close();
    }
}
