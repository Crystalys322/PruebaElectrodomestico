package ModeloDAO;

import Config.ClsConexion;
import Interfaces.VentaDAO;
import Modelo.DetalleVenta;
import Modelo.Venta;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;

public class VentaDAOImpl implements VentaDAO {

    private static final String SQL_INSERTAR_VENTA = "INSERT INTO venta(idCliente, idUsuario, fecha, total, estado) VALUES(?, ?, ?, ?, ?)";
    private static final String SQL_INSERTAR_DETALLE = "INSERT INTO detalle_venta(idVenta, idProducto, cantidad, precioUnitario, subtotal) VALUES(?, ?, ?, ?, ?)";
    private static final String SQL_OBTENER_VENTA = "SELECT idVenta, idCliente, idUsuario, fecha, total, estado FROM venta WHERE idVenta = ?";

    private final ClsConexion conexion;

    public VentaDAOImpl() {
        this.conexion = new ClsConexion();
    }

    @Override
    public boolean registrarVenta(Venta venta, List<DetalleVenta> detalles) {
        try (Connection cn = conexion.getConexion()) {
            cn.setAutoCommit(false);
            try (PreparedStatement psVenta = cn.prepareStatement(SQL_INSERTAR_VENTA, Statement.RETURN_GENERATED_KEYS)) {
                psVenta.setInt(1, venta.getIdCliente());
                psVenta.setInt(2, venta.getIdUsuario());
                psVenta.setTimestamp(3, toTimestamp(venta.getFecha()));
                psVenta.setBigDecimal(4, venta.getTotal());
                psVenta.setString(5, venta.getEstado());
                int filas = psVenta.executeUpdate();
                if (filas == 0) {
                    cn.rollback();
                    return false;
                }
                try (ResultSet rs = psVenta.getGeneratedKeys()) {
                    if (rs.next()) {
                        int idGenerado = rs.getInt(1);
                        venta.setIdVenta(idGenerado);
                        for (DetalleVenta detalle : detalles) {
                            registrarDetalle(cn, idGenerado, detalle);
                        }
                    } else {
                        cn.rollback();
                        return false;
                    }
                }
            }
            cn.commit();
            return true;
        } catch (SQLException ex) {
            throw new RuntimeException("Error al registrar la venta", ex);
        }
    }

    @Override
    public Venta obtenerPorId(int idVenta) {
        try (Connection cn = conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(SQL_OBTENER_VENTA)) {
            ps.setInt(1, idVenta);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Venta venta = new Venta();
                    venta.setIdVenta(rs.getInt("idVenta"));
                    venta.setIdCliente(rs.getInt("idCliente"));
                    venta.setIdUsuario(rs.getInt("idUsuario"));
                    Timestamp fecha = rs.getTimestamp("fecha");
                    if (fecha != null) {
                        venta.setFecha(fecha.toLocalDateTime());
                    }
                    venta.setTotal(rs.getBigDecimal("total"));
                    venta.setEstado(rs.getString("estado"));
                    return venta;
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Error al obtener la venta", ex);
        }
        return null;
    }

    private void registrarDetalle(Connection cn, int idVenta, DetalleVenta detalle) throws SQLException {
        try (PreparedStatement psDetalle = cn.prepareStatement(SQL_INSERTAR_DETALLE)) {
            psDetalle.setInt(1, idVenta);
            psDetalle.setInt(2, detalle.getIdProducto());
            psDetalle.setInt(3, detalle.getCantidad());
            psDetalle.setBigDecimal(4, detalle.getPrecioUnitario());
            psDetalle.setBigDecimal(5, detalle.getSubtotal());
            psDetalle.executeUpdate();
        }
    }

    private Timestamp toTimestamp(LocalDateTime fecha) {
        if (fecha == null) {
            return Timestamp.valueOf(LocalDateTime.now());
        }
        return Timestamp.valueOf(fecha);
    }
}
