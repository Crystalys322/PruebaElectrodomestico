<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Modelo.Producto"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Panel de Productos</title>
        <link rel="stylesheet" type="text/css" href="recursos/estilos.css">
    </head>
    <body>
        <header>
            <h1>Panel de Productos</h1>
            <nav>
                <a href="ControladorPrincipal?accion=inicio">Inicio</a>
                <a href="ControladorPrincipal?accion=listarProductos">Productos</a>
                <a href="ControladorPrincipal?accion=panel" class="activo">Panel</a>
                <a href="ControladorPrincipal?accion=mostrarLogin">Iniciar sesión</a>
            </nav>
        </header>
        <main class="panel">
            <section class="panel-columna panel-productos">
                <h2>Catálogo</h2>
                <ul>
                    <%
                        List<Producto> productos = (List<Producto>) request.getAttribute("productos");
                        if (productos != null && !productos.isEmpty()) {
                            for (Producto producto : productos) {
                    %>
                    <li>
                        <a href="ControladorPrincipal?accion=panel&id=<%= producto.getIdProducto() %>">
                            <strong><%= producto.getNombre() %></strong><br>
                            <span>Stock: <%= producto.getStock() %></span>
                        </a>
                    </li>
                    <%
                            }
                        } else {
                    %>
                    <li>No hay productos registrados.</li>
                    <%
                        }
                    %>
                </ul>
            </section>
            <section class="panel-columna panel-detalle">
                <h2>Detalle seleccionado</h2>
                <%
                    Producto seleccionado = (Producto) request.getAttribute("productoSeleccionado");
                    if (seleccionado != null) {
                %>
                <article>
                    <h3><%= seleccionado.getNombre() %></h3>
                    <p><%= seleccionado.getDescripcion() %></p>
                    <p><strong>Precio:</strong> S/ <%= seleccionado.getPrecio() %></p>
                    <p><strong>Stock disponible:</strong> <%= seleccionado.getStock() %></p>
                    <p><strong>ID Categoría:</strong> <%= seleccionado.getIdCategoria() %></p>
                    <p><strong>Estado:</strong> <%= seleccionado.getEstado() %></p>
                </article>
                <%
                    } else {
                %>
                <p>Selecciona un producto del listado para ver su información.</p>
                <%
                    }
                %>
            </section>
        </main>
        <footer>
            <p>&copy; <%= java.time.Year.now() %> Tienda de Electrodomésticos</p>
        </footer>
    </body>
</html>
