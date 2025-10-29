<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Modelo.Producto"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Catálogo de Productos</title>
        <link rel="stylesheet" type="text/css" href="recursos/estilos.css">
    </head>
    <body>
        <header>
            <h1>Catálogo de Productos</h1>
            <nav>
                <a href="ControladorPrincipal?accion=inicio">Inicio</a>
                <a href="ControladorPrincipal?accion=listarProductos">Productos</a>
                <a href="ControladorPrincipal?accion=panel">Panel</a>
                <a href="ControladorPrincipal?accion=mostrarLogin">Iniciar sesión</a>
            </nav>
        </header>
        <main>
            <section>
                <form method="get" action="ControladorPrincipal">
                    <input type="hidden" name="accion" value="listarProductos">
                    <label for="busqueda">Buscar producto:</label>
                    <input type="search" id="busqueda" name="busqueda" value="<%= request.getAttribute("terminoBusqueda") != null ? request.getAttribute("terminoBusqueda") : "" %>">
                    <button type="submit">Buscar</button>
                </form>
            </section>
            <section>
                <div class="grid">
                    <%
                        List<Producto> productos = (List<Producto>) request.getAttribute("productos");
                        if (productos != null && !productos.isEmpty()) {
                            for (Producto producto : productos) {
                    %>
                    <article class="card">
                        <h3><%= producto.getNombre() %></h3>
                        <p><%= producto.getDescripcion() %></p>
                        <p class="precio">S/ <%= producto.getPrecio() %></p>
                        <p>Stock: <%= producto.getStock() %></p>
                        <a class="boton" href="ControladorPrincipal?accion=verProducto&id=<%= producto.getIdProducto() %>">Ver detalle</a>
                    </article>
                    <%
                            }
                        } else {
                    %>
                    <p>No se encontraron productos.</p>
                    <%
                        }
                    %>
                </div>
            </section>
        </main>
        <footer>
            <p>&copy; <%= java.time.Year.now() %> Tienda de Electrodomésticos</p>
        </footer>
    </body>
</html>
