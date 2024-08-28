import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:recepcion_app/models/login_model.dart';
import 'package:recepcion_app/models/punto_agua_model.dart';
import 'package:recepcion_app/models/user_model.dart';
import 'package:recepcion_app/models/informacion_agua_model.dart';

const String urlBase = 'http://sistemasofia.ddns.net:85/sofiadev/api/recepcionApp/';

class ServicioAPI {
  Future<LoginResponseModel> login(LoginRequestModel loginRequestModel) async {
    final response = await http.post(
      Uri.parse('${urlBase}login'),
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'usuario': loginRequestModel.usuario,
        'contrasena': loginRequestModel.contrasena,
      }),
    );

    if(response.statusCode == 200 || response.statusCode == 400 || response.statusCode == 404 || response.statusCode == 419 || response.statusCode == 500){
      // print(response.body);
      return LoginResponseModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    else{
      throw Exception('Error');
    }
  }

  Future<UserModel> getUser(int idUser) async {
    final response = await http.post(
      Uri.parse('${urlBase}getUser'),
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        'idUser': idUser,
      }),
    );

    if(response.statusCode == 200 || response.statusCode == 400 || response.statusCode == 404 || response.statusCode == 419 || response.statusCode == 500){
      return UserModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    else{
      throw Exception('Error');
    }
  }

  Future<InformacionAguaModel?> getInformacionFolioAgua(String folioMandado) async {
    const maximosIntentos = 3;
    var intentos = 0;
    while(true) {
      try {
        final response = await http.post(
          Uri.parse('${urlBase}getInformacionFolioAgua'),
          headers: <String, String>{
            'Content-type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'folio': folioMandado,
          }),
        );

        if (response.statusCode == 200 || response.statusCode == 400 || response.statusCode == 404 || response.statusCode == 419 || response.statusCode == 500) {
          return InformacionAguaModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
        }
        else {
          throw Exception('Error al regresar información del folio');
        }
      } catch (e) {
        intentos++;
        if (intentos > maximosIntentos) {
          return null;
        }
        else {
          await Future.delayed(const Duration(seconds: 2));
        }
      }
    }
  }

  Future<dynamic> getParametros(String folioMandado) async {
    const maximosIntentos = 3;
    var intentos = 0;
    while(true) {
      try {
        final response = await http.post(
          Uri.parse('${urlBase}getParametros'),
          headers: <String, String>{
            'Content-type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, dynamic>{
            'folio': folioMandado,
          }),
        );

        if (response.statusCode == 200 || response.statusCode == 400 || response.statusCode == 404 || response.statusCode == 419 || response.statusCode == 500) {
          var respuesta = jsonDecode(response.body) as Map<String, dynamic>;
          var lista = respuesta['parametros'] as List?;
          List<ParametrosModel>? listaParametros = lista?.map((i) => ParametrosModel.fromJson(i)).toList();

          return listaParametros;
        }
        else {
          throw Exception('Error al regresar parametros');
        }
      } catch (e) {
        intentos++;
        if(intentos > maximosIntentos){
          return "Error";
        }
        else{
          await Future.delayed(const Duration(seconds: 2));
        }
      }
    }
  }

  Future<bool?> upHoraRecepcion(String folio, int tipoHora, String hora) async {
    const maximosIntentos = 3;
    var intentos = 0;
    while(true) {
      try {
        final response = await http.post(
          Uri.parse('${urlBase}upHoraRecepcion'),
          headers: <String, String>{
            'Content-type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'folio': folio,
            'tipoHora': tipoHora,
            'hora': hora,
          }),
        );

        if (response.statusCode == 200 || response.statusCode == 400 || response.statusCode == 404 || response.statusCode == 419 || response.statusCode == 500) {
          return true;
        }
        else {
          throw Exception('Error al cambiar la hora');
        }
      } catch (e) {
        intentos++;
        if (intentos > maximosIntentos) {
          return null;
        }
        else {
          await Future.delayed(const Duration(seconds: 2));
        }
      }
    }
  }

  Future<bool?> upFechaEmision(String folio, String fechaEmision) async {
    const maximosIntentos = 3;
    var intentos = 0;
    while(true) {
      try {
        final response = await http.post(
          Uri.parse('${urlBase}upFechaEmision'),
          headers: <String, String>{
            'Content-type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'folio': folio,
            'fechaEmision': fechaEmision,
          }),
        );

        if (response.statusCode == 200 || response.statusCode == 400 ||
            response.statusCode == 404 || response.statusCode == 419 ||
            response.statusCode == 500) {
          return true;
        }
        else {
          throw Exception('Error al cambiar la hora');
        }
      } catch(e) {
        intentos++;
        if(intentos > maximosIntentos){
          return null;
        }
        else{
          await Future.delayed(const Duration(seconds: 2));
        }
      }
    }
  }

  Future<bool?> setImagenPunto(int idSolicitud, String foto) async {
    const maximosIntentos = 3;
    var intentos = 0;
    while(true) {
      try {
        final response = await http.post(
          Uri.parse('${urlBase}setImagenPunto'),
          headers: <String, String>{
            'Content-type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, dynamic>{
            'idSolicitud': idSolicitud,
            'foto': foto,
          }),
        );

        if (response.statusCode == 200 || response.statusCode == 400 || response.statusCode == 404 || response.statusCode == 419 || response.statusCode == 500) {
          return true;
        }
        else {
          throw Exception('Error al subir la foto');
        }
      } catch (e) {
        intentos++;
        if(intentos > maximosIntentos){
          return null;
        }
        else{
          await Future.delayed(const Duration(seconds: 2));
        }
      }
    }
  }

  Future<dynamic> getImagenesPunto(int idSolicitud) async {
    const maximosIntentos = 3;
    var intentos = 0;
    while(true) {
      try {
        final response = await http.post(
          Uri.parse('${urlBase}getImagenesPunto'),
          headers: <String, String>{
            'Content-type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, dynamic>{
            'idSolicitud': idSolicitud,
          }),
        );

        if (response.statusCode == 200 || response.statusCode == 400 || response.statusCode == 404 || response.statusCode == 419 || response.statusCode == 500) {
          var respuesta = jsonDecode(response.body) as Map<String, dynamic>;
          var lista = respuesta['model'] as List?;
          List<PuntoAguaModel>? listaPuntos = lista?.map((i) =>
              PuntoAguaModel.fromJson(i)).toList();

          return listaPuntos;
        }
        else {
          throw Exception('Error al subir la foto');
        }
      } catch (e) {
        intentos++;
        if(intentos > maximosIntentos){
          return "Error";
        }
        else{
          await Future.delayed(const Duration(seconds: 2));
        }
      }
    }
  }

  Future<DetallesPunto?> getDatosPunto(int idSolicitud) async {
    const maximosIntentos = 3;
    var intentos = 0;
    while(true) {
      try {
        final response = await http.post(
          Uri.parse('${urlBase}getDatosPunto'),
          headers: <String, String>{
            'Content-type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, dynamic>{
            'idSolicitud': idSolicitud,
          }),
        );

        if (response.statusCode == 200 || response.statusCode == 400 ||
            response.statusCode == 404 || response.statusCode == 419 ||
            response.statusCode == 500) {
          return DetallesPunto.fromJson(
              jsonDecode(response.body) as Map<String, dynamic>);
        }
        else {
          throw Exception('Error al mostrar datos');
        }
      } catch (e) {
        intentos++;
        if(intentos > maximosIntentos){
          return null;
        }
        else{
          await Future.delayed(const Duration(seconds: 2));
        }
      }
    }
  }
  
  Future<String> setCodigos(int idSolicitud, bool condiciones, List<int?> conductividad, List<int?> cloruros) async {
    final response = await http.post(
      Uri.parse('${urlBase}setGenFolio'),
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, dynamic>{
        'id': idSolicitud,
        'condiciones': condiciones,
        'conductividad': conductividad,
        'cloruros': cloruros,
      }),
    );

    if(response.statusCode == 200 || response.statusCode == 400 || response.statusCode == 404 || response.statusCode == 419 || response.statusCode == 500) {
      var respuesta = jsonDecode(response.body) as Map<String, dynamic>;

      return respuesta['msg'] as String;
    }
    else {
      throw Exception('Error al mostrar datos');
    }
  }

  Future<List<String>> setIngresar(int idSolicitud, String folio, String descarga, String cliente, String empresa, String horaRecepcion, String horaEntrada, bool historial, int idUsuario) async {
    final response = await http.post(
      Uri.parse('${urlBase}setIngresar'),
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, dynamic>{
        'idSol': idSolicitud,
        'folio': folio,
        'descarga': descarga,
        'cliente': cliente,
        'empresa': empresa,
        'ingreso': 'Establecido',
        'horaRecepcion': horaRecepcion,
        'horaEntrada': horaEntrada,
        'historial': historial,
        'idUsuario': idUsuario,
      }),
    );

    if(response.statusCode == 200 || response.statusCode == 400 || response.statusCode == 404 || response.statusCode == 419 || response.statusCode == 500) {
      var respuesta = jsonDecode(response.body) as Map<String, dynamic>;
      List<String> respuestaDevuelta = [respuesta["msg"], respuesta["fechaEmision"]];

      return respuestaDevuelta;
    }
    else {
      throw Exception('Error al ingresar muestra');
    }
  }
}