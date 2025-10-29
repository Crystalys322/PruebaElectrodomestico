package Interfaces;

import Modelo.Usuario;

public interface UsuarioDAO {
    Usuario validarAcceso(String usuario, String clave);
}
