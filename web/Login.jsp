diff --git a/web/Login.jsp b/web/Login.jsp
index 91ed0f72372011ce22c81fdc6900a1c38001d9aa..7cea7f0091b2378181e06345cd25ccd1fb597fb5 100644
--- a/web/Login.jsp
+++ b/web/Login.jsp
@@ -1,17 +1,42 @@
-<%-- 
-    Document   : Login
-    Created on : 29 oct. 2025, 11:45:11 a. m.
-    Author     : Equipo
---%>
-
 <%@page contentType="text/html" pageEncoding="UTF-8"%>
 <!DOCTYPE html>
 <html>
     <head>
         <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
-        <title>JSP Page</title>
+        <title>Ingreso al Sistema</title>
+        <link rel="stylesheet" type="text/css" href="recursos/estilos.css">
     </head>
     <body>
-        <h1>Hello World!</h1>
+        <header>
+            <h1>Ingreso al Sistema</h1>
+            <nav>
+                <a href="ControladorPrincipal?accion=inicio">Inicio</a>
+                <a href="ControladorPrincipal?accion=listarProductos">Productos</a>
+                <a href="ControladorPrincipal?accion=panel">Panel</a>
+            </nav>
+        </header>
+        <main>
+            <section>
+                <form action="ControladorPrincipal" method="post">
+                    <input type="hidden" name="accion" value="procesarLogin">
+                    <label for="usuario">Usuario</label>
+                    <input type="text" id="usuario" name="usuario" required>
+                    <label for="clave">Contraseña</label>
+                    <input type="password" id="clave" name="clave" required>
+                    <%
+                        String mensaje = (String) request.getAttribute("mensaje");
+                        if (mensaje != null) {
+                    %>
+                    <p class="alerta"><%= mensaje %></p>
+                    <%
+                        
+                    %>
+                    <button type="submit">Ingresar</button>
+                </form>
+            </section>
+        </main>
+        <footer>
+            <p>&copy; <%= java.time.Year.now() %> Tienda de Electrodomésticos</p>
+        </footer>
     </body>
 </html>
