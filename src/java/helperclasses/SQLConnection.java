/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package helperclasses;

import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import oracle.jdbc.OracleConnection;
/**
 *
 * @author ujucoco
 */
public class SQLConnection {
    public static OracleConnection oconn;
    
    public OracleConnection connect() throws SQLException{
            DriverManager.registerDriver(new oracle.jdbc.OracleDriver());
            oconn = (OracleConnection) DriverManager.getConnection("jdbc:oracle:thin:@localhost:1522:free", "c##fandf", "database");
            return oconn;
           
    }
    
    public void createUserCreds() throws SQLException{
            Statement statement = oconn.createStatement();
            statement.execute("create table user_creds(email varchar2(255), password varchar2(255))");
            
    }
    public void quit() throws SQLException{
        oconn.close();
    }
}
