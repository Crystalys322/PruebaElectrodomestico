package ModeloDAO;

import Config.ClsConexion;
import Interfaces.ClienteDAO;
import Modelo.Cliente;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ClienteDAOImpl implements ClienteDAO {

    private static final String SQL_LISTAR = "SELECT idCliente, nombres, apellidos, dni, telefono, correo, direccion FROM cliente";
    private static final String SQL_BUSCAR_ID = "SELECT idCliente, nombres, apellidos, dni, telefono, correo, direccion FROM cliente WHERE idCliente = ?";
    private static final String SQL_INSERTAR = "INSERT INTO cliente(nombres, apellidos, dni, telefono, correo, direccion) VALUES(?, ?, ?, ?, ?, ?)";
    private static final String SQL_ACTUALIZAR = "UPDATE cliente SET nombres = ?, apellidos = ?, dni = ?, telefono = ?, correo = ?, direccion = ? WHERE idCliente = ?";

    private final ClsConexion conexion;

    public ClienteDAOImpl() {
        this.conexion = new ClsConexion();
    }

    @Override
    public List<Cliente> listar() {
        List<Cliente> clientes = new ArrayList<>();
        try (Connection cn = conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(SQL_LISTAR);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                clientes.add(mapearCliente(rs));
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Error al listar clientes", ex);
        }
        return clientes;
    }

    @Override
    public Cliente obtenerPorId(int idCliente) {
        try (Connection cn = conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(SQL_BUSCAR_ID)) {
            ps.setInt(1, idCliente);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearCliente(rs);
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Error al obtener el cliente", ex);
        }
        return null;
    }

    @Override
    public boolean registrar(Cliente cliente) {
        try (Connection cn = conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(SQL_INSERTAR)) {
            ps.setString(1, cliente.getNombres());
            ps.setString(2, cliente.getApellidos());
            ps.setString(3, cliente.getDni());
            ps.setString(4, cliente.getTelefono());
            ps.setString(5, cliente.getCorreo());
            ps.setString(6, cliente.getDireccion());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            throw new RuntimeException("Error al registrar el cliente", ex);
        }
    }

    @Override
    public boolean actualizar(Cliente cliente) {
        try (Connection cn = conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(SQL_ACTUALIZAR)) {
            ps.setString(1, cliente.getNombres());
            ps.setString(2, cliente.getApellidos());
            ps.setString(3, cliente.getDni());
            ps.setString(4, cliente.getTelefono());
            ps.setString(5, cliente.getCorreo());
            ps.setString(6, cliente.getDireccion());
            ps.setInt(7, cliente.getIdCliente());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            throw new RuntimeException("Error al actualizar el cliente", ex);
        }
    }

    private Cliente mapearCliente(ResultSet rs) throws SQLException {
        Cliente cliente = new Cliente();
        cliente.setIdCliente(rs.getInt("idCliente"));
        cliente.setNombres(rs.getString("nombres"));
        cliente.setApellidos(rs.getString("apellidos"));
        cliente.setDni(rs.getString("dni"));
        cliente.setTelefono(rs.getString("telefono"));
        cliente.setCorreo(rs.getString("correo"));
        cliente.setDireccion(rs.getString("direccion"));
        return cliente;
    }
}
