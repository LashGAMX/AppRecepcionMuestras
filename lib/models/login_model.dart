class LoginResponseModel {
  String estado = '';
  String mensaje;
  int idUsuario;
  String avatar;

  LoginResponseModel({required this.estado,required this.mensaje, required this.idUsuario, required this.avatar});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json){
    return switch (json) {
      {
        'estado': String estado,
        'mensaje': String mensaje,
        'idUsuario': int idUsuario,
        'avatar': String avatar,
      } =>
        LoginResponseModel(
          estado: estado,
          mensaje: mensaje,
          idUsuario: idUsuario,
          avatar: avatar,
        ),
      _ => throw const FormatException('Error al cargar el modelo de respuesta'),
    };
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> map = {
      'estado': estado.trim(),
      'mensaje': mensaje.trim(),
      'idUsuario': idUsuario,
      'avatar': avatar.trim(),
    };

    return map;
  }
}

class LoginRequestModel {
  final String usuario;
  final String contrasena;

  const LoginRequestModel({required this.usuario, required this.contrasena});

  factory LoginRequestModel.fromJson(Map<String, dynamic> json){
    return switch (json) {
      {
        'usuario': String usuario,
        'contrasena': String contrasena,
      } =>
        LoginRequestModel(
          usuario: usuario,
          contrasena: contrasena,
        ),
      _ => throw const FormatException('Error al cargar el modelo de login'),
    };
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> map = {
      'usuario': usuario.trim(),
      'contrasena': contrasena.trim(),
    };

    return map;
  }
}