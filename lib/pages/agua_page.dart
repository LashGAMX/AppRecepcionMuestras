import 'package:flutter/material.dart';
import 'package:recepcion_app/api/servicio_api.dart';

bool errorEncontrar = false;
String? folio;
String? descarga;
String? cliente;
String? empresa;
String? horaRecepcion;
String? horaEntrada;
String? fechaMuestreo;
String? fechaConformacion;
String? procedencia;

class AguaPage extends StatefulWidget{
  const AguaPage({super.key});

  @override
  State<AguaPage> createState() => _AguaPageState();
}

class _AguaPageState extends State<AguaPage>{
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controlerFolio = TextEditingController();
  ServicioAPI servicioAPI = ServicioAPI();

  @override
  void initState() {
    // TODO: implement initState
    errorEncontrar = false;
    folio = null;
    descarga = null;
    cliente = null;
    empresa = null;
    horaRecepcion = null;
    horaEntrada = null;
    fechaMuestreo = null;
    fechaConformacion = null;
    procedencia = null;
    super.initState();
  }

  getInformacionFolio(String folioMandado) async {
    servicioAPI.getInformacionFolioAgua(folioMandado).then((value) {
      if(value.mensaje == 'exito'){
        setState(() {
          errorEncontrar = false;
          folio = value.folio;
          descarga = value.descarga;
          cliente = value.cliente;
          empresa = value.empresa;
          horaRecepcion = value.horaRecepcion;
          horaEntrada = value.horaEntrada;
        });
      }
      else{
        setState(() {
          errorEncontrar = true;
          folio = null;
          descarga = null;
          cliente = null;
          empresa = null;
          horaRecepcion = null;
          horaEntrada = null;
          fechaMuestreo = null;
          fechaConformacion = null;
          procedencia = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey.shade200,
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
                    width: MediaQuery.of(context).size.width - 30,
                    child: Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: Row(
                            children: [
                              Flexible(
                                flex: 2,
                                child: TextFormField(
                                  controller: _controlerFolio,
                                  validator: (value){
                                    if(value == null || value.isEmpty){
                                      return 'Favor de introducir el folio';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10),), borderSide: BorderSide(color: (errorEncontrar == false)? Theme.of(context).colorScheme.primary : Colors.red),),
                                    focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10),), borderSide: BorderSide(color: (errorEncontrar == false)? Theme.of(context).colorScheme.primary : Colors.red, width: 2),),
                                    hintText: 'Folio',
                                    prefixIcon: Icon(Icons.dashboard, color: (errorEncontrar == false)? Theme.of(context).colorScheme.primary : Colors.red,),
                                  ),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.symmetric(horizontal: 5),),
                              Flexible(
                                fit: FlexFit.tight,
                                child: SizedBox(
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: (){
                                      if(_formKey.currentState!.validate()) {
                                        getInformacionFolio(_controlerFolio.text);
                                      }
                                      FocusManager.instance.primaryFocus?.unfocus();
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.resolveWith((states){
                                        if(states.contains(WidgetState.pressed)){
                                          return Theme.of(context).colorScheme.inversePrimary;
                                        }
                                        return Theme.of(context).colorScheme.primary;
                                      }),
                                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                        const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                        ),
                                      ),
                                      elevation: WidgetStateProperty.all<double>(8),
                                    ),
                                    child: const Text('Buscar', style: TextStyle(color: Colors.white),),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Column(
                              children: [
                                (errorEncontrar == true)? const SizedBox(height: 10,) : const SizedBox(height: 0,),
                                (errorEncontrar == true)? const Text('No se encontró el folio', style: TextStyle(color: Colors.red),) : const SizedBox(height: 0,),
                              ],
                            )
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
                  Text('Información', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
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
                                  const Text('Folio', style: TextStyle(fontWeight: FontWeight.w500),),
                                  Text((folio != null)? '$folio' : 'N/A', style: TextStyle(color: Colors.grey.shade500),),
                                ],
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(left: 8),),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Descarga', style: TextStyle(fontWeight: FontWeight.w500),),
                                  Text((descarga != null)? '$descarga' : 'N/A', style: TextStyle(color: Colors.grey.shade500),),
                                ],
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(left: 8),),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Cliente/Intermediario', style: TextStyle(fontWeight: FontWeight.w500),),
                                  Text((cliente != null)? '$cliente' : 'N/A', style: TextStyle(color: Colors.grey.shade500),),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Empresa', style: TextStyle(fontWeight: FontWeight.w500),),
                                  Text((empresa != null)? '$empresa' : 'N/A', style: TextStyle(color: Colors.grey.shade500),),
                                ],
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(left: 8),),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Hora recepción', style: TextStyle(fontWeight: FontWeight.w500),),
                                  Text((horaRecepcion != null)? '$horaRecepcion' : 'N/A', style: TextStyle(color: Colors.grey.shade500),),
                                  Text((horaEntrada != null)? '$horaEntrada' : 'N/A', style: TextStyle(color: Colors.grey.shade500),),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Fecha fin muestreo', style: TextStyle(fontWeight: FontWeight.w500),),
                                  Text('dd/mm/aaaa --:-- ----', style: TextStyle(color: Colors.grey.shade500),),
                                ],
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(left: 8),),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Fecha conformación', style: TextStyle(fontWeight: FontWeight.w500),),
                                  Text('dd/mm/aaaa --:-- ----', style: TextStyle(color: Colors.grey.shade500),),
                                ],
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(left: 8),),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Procedencia', style: TextStyle(fontWeight: FontWeight.w500),),
                                  Text('N/A', style: TextStyle(color: Colors.grey.shade500),),
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
                  Text('Parametros', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
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
                    width: MediaQuery.of(context).size.width - 30,
                    child: Column(
                      children: [
                        Row()
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