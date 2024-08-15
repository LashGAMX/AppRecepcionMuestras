import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recepcion_app/api/servicio_api.dart';
import 'package:recepcion_app/models/informacion_agua_model.dart';
import 'package:recepcion_app/models/punto_agua_model.dart';

List<PuntoAguaModel>? listaImagenes;
String? fechaFinMuestreo;
String? fechaConformacion;
String? procedencia;
bool cargando = false;

class PuntoMuestreoPage extends StatefulWidget{
  final FoliosHijosModel puntoMuestreo;

  const PuntoMuestreoPage({super.key, required this.puntoMuestreo});

  @override
  State<PuntoMuestreoPage> createState() => _PuntoMuestreoPageState();
}

class _PuntoMuestreoPageState extends State<PuntoMuestreoPage>{
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ServicioAPI servicioAPI = ServicioAPI();

  @override
  void initState() {
    // TODO: implement initState
    listaImagenes = null;
    fechaFinMuestreo = null;
    fechaConformacion = null;
    procedencia = null;
    cargando = false;
    getDatosPunto(widget.puntoMuestreo.idFolio!);
    getFotosPunto(widget.puntoMuestreo.idFolio!);
    super.initState();
  }

  getDatosPunto(int idSolicitud) async {
    servicioAPI.getDatosPunto(idSolicitud).then((value) {
      setState(() {
        fechaFinMuestreo = value.fechaFinMuestreo;
        fechaConformacion = value.fechaConformacion;
        procedencia = value.procedencia;
      });
    });
  }

  getFotosPunto(int idSolicitud) async {
    setState(() {
      cargando = true;
    });
    servicioAPI.getImagenesPunto(idSolicitud).then((value) {
      setState(() {
        listaImagenes = value;
        cargando = false;
      });
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

      listaImagenes!.add(PuntoAguaModel(foto: imagenBase64));
      cargando = true;
      // listaImagenes!.add(File(imagenTomada.path));
    });
    servicioAPI.setImagenPunto(widget.puntoMuestreo.idFolio!, imagenBase64).then((value) {
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

      listaImagenes!.add(PuntoAguaModel(foto: imagenBase64));
      cargando = true;
      // listaImagenes!.add(File(imagenElegida.path));
      // _imagenMostrada = File(imagenElegida.path);
    });
    servicioAPI.setImagenPunto(widget.puntoMuestreo.idFolio!, imagenBase64).then((value) {
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
                      Navigator.pop(context);
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
                                        flex: 3,
                                        child: Text('${widget.puntoMuestreo.conductividad ?? 'Sin conductividad'}', style: TextStyle(color: Colors.grey.shade500), softWrap: true,),
                                      ),
                                      Expanded(
                                        child: IconButton(
                                          onPressed: (){},
                                          icon: Icon(Icons.edit, size: 20, color: Theme.of(context).colorScheme.primary,),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Cloruros', style: TextStyle(fontWeight: FontWeight.w500), softWrap: true,),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: obtenerCloruros(widget.puntoMuestreo.cloruros),
                                      ),
                                      Expanded(
                                        child: IconButton(
                                          onPressed: (){},
                                          icon: Icon(Icons.edit, size: 20, color: Theme.of(context).colorScheme.primary,),
                                        ),
                                      ),
                                    ],
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