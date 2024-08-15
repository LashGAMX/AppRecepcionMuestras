class DetallesPunto {
  String? fechaFinMuestreo;
  String? fechaConformacion;
  String? procedencia;

  DetallesPunto({this.fechaFinMuestreo, this.fechaConformacion, this.procedencia});

  factory DetallesPunto.fromJson(Map<String, dynamic> json){
    return switch(json){
      {
        'fechaFinMuestreo': String? fechaFinMuestreo,
        'fechaConformacion': String? fechaConformacion,
        'procedencia': String? procedencia,
      } =>
        DetallesPunto(
          fechaFinMuestreo: fechaFinMuestreo,
          fechaConformacion: fechaConformacion,
          procedencia: procedencia,
        ),
      _ => throw const FormatException('Error cargando datos'),
    };
  }
}

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