package Interfaces;

import Modelo.Producto;
import java.util.List;

public interface ProductoDAO {
    List<Producto> listar();

    Producto obtenerPorId(int idProducto);

    List<Producto> buscarPorNombre(String termino);

    boolean registrar(Producto producto);

    boolean actualizar(Producto producto);

    boolean eliminar(int idProducto);
}
