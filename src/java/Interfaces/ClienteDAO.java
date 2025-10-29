package Interfaces;

import Modelo.Cliente;
import java.util.List;

public interface ClienteDAO {
    List<Cliente> listar();

    Cliente obtenerPorId(int idCliente);

    boolean registrar(Cliente cliente);

    boolean actualizar(Cliente cliente);
}
