package ModeloDAO;

import Config.ClsConexion;
import Interfaces.UsuarioDAO;
import Modelo.Usuario;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UsuarioDAOImpl implements UsuarioDAO {

    private static final String SQL_VALIDAR = "SELECT idUsuario, usuario, clave, rol, estado FROM usuario WHERE usuario = ? AND clave = ? AND estado = 'ACTIVO'";

    private final ClsConexion conexion;

    public UsuarioDAOImpl() {
        this.conexion = new ClsConexion();
    }

    @Override
    public Usuario validarAcceso(String usuario, String clave) {
        try (Connection cn = conexion.getConnection();
             PreparedStatement ps = cn.prepareStatement(SQL_VALIDAR)) {
            ps.setString(1, usuario);
            ps.setString(2, clave);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Usuario u = new Usuario();
                    u.setIdUsuario(rs.getInt("idUsuario"));
                    u.setNombreUsuario(rs.getString("usuario"));
                    u.setClave(rs.getString("clave"));
                    u.setRol(rs.getString("rol"));
                    u.setEstado(rs.getString("estado"));
                    return u;
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Error al validar el acceso", ex);
        }
        return null;
    }
}
