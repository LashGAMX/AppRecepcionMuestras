import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recepcion_app/api/servicio_api.dart';
import 'package:recepcion_app/models/informacion_agua_model.dart';
import 'package:recepcion_app/models/punto_agua_model.dart';

List<PuntoAguaModel>? listaImagenes;
int? opcionCloruros;
String? fechaFinMuestreo;
String? fechaConformacion;
String? procedencia;
bool cargando = false;

class PuntoMuestreoPage extends StatefulWidget{
  final FoliosHijosModel puntoMuestreo;
  final bool muestraIngresada;
  final bool codigosGenerados;

  const PuntoMuestreoPage({super.key, required this.puntoMuestreo, required this.muestraIngresada, required this.codigosGenerados});

  @override
  State<PuntoMuestreoPage> createState() => _PuntoMuestreoPageState();
}

class _PuntoMuestreoPageState extends State<PuntoMuestreoPage>{
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController _conductividadController;
  List<Opciones> opciones = Opciones.todasOpciones;
  List<DropdownMenuItem<Opciones>>? _opciones;
  Opciones? _elegida;
  ServicioAPI servicioAPI = ServicioAPI();

  @override
  void initState() {
    // TODO: implement initState
    listaImagenes = null;
    fechaFinMuestreo = null;
    fechaConformacion = null;
    procedencia = null;
    cargando = false;
    _opciones = opciones.map<DropdownMenuItem<Opciones>>(
        (Opciones opcion){
          return DropdownMenuItem<Opciones>(
            value: opcion,
            child: Text(opcion.texto!),
          );
        }
    ).toList();
    switch(widget.puntoMuestreo.cloruros){
      case 499:
        opcionCloruros = 1;
        break;
      case 500:
        opcionCloruros = 2;
        break;
      case 1000:
        opcionCloruros = 3;
        break;
      case 1500:
        opcionCloruros = 4;
        break;
      default:
        opcionCloruros = 0;
        break;
    }
    _elegida = opciones[opcionCloruros!];
    _conductividadController = TextEditingController(text: widget.puntoMuestreo.conductividad?.toString());
    getDatosPunto(widget.puntoMuestreo.idFolio!);
    getFotosPunto(widget.puntoMuestreo.idFolio!);
    super.initState();
  }

  // @override
  // void dispose() {
  //   _conductividadController.dispose();
  //   _clorurosController.dispose();
  //   super.dispose();
  // }

  getDatosPunto(int idSolicitud) async {
    servicioAPI.getDatosPunto(idSolicitud).then((value) {
      if(value != null) {
        setState(() {
          fechaFinMuestreo = value.fechaFinMuestreo;
          fechaConformacion = value.fechaConformacion;
          procedencia = value.procedencia;
        });
      }
      else {
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al obtener los datos del punto de muestreo')));
        }
      }
    });
  }

  getFotosPunto(int idSolicitud) async {
    setState(() {
      cargando = true;
      listaImagenes = [];
    });
    servicioAPI.getImagenesPunto(idSolicitud).then((value) {
      if(value is String){
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Algo salió mal al obtener las imágenes del punto. Intentar otra vez')));
        }
      }
      else {
        setState(() {
          // listaImagenes = value;
          if (value != null) {
            for (var elemento in value) {
              listaImagenes?.add(elemento);
            }
          }
          cargando = false;
        });
      }
    });
  }

  Future _tomarFotoDeCamara() async {
    final rutaImagenTomada = await ImagePicker().pickImage(source: ImageSource.camera);

    if(rutaImagenTomada == null){
      return;
    }
    File imagenTomada = File(rutaImagenTomada.path);
    String imagenBase64 = base64Encode(imagenTomada.readAsBytesSync());
    setState(() {
      listaImagenes ??= [];

      cargando = true;
      // listaImagenes!.add(File(imagenTomada.path));
    });
    servicioAPI.setImagenPunto(widget.puntoMuestreo.idFolio!, imagenBase64).then((value) {
      if(value != null){
        setState(() {
          listaImagenes!.add(PuntoAguaModel(foto: imagenBase64));
        });
      }
      else{
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Algo salió mal al subir la foto')));
        }
      }
      setState(() {
        cargando = false;
      });
    });
  }

  Future _elegirFotoDeBiblioteca() async {
    final rutaImagenElegida = await ImagePicker().pickImage(source: ImageSource.gallery);

    if(rutaImagenElegida == null){
      return;
    }
    File imagenElegida = File(rutaImagenElegida.path);
    String imagenBase64 = base64Encode(imagenElegida.readAsBytesSync());
    setState(() {
      listaImagenes ??= [];

      cargando = true;
      // listaImagenes!.add(File(imagenElegida.path));
      // _imagenMostrada = File(imagenElegida.path);
    });
    servicioAPI.setImagenPunto(widget.puntoMuestreo.idFolio!, imagenBase64).then((value) {
      if(value != null){
        setState(() {
          listaImagenes!.add(PuntoAguaModel(foto: imagenBase64));
        });
      }
      else{
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Algo salió mal al subir la foto')));
        }
      }
      setState(() {
        cargando = false;
      });
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10,),
              Row(
                children: [
                  const Padding(padding: EdgeInsets.only(left: 10),),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        // print(widget.puntoMuestreo.conductividad);
                        widget.puntoMuestreo.conductividad = int.tryParse(_conductividadController.text);
                      });
                      Navigator.pop(context, widget.puntoMuestreo);
                    },
                    child: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary, size: 30,),
                  ),
                ],
              ),
              const SizedBox(height: 15,),
              const Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 15),),
                  Text('Información del punto', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15),),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    width: MediaQuery.sizeOf(context).width - 30,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Solicitud', style: TextStyle(fontWeight: FontWeight.w500),),
                                  Text('${widget.puntoMuestreo.idFolio}', style: TextStyle(color: Colors.grey.shade500), softWrap: true,),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Punto', style: TextStyle(fontWeight: FontWeight.w500),),
                                  Text('${widget.puntoMuestreo.punto}', style: TextStyle(color: Colors.grey.shade500), softWrap: true,),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8,),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  const Text('Fecha fin muestreo', style: TextStyle(fontWeight: FontWeight.w500), softWrap: true,),
                                  Text(fechaFinMuestreo ?? 'N/A', style: TextStyle(color: Colors.grey.shade500), softWrap: true,),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const Text('Fecha de conformación', style: TextStyle(fontWeight: FontWeight.w500), softWrap: true,),
                                  Text(fechaConformacion ?? 'N/A', style: TextStyle(color: Colors.grey.shade500), softWrap: true,),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const Text('Procedencia', style: TextStyle(fontWeight: FontWeight.w500), softWrap: true,),
                                  Text(procedencia ?? 'N/A', style: TextStyle(color: Colors.grey.shade500), softWrap: true,),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8,),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Conductividad', style: TextStyle(fontWeight: FontWeight.w500), softWrap: true,),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _conductividadController,
                                          enabled: (widget.codigosGenerados == false)? true : false,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            // border: const OutlineInputBorder(),
                                            hintText: (widget.puntoMuestreo.conductividad == null)? 'Sin conductividad' : 'Conductividad',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Padding(padding: EdgeInsets.symmetric(horizontal: 10),),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Cloruros', style: TextStyle(fontWeight: FontWeight.w500), softWrap: true,),
                                  DropdownButton<Opciones>(
                                    isExpanded: true,
                                    underline: const SizedBox(),
                                    value: _elegida,
                                    items: _opciones,
                                    onChanged: (widget.codigosGenerados == false)? (valor) {
                                      setState(() {
                                        _elegida = valor;
                                        widget.puntoMuestreo.cloruros = valor!.valor;
                                      });
                                    } : null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15,),
              const Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 15),),
                  Text('Imágenes del punto', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                ],
              ),
              Row(
                children: [
                  const Padding(padding: EdgeInsets.only(left: 10),),
                  IconButton(
                    onPressed: (){
                      _tomarFotoDeCamara();
                    },
                    icon: Icon(Icons.camera_alt_outlined, color: Theme.of(context).colorScheme.primary,),
                  ),
                  IconButton(
                    onPressed: (){
                      _elegirFotoDeBiblioteca();
                    },
                    icon: Icon(Icons.image_outlined, color: Theme.of(context).colorScheme.primary,),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15),),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    width: MediaQuery.sizeOf(context).width - 30,
                    child: Column(
                      children: [
                        (cargando == false) ?
                          (listaImagenes != null && listaImagenes!.isNotEmpty) ?
                            SizedBox(
                              height: 130,
                              child: GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 1.0,
                                  mainAxisSpacing: 8.0,
                                ),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: listaImagenes!.length,
                                itemBuilder: (context, index){
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    child: GestureDetector(
                                      onTap: (){
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: Hero(
                                                tag: 'Imagen',
                                                child: Image(image: MemoryImage(base64Decode(listaImagenes![index].foto!)), fit: BoxFit.fitWidth,),
                                              ),
                                            );
                                          }
                                        );
                                      },
                                      child: Center(
                                        child: Image.memory(base64Decode(listaImagenes![index].foto!), fit: BoxFit.fitWidth, ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                              :
                            const Text('Este punto de muestreo no tiene imágenes', softWrap: true,)
                            :
                          const CircularProgressIndicator()
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget obtenerCloruros(int? cloruros){
    switch(cloruros){
      case 499:
        return Text('< 500', style: TextStyle(color: Colors.grey.shade500), softWrap: true,);
      case 500:
        return Text('500', style: TextStyle(color: Colors.grey.shade500), softWrap: true,);
      case 1000:
        return Text('1000', style: TextStyle(color: Colors.grey.shade500), softWrap: true,);
      case 1500:
        return Text('1000', style: TextStyle(color: Colors.grey.shade500), softWrap: true,);
      default:
        return Text('Sin cloruros', style: TextStyle(color: Colors.grey.shade500), softWrap: true,);
    }
  }
}

class Opciones {
  int? valor;
  String? texto;

  Opciones({this.valor, this.texto});

  static List<Opciones> get todasOpciones => [
    Opciones(valor: null, texto: 'Sin cloruros'),
    Opciones(valor: 499, texto: '< 500'),
    Opciones(valor: 500, texto: '500'),
    Opciones(valor: 1000, texto: '1000'),
    Opciones(valor: 1500, texto: '>1000'),
  ];
}