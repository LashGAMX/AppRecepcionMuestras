class InformacionAguaModel {
  String mensaje;
  String? folio;
  String? descarga;
  String? cliente;
  String? empresa;
  String? horaRecepcion;
  String? horaEntrada;

  InformacionAguaModel({required this.mensaje, this.folio, this.descarga, this.cliente, this.empresa, this.horaRecepcion, this.horaEntrada});

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
      } =>
        InformacionAguaModel(
          mensaje: mensaje,
          folio: folio,
          descarga: descarga,
          cliente: cliente,
          empresa: empresa,
          horaRecepcion: horaRecepcion,
          horaEntrada: horaEntrada,
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