package ModeloDAO;

import Config.ClsConexion;
import Interfaces.ProductoDAO;
import Modelo.Producto;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductoDAOImpl implements ProductoDAO {

    private static final String SQL_LISTAR = "SELECT idProducto, nombre, descripcion, precio, stock, idCategoria, estado FROM producto WHERE estado <> 'ELIMINADO'";
    private static final String SQL_BUSCAR_ID = "SELECT idProducto, nombre, descripcion, precio, stock, idCategoria, estado FROM producto WHERE idProducto = ?";
    private static final String SQL_BUSCAR_NOMBRE = "SELECT idProducto, nombre, descripcion, precio, stock, idCategoria, estado FROM producto WHERE UPPER(nombre) LIKE ? AND estado <> 'ELIMINADO'";
    private static final String SQL_INSERTAR = "INSERT INTO producto(nombre, descripcion, precio, stock, idCategoria, estado) VALUES(?, ?, ?, ?, ?, ?)";
    private static final String SQL_ACTUALIZAR = "UPDATE producto SET nombre = ?, descripcion = ?, precio = ?, stock = ?, idCategoria = ?, estado = ? WHERE idProducto = ?";
    private static final String SQL_ELIMINAR = "UPDATE producto SET estado = 'ELIMINADO' WHERE idProducto = ?";

    private final ClsConexion conexion;

    public ProductoDAOImpl() {
        this.conexion = new ClsConexion();
    }

    @Override
    public List<Producto> listar() {
        List<Producto> productos = new ArrayList<>();
        try (Connection cn = conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(SQL_LISTAR);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                productos.add(mapearProducto(rs));
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Error al listar productos", ex);
        }
        return productos;
    }

    @Override
    public Producto obtenerPorId(int idProducto) {
        try (Connection cn = conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(SQL_BUSCAR_ID)) {
            ps.setInt(1, idProducto);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearProducto(rs);
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Error al obtener el producto", ex);
        }
        return null;
    }

    @Override
    public List<Producto> buscarPorNombre(String termino) {
        List<Producto> productos = new ArrayList<>();
        try (Connection cn = conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(SQL_BUSCAR_NOMBRE)) {
            ps.setString(1, "%" + termino.toUpperCase() + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    productos.add(mapearProducto(rs));
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Error al buscar productos", ex);
        }
        return productos;
    }

    @Override
    public boolean registrar(Producto producto) {
        try (Connection cn = conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(SQL_INSERTAR)) {
            ps.setString(1, producto.getNombre());
            ps.setString(2, producto.getDescripcion());
            ps.setBigDecimal(3, producto.getPrecio());
            ps.setInt(4, producto.getStock());
            ps.setInt(5, producto.getIdCategoria());
            ps.setString(6, producto.getEstado());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            throw new RuntimeException("Error al registrar el producto", ex);
        }
    }

    @Override
    public boolean actualizar(Producto producto) {
        try (Connection cn = conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(SQL_ACTUALIZAR)) {
            ps.setString(1, producto.getNombre());
            ps.setString(2, producto.getDescripcion());
            ps.setBigDecimal(3, producto.getPrecio());
            ps.setInt(4, producto.getStock());
            ps.setInt(5, producto.getIdCategoria());
            ps.setString(6, producto.getEstado());
            ps.setInt(7, producto.getIdProducto());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            throw new RuntimeException("Error al actualizar el producto", ex);
        }
    }

    @Override
    public boolean eliminar(int idProducto) {
        try (Connection cn = conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(SQL_ELIMINAR)) {
            ps.setInt(1, idProducto);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            throw new RuntimeException("Error al eliminar el producto", ex);
        }
    }

    private Producto mapearProducto(ResultSet rs) throws SQLException {
        Producto producto = new Producto();
        producto.setIdProducto(rs.getInt("idProducto"));
        producto.setNombre(rs.getString("nombre"));
        producto.setDescripcion(rs.getString("descripcion"));
        producto.setPrecio(rs.getBigDecimal("precio"));
        producto.setStock(rs.getInt("stock"));
        producto.setIdCategoria(rs.getInt("idCategoria"));
        producto.setEstado(rs.getString("estado"));
        return producto;
    }
}
