<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ingreso al Sistema</title>
        <link rel="stylesheet" type="text/css" href="recursos/estilos.css">
    </head>
    <body>
        <header>
            <h1>Ingreso al Sistema</h1>
            <nav>
                <a href="ControladorPrincipal?accion=inicio">Inicio</a>
                <a href="ControladorPrincipal?accion=listarProductos">Productos</a>
            </nav>
        </header>
        <main>
            <section>
                <form action="ControladorPrincipal" method="post">
                    <input type="hidden" name="accion" value="procesarLogin">
                    <label for="usuario">Usuario</label>
                    <input type="text" id="usuario" name="usuario" required>
                    <label for="clave">Contraseña</label>
                    <input type="password" id="clave" name="clave" required>
                    <%
                        String mensaje = (String) request.getAttribute("mensaje");
                        if (mensaje != null) {
                    %>
                    <p class="alerta"><%= mensaje %></p>
                    <%
                        }
                    %>
                    <button type="submit">Ingresar</button>
                </form>
            </section>
        </main>
        <footer>
            <p>&copy; <%= java.time.Year.now() %> Tienda de Electrodomésticos</p>
        </footer>
    </body>
</html>
