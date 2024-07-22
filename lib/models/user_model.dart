class UserModel {
  String user;
  String nombre;
  String iniciales;

  UserModel({required this.user,required this.nombre,required this.iniciales});

  factory UserModel.fromJson(Map<String, dynamic> json){
    return switch(json) {
      {
        'user': String user,
        'nombre': String nombre,
        'iniciales': String iniciales,
      } =>
        UserModel(
          user: user,
          nombre: nombre,
          iniciales: iniciales,
        ),
      _ => throw const FormatException('Error al cargar el usuario'),
    };
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> map = {
      'user': user.trim(),
      'nombre': nombre.trim(),
      'iniciales': iniciales.trim(),
    };

    return map;
  }
}
