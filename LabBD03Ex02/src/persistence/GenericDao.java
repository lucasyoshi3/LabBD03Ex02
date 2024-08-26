package persistence;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class GenericDao {
	private Connection c;
	
	public Connection getConnection() throws ClassNotFoundException, SQLException{
		String host = "localhost";
		String dbName = "Banco_Lab03";
		String user = "sa";
		String senha = null;
		Class.forName("net.sorceforge.jtds.jdbc.Driver");
		c = DriverManager.getConnection(String.format("jdbc:jtds:sqlserver: %s:1433;databaseName=%s;user=%s;password=%s;",
				host, dbName, user, senha));
		return c;
	}
}
