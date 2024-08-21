class ParametrosModel{
  String? codigo;
  String? parametro;

  ParametrosModel({this.codigo, this.parametro});

  factory ParametrosModel.fromJson(Map<String, dynamic> json){
    return switch(json){
      {
        'Codigo': String? codigo,
        'Parametro': String? parametro,
      } =>
        ParametrosModel(
          codigo: codigo,
          parametro: parametro,
        ),
      _ => throw const FormatException('Error cargando códigos'),
    };
  }
}

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
  int? idSolicitud;
  String? folio;
  bool? muestraIngresada;
  bool? codigosGenerados;
  bool? siralab;
  String? descarga;
  String? cliente;
  String? empresa;
  String? fechaMuestreo;
  String? horaRecepcion;
  String? horaEntrada;
  int? idNorma;
  List<FoliosHijosModel>? puntosMuestreo;
  List<ParametrosModel>? parametros;

  InformacionAguaModel({required this.mensaje, this.idSolicitud, this.folio, this.muestraIngresada, this.codigosGenerados, this.siralab, this.descarga, this.cliente, this.empresa, this.fechaMuestreo, this.horaRecepcion, this.horaEntrada, this.idNorma, this.puntosMuestreo, this.parametros});

  factory InformacionAguaModel.fromJson(Map<String, dynamic> json){
    var lista = json['puntosMuestreo'] as List?;
    List<FoliosHijosModel>? puntosRespuesta = lista?.map((i) => FoliosHijosModel.fromJson(i)).toList();
    var listaParametros = json['parametros'] as List?;
    List<ParametrosModel>? parametrosRespuesta = listaParametros?.map((i) => ParametrosModel.fromJson(i)).toList();
    return switch(json) {
      {
        'mensaje': String mensaje,
        'idSolicitud': int? idSolicitud,
        'folio': String? folio,
        'muestraIngresada': bool? muestraIngresada,
        'codigosGenerados': bool? codigosGenerados,
        'siralab': bool? siralab,
        'descarga': String? descarga,
        'cliente': String? cliente,
        'empresa': String? empresa,
        'fechaMuestreo': String? fechaMuestreo,
        'horaRecepcion': String? horaRecepcion,
        'horaEntrada': String? horaEntrada,
        'idNorma': int? idNorma,
      } =>
        InformacionAguaModel(
          mensaje: mensaje,
          idSolicitud: idSolicitud,
          folio: folio,
          muestraIngresada: muestraIngresada,
          codigosGenerados: codigosGenerados,
          siralab: siralab,
          descarga: descarga,
          cliente: cliente,
          empresa: empresa,
          fechaMuestreo: fechaMuestreo,
          horaRecepcion: horaRecepcion,
          horaEntrada: horaEntrada,
          puntosMuestreo: puntosRespuesta,
          parametros: parametrosRespuesta,
          idNorma: idNorma,
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