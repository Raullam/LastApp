import 'package:flutter/material.dart';
import 'package:flutter_loggin/models/usuari.dart';
import 'package:flutter_loggin/serveis/apiService.dart';

class UsuarisProvider extends ChangeNotifier {
  // Llista d'usuaris
  List<Usuari> usuaris = [];
  final ApiService apiService = ApiService();

  // Getter per a accedir a la llista d'usuaris
  List<Usuari> get getUsuaris => usuaris;

  // Carregar usuaris desde la API
  Future<void> fetchUsuaris() async {
    try {
      final usuariosData = await apiService.fetchUsuarios();

      // Mapejam les dades de la API al model Usuari
      usuaris =
          usuariosData.map((usuario) => Usuari.fromJson(usuario)).toList();
      notifyListeners();
    } catch (e) {
      throw Exception('Error al cargar usuarios: $e');
    }
  }

  Future<void> addUsuari(Usuari usuari) async {
    try {
      final nuevoUsuario = {
        'nom': usuari.nom,
        'correu': usuari.correu,
        'contrasenya': usuari.contrasenya,
        'edat': usuari.edat,
        'nacionalitat': usuari.nacionalitat,
        'codiPostal': usuari.codiPostal,
        'imatgePerfil': usuari.imatgePerfil,
      };

      // Ho registrem a la API
      await apiService.createUsuario(nuevoUsuario);

      await fetchUsuaris(); // Recarregar la lista desde la API
    } catch (e) {
      // Imprimir error desde la API o local
      print('Error al afegir un usuari: $e');
      throw Exception('Error al afegir un usuari: $e');
    }
  }

  // Eliminar un usuari per ID utilizant la API
  Future<void> removeUsuari(int id) async {
    try {
      await apiService.deleteUsuario(id);
      await fetchUsuaris(); // Recarregar la lista desde la API
    } catch (e) {
      throw Exception('Error al eliminar l\'usuari: $e');
    }
  }

  // Actualizar un usuari utilizant la API
  Future<void> updateUsuari(int id, Usuari usuariActualitzat) async {
    try {
      final usuarioActualizado = {
        'name': usuariActualitzat.nom,
        'email': usuariActualitzat.correu,
        'password': usuariActualitzat.contrasenya,
        'age': usuariActualitzat.edat,
        'nationality': usuariActualitzat.nacionalitat,
        'codi_postal': usuariActualitzat.codiPostal,
        'imatge_perfil': usuariActualitzat.imatgePerfil,
      };

      await apiService.updateUsuario(id, usuarioActualizado);
      await fetchUsuaris(); // Recarregar la llista desde la API
    } catch (e) {
      throw Exception('Error al actualizar l\'usuari: $e');
    }
  }

  Future<Usuari?> buscarUsuari(String correu, String contrasenya) async {
    try {
      // Aseguram que la lista d'usuaris es cargui abans de buscar
      await fetchUsuaris();

      // Buscar a la lista ja carregada
      final usuarioEncontrado = usuaris.firstWhere(
        (u) => u.correu == correu && u.contrasenya == contrasenya,
      );

      print('Usuario encontrado: ${usuarioEncontrado.toJson()}');

      return usuarioEncontrado;
    } catch (e) {
      print(
          'No se encontró ningún usuario con el correo $correu y contraseña proporcionada.');
      return null;
    }
  }

  // Nuevo método: Buscar usuario por correo
  Future<Usuari?> buscarUsuariPerCorreu(String correu) async {
    try {
      // Asegúrate de que la lista de usuarios esté cargada antes de buscar
      await fetchUsuaris();

      // Buscar el usuario por correo
      final usuarioEncontrado = usuaris.firstWhere((u) => u.correu == correu,
          orElse: () => null as Usuari);

      if (usuarioEncontrado != null) {
        print(
            'Usuario encontrado con correo $correu: ${usuarioEncontrado.toJson()}');
      } else {
        print('No se encontró ningún usuario con el correo $correu.');
      }

      return usuarioEncontrado;
    } catch (e) {
      print('Error al buscar usuario por correo: $e');
      return null;
    }
  }
}
