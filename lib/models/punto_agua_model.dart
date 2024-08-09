class PuntoAguaModel {
  int? idFotoRecepcion;
  int? idSolicitud;
  String? foto;

  PuntoAguaModel({this.idFotoRecepcion, this.idSolicitud, this.foto});

  factory PuntoAguaModel.fromJson(Map<String, dynamic> json){
    return switch(json){
      {
        'Id_foto_recepcion': int? idFotoRecepcion,
        'Id_solicitud': int? idSolicitud,
        'Foto': String? foto,
      } =>
        PuntoAguaModel(
          idFotoRecepcion: idFotoRecepcion,
          idSolicitud: idSolicitud,
          foto: foto,
        ),
      _ => throw const FormatException('Error cargando fotos'),
    };
  }
}