import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:recepcion_app/models/login_model.dart';
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

  Future<InformacionAguaModel> getInformacionFolioAgua(String folioMandado) async {
    final response = await http.post(
      Uri.parse('${urlBase}getInformacionFolioAgua'),
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'folio': folioMandado,
      }),
    );

    if(response.statusCode == 200 || response.statusCode == 400 || response.statusCode == 404 || response.statusCode == 419 || response.statusCode == 500){
      return InformacionAguaModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    else{
      throw Exception('Error al regresar información del folio');
    }
  }

  Future<bool> upHoraRecepcion(String folio, int tipoHora, String hora) async {
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

    print(response.statusCode);
    if(response.statusCode == 200 || response.statusCode == 400 || response.statusCode == 404 || response.statusCode == 419 || response.statusCode == 500){
      return true;
    }
    else{
      throw Exception('Error al cambiar la hora');
    }
  }
}