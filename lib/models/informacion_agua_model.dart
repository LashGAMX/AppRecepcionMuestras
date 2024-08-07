class FoliosHijosModel{
  int? idFolio;
  String? punto;
  int? conductividad;
  int? cloruros;

  FoliosHijosModel({this.idFolio, this.punto, this.conductividad, this.cloruros});

  factory FoliosHijosModel.fromJson(Map<String, dynamic> json){
    return switch(json){
      {
        'idFolio': int idFolio,
        'punto': String punto,
        'conductividad': int? conductividad,
        'cloruros': int? cloruros,
      } =>
        FoliosHijosModel(
          idFolio: idFolio,
          punto: punto,
          conductividad: conductividad,
          cloruros: cloruros,
        ),
      _ => throw const FormatException('Error cargando información'),
    };
  }
}

class InformacionAguaModel {
  String mensaje;
  String? folio;
  bool? muestraIngresada;
  String? descarga;
  String? cliente;
  String? empresa;
  String? fechaMuestreo;
  String? horaRecepcion;
  String? horaEntrada;
  List<FoliosHijosModel>? puntosMuestreo;

  InformacionAguaModel({required this.mensaje, this.folio, this.muestraIngresada, this.descarga, this.cliente, this.empresa, this.fechaMuestreo, this.horaRecepcion, this.horaEntrada, this.puntosMuestreo});

  factory InformacionAguaModel.fromJson(Map<String, dynamic> json){
    var lista = json['puntosMuestreo'] as List?;
    List<FoliosHijosModel>? puntosRespuesta = lista?.map((i) => FoliosHijosModel.fromJson(i)).toList();
    return switch(json) {
      {
        'mensaje': String mensaje,
        'folio': String? folio,
        'muestraIngresada': bool? muestraIngresada,
        'descarga': String? descarga,
        'cliente': String? cliente,
        'empresa': String? empresa,
        'fechaMuestreo': String? fechaMuestreo,
        'horaRecepcion': String? horaRecepcion,
        'horaEntrada': String? horaEntrada,
      } =>
        InformacionAguaModel(
          mensaje: mensaje,
          folio: folio,
          muestraIngresada: muestraIngresada,
          descarga: descarga,
          cliente: cliente,
          empresa: empresa,
          fechaMuestreo: fechaMuestreo,
          horaRecepcion: horaRecepcion,
          horaEntrada: horaEntrada,
          puntosMuestreo: puntosRespuesta,
        ),
      _ => throw const FormatException('Error al cargar informacion'),
    };
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> map = {
      'mensaje': mensaje.trim(),
      'folio': folio!.trim(),
      'descarga': descarga!.trim(),
      'cliente': cliente!.trim(),
      'empresa': empresa!.trim(),
      'horaRecepcion': horaRecepcion!.trim(),
      'horaEntrada': horaEntrada!.trim(),
    };

    return map;
  }
}