package Controlador;

import Interfaces.ProductoDAO;
import Interfaces.UsuarioDAO;
import Modelo.Producto;
import Modelo.Usuario;
import ModeloDAO.ProductoDAOImpl;
import ModeloDAO.UsuarioDAOImpl;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ControladorPrincipal", urlPatterns = {"/ControladorPrincipal"})
public class ControladorPrincipal extends HttpServlet {

    private final ProductoDAO productoDAO = new ProductoDAOImpl();
    private final UsuarioDAO usuarioDAO = new UsuarioDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");
        if (accion == null || accion.isEmpty()) {
            accion = "inicio";
        }
        switch (accion) {
            case "inicio":
                mostrarInicio(request, response);
                break;
            case "listarProductos":
                listarProductos(request, response);
                break;
            case "verProducto":
                verProducto(request, response);
                break;
            case "mostrarLogin":
                request.getRequestDispatcher("Login.jsp").forward(request, response);
                break;
            case "procesarLogin":
                procesarLogin(request, response);
                break;
            case "cerrarSesion":
                cerrarSesion(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Acción no soportada: " + accion);
                break;
        }
    }

    private void mostrarInicio(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Producto> productos = productoDAO.listar();
        request.setAttribute("productosDestacados", productos);
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    private void listarProductos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String termino = request.getParameter("busqueda");
        List<Producto> productos;
        if (termino != null && !termino.trim().isEmpty()) {
            productos = productoDAO.buscarPorNombre(termino.trim());
            request.setAttribute("terminoBusqueda", termino);
        } else {
            productos = productoDAO.listar();
        }
        request.setAttribute("productos", productos);
        request.getRequestDispatcher("productos.jsp").forward(request, response);
    }

    private void verProducto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect("ControladorPrincipal?accion=listarProductos");
            return;
        }
        try {
            int idProducto = Integer.parseInt(idParam);
            Producto producto = productoDAO.obtenerPorId(idProducto);
            if (producto == null) {
                response.sendRedirect("ControladorPrincipal?accion=listarProductos");
                return;
            }
            request.setAttribute("producto", producto);
            request.getRequestDispatcher("productoDetalle.jsp").forward(request, response);
        } catch (NumberFormatException ex) {
            response.sendRedirect("ControladorPrincipal?accion=listarProductos");
        }
    }

    private void procesarLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String usuario = request.getParameter("usuario");
        String clave = request.getParameter("clave");
        Usuario usuarioValidado = usuarioDAO.validarAcceso(usuario, clave);
        if (usuarioValidado != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("usuarioAutenticado", usuarioValidado);
            response.sendRedirect("ControladorPrincipal?accion=inicio");
        } else {
            request.setAttribute("mensaje", "Credenciales no válidas");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        }
    }

    private void cerrarSesion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect("ControladorPrincipal?accion=inicio");
    }
}
