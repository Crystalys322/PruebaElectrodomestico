<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Modelo.Producto"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Tienda Electrodomésticos - Inicio</title>
        <link rel="stylesheet" type="text/css" href="recursos/estilos.css">
    </head>
    <body>
        <header>
            <h1>Tienda de Electrodomésticos</h1>
            <nav>
                <a href="ControladorPrincipal?accion=inicio">Inicio</a>
                <a href="ControladorPrincipal?accion=listarProductos">Productos</a>
                <a href="ControladorPrincipal?accion=mostrarLogin">Iniciar sesión</a>
            </nav>
        </header>
        <main>
            <section>
                <h2>Productos destacados</h2>
                <div class="grid">
                    <%
                        List<Producto> destacados = (List<Producto>) request.getAttribute("productosDestacados");
                        if (destacados != null && !destacados.isEmpty()) {
                            for (Producto producto : destacados) {
                    %>
                    <article class="card">
                        <h3><%= producto.getNombre() %></h3>
                        <p><%= producto.getDescripcion() %></p>
                        <p class="precio">S/ <%= producto.getPrecio() %></p>
                        <a class="boton" href="ControladorPrincipal?accion=verProducto&id=<%= producto.getIdProducto() %>">Ver detalle</a>
                    </article>
                    <%
                            }
                        } else {
                    %>
                    <p>No hay productos para mostrar.</p>
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
