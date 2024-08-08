import 'package:flutter/material.dart';
import 'package:recepcion_app/models/informacion_agua_model.dart';

List<String>? listaImagenes;

class PuntoMuestreoPage extends StatefulWidget{
  final FoliosHijosModel puntoMuestreo;

  const PuntoMuestreoPage({super.key, required this.puntoMuestreo});

  @override
  State<PuntoMuestreoPage> createState() => _PuntoMuestreoPageState();
}

class _PuntoMuestreoPageState extends State<PuntoMuestreoPage>{
  final scaffoldKey = GlobalKey<ScaffoldState>();

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
                    onPressed: (){},
                    icon: Icon(Icons.camera_alt_outlined, color: Theme.of(context).colorScheme.primary,),
                  ),
                  IconButton(
                    onPressed: (){},
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
                        (listaImagenes != null) ?
                        SizedBox()
                          :
                        const Text('Este punto de muestreo no tiene imágenes', softWrap: true,)
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
}