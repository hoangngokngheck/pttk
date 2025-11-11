package dao;

import model.DBConnect;

import java.sql.Connection;
import java.sql.SQLException;

/**
 * Lớp DAO cơ sở (Base DAO)
 * Cung cấp Connection cho các lớp DAO con
 */
public class DAO {
    protected Connection con;

    public DAO() {
        // Constructor - Connection sẽ được lấy khi cần
    }

    /**
     * Lấy Connection từ DBConnect
     * @return Connection
     * @throws SQLException
     */
    protected Connection getConnection() throws SQLException {
        return DBConnect.getConnection();
    }
}

