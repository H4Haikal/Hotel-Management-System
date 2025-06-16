/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package hotel.management;

import java.sql.*;

public class DBConnection {
    
    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(
            "jdbc:mysql://localhost:3307/hotel_management?serverTimezone=UTC&zeroDateTimeBehavior=CONVERT_TO_NULL",
            "root",
            ""
        );
    }
}
