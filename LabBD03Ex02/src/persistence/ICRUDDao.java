package persistence;

import java.sql.SQLException;

public interface ICRUDDao<T> {
	public String insert(T t) throws SQLException, ClassNotFoundException;
	public String update(T t) throws SQLException, ClassNotFoundException;
	public String delete(T t) throws SQLException, ClassNotFoundException;
}
