class FoliosHijosModel{
  String? idFolio;
  String? punto;
  String? conductividad;
  String? cloruros;

  FoliosHijosModel({this.idFolio, this.punto, this.conductividad, this.cloruros});

  factory FoliosHijosModel.fromJson(Map<String, dynamic> json){
    return switch(json){
      {
        'idFolio': String idFolio,
        'punto': String punto,
        'conductividad': String conductividad,
        'cloruros': String cloruros,
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
  String? descarga;
  String? cliente;
  String? empresa;
  String? horaRecepcion;
  String? horaEntrada;
  List<FoliosHijosModel>? puntosMuestreo;

  InformacionAguaModel({required this.mensaje, this.folio, this.descarga, this.cliente, this.empresa, this.horaRecepcion, this.horaEntrada, this.puntosMuestreo});

  factory InformacionAguaModel.fromJson(Map<String, dynamic> json){
    return switch(json) {
      {
        'mensaje': String mensaje,
        'folio': String? folio,
        'descarga': String? descarga,
        'cliente': String? cliente,
        'empresa': String? empresa,
        'horaRecepcion': String? horaRecepcion,
        'horaEntrada': String? horaEntrada,
        'puntosMuestreo': List<FoliosHijosModel>? puntosMuestreo,
      } =>
        InformacionAguaModel(
          mensaje: mensaje,
          folio: folio,
          descarga: descarga,
          cliente: cliente,
          empresa: empresa,
          horaRecepcion: horaRecepcion,
          horaEntrada: horaEntrada,
          puntosMuestreo: puntosMuestreo,
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