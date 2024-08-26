package persistence;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;

import model.Cliente;

public class ClienteDao implements ICRUDDao<Cliente> {

	private GenericDao gDao;
	
	public ClienteDao (GenericDao gDao) {
		this.gDao = gDao;
	}
	
	public String callProcCliente(String opcao, Cliente cli) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_cliente(?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, opcao);
		cs.setString(2, cli.getCpf());
		cs.setString(3, cli.getNome());
		cs.setString(3, cli.getEmail());
		cs.setBigDecimal(4, BigDecimal.valueOf(cli.getLimiteCredito()));
		cs.setDate(5, cli.getDataNascimento());
		
		cs.registerOutParameter(6, Types.VARCHAR);
		cs.execute();
		
		String saida = cs.getString(6);
		
		cs.close();
		c.close();
		return saida;
		
	}
	
	@Override
	public String insert(Cliente t) throws SQLException, ClassNotFoundException {
		return callProcCliente("i", t);
	}

	@Override
	public String update(Cliente t) throws SQLException, ClassNotFoundException {
		// TODO Auto-generated method stub
		return callProcCliente("a", t);
	}

	@Override
	public String delete(Cliente t) throws SQLException, ClassNotFoundException {
		// TODO Auto-generated method stub
		return callProcCliente("e", t);
	}
	
}
