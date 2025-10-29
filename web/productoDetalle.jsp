<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.Producto"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Detalle de Producto</title>
        <link rel="stylesheet" type="text/css" href="recursos/estilos.css">
    </head>
    <body>
        <header>
            <h1>Detalle del Producto</h1>
            <nav>
                <a href="ControladorPrincipal?accion=inicio">Inicio</a>
                <a href="ControladorPrincipal?accion=listarProductos">Productos</a>
                <a href="ControladorPrincipal?accion=mostrarLogin">Iniciar sesión</a>
            </nav>
        </header>
        <main>
            <section>
                <%
                    Producto producto = (Producto) request.getAttribute("producto");
                    if (producto != null) {
                %>
                <article class="card">
                    <h2><%= producto.getNombre() %></h2>
                    <p><strong>Descripción:</strong> <%= producto.getDescripcion() %></p>
                    <p><strong>Precio:</strong> S/ <%= producto.getPrecio() %></p>
                    <p><strong>Stock disponible:</strong> <%= producto.getStock() %></p>
                    <p><strong>Estado:</strong> <%= producto.getEstado() %></p>
                </article>
                <%
                    } else {
                %>
                <p>El producto no está disponible.</p>
                <%
                    }
                %>
                <p><a class="boton" href="ControladorPrincipal?accion=listarProductos">Volver al catálogo</a></p>
            </section>
        </main>
        <footer>
            <p>&copy; <%= java.time.Year.now() %> Tienda de Electrodomésticos</p>
        </footer>
    </body>
</html>
