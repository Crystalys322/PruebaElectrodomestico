package Interfaces;

import Modelo.DetalleVenta;
import Modelo.Venta;
import java.util.List;

public interface VentaDAO {
    boolean registrarVenta(Venta venta, List<DetalleVenta> detalles);

    Venta obtenerPorId(int idVenta);
}
