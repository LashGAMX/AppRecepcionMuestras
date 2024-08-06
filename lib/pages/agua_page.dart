import 'package:flutter/material.dart';
import 'package:recepcion_app/api/servicio_api.dart';
import 'package:recepcion_app/models/informacion_agua_model.dart';
import 'package:recepcion_app/pages/punto_muestreo_page.dart';

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
String? parametrosGenerados;
List<FoliosHijosModel>? foliosHijos;
bool? folioEncontrado;

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
    parametrosGenerados = null;
    foliosHijos = null;
    folioEncontrado = false;
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
          foliosHijos = value.puntosMuestreo;
          folioEncontrado = true;
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
          foliosHijos = null;
        });
      }
    });
  }

  upHoraRecepcion(String folio, int tipoHora, String hora) async {
    servicioAPI.upHoraRecepcion(folio, tipoHora, hora);
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
                                  Row(
                                    children: [
                                      // Text((horaRecepcion != null)? '$horaRecepcion' : 'N/A', style: TextStyle(color: Colors.grey.shade500),),
                                      Expanded(
                                        flex: 9,
                                        child: Text((horaRecepcion != null)? '$horaRecepcion' : 'N/A', style: TextStyle(color: Colors.grey.shade500),),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: (folioEncontrado != false)? (){
                                            showDatePicker(
                                              context: context,
                                              initialDate: DateTime.parse('$horaRecepcion'),
                                              firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
                                              lastDate: DateTime.now(),
                                            ).then((diaSeleccionado) {
                                              if(diaSeleccionado != null){
                                                showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.fromDateTime(DateTime.parse('$horaRecepcion')),
                                                ).then((horaSeleccionada) {
                                                  if(horaSeleccionada != null) {
                                                    DateTime fechaSeleccionada = DateTime(
                                                      diaSeleccionado.year,
                                                      diaSeleccionado.month,
                                                      diaSeleccionado.day,
                                                      horaSeleccionada.hour,
                                                      horaSeleccionada.minute,
                                                    );
                                                    String fechaConvertida = '${fechaSeleccionada.year.toString()}-${fechaSeleccionada.month.toString().padLeft(2,'0')}-${fechaSeleccionada.day.toString().padLeft(2,'0')} ${fechaSeleccionada.hour.toString().padLeft(2,'0')}:${fechaSeleccionada.minute.toString().padLeft(2,'0')}:00';
                                                    setState(() {
                                                      horaRecepcion = fechaConvertida;
                                                      servicioAPI.upHoraRecepcion(folio!, 1, horaRecepcion!);
                                                    });
                                                  }
                                                });
                                              }
                                            });
                                          } : null,
                                          child: Icon(Icons.edit, color: (folioEncontrado != false)? Theme.of(context).colorScheme.primary : Colors.grey, size: 20,),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      // Text((horaEntrada != null)? '$horaEntrada' : 'N/A', style: TextStyle(color: Colors.grey.shade500),),
                                      Expanded(
                                        flex: 9,
                                        child: Text((horaRecepcion != null)? '$horaEntrada' : 'N/A', style: TextStyle(color: Colors.grey.shade500),),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: (folioEncontrado != false)? (){
                                            showDatePicker(
                                              context: context,
                                              initialDate: DateTime.parse('$horaEntrada'),
                                              firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
                                              lastDate: DateTime.now(),
                                            ).then((diaSeleccionado){
                                              if(diaSeleccionado != null){
                                                showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.fromDateTime(DateTime.parse('$horaEntrada')),
                                                ).then((horaSeleccionada) {
                                                  if(horaSeleccionada != null) {
                                                    DateTime fechaSeleccionada = DateTime(
                                                      diaSeleccionado.year,
                                                      diaSeleccionado.month,
                                                      diaSeleccionado.day,
                                                      horaSeleccionada.hour,
                                                      horaSeleccionada.minute,
                                                    );
                                                    String fechaConvertida = '${fechaSeleccionada.year.toString()}-${fechaSeleccionada.month.toString().padLeft(2,'0')}-${fechaSeleccionada.day.toString().padLeft(2,'0')} ${fechaSeleccionada.hour.toString().padLeft(2,'0')}:${fechaSeleccionada.minute.toString().padLeft(2,'0')}:00';
                                                    setState(() {
                                                      horaEntrada = fechaConvertida;
                                                      servicioAPI.upHoraRecepcion(folio!, 2, horaEntrada!);
                                                    });
                                                  }
                                                });
                                              }
                                            });
                                          } : null,
                                          child: Icon(Icons.edit, color: (folioEncontrado != false)? Theme.of(context).colorScheme.primary : Colors.grey, size: 20,),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(height: 10,),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           const Text('Fecha fin muestreo', style: TextStyle(fontWeight: FontWeight.w500),),
                        //           Text('dd/mm/aaaa --:-- ----', style: TextStyle(color: Colors.grey.shade500),),
                        //         ],
                        //       ),
                        //     ),
                        //     const Padding(padding: EdgeInsets.only(left: 8),),
                        //     Expanded(
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           const Text('Fecha conformación', style: TextStyle(fontWeight: FontWeight.w500),),
                        //           Text('dd/mm/aaaa --:-- ----', style: TextStyle(color: Colors.grey.shade500),),
                        //         ],
                        //       ),
                        //     ),
                        //     const Padding(padding: EdgeInsets.only(left: 8),),
                        //     Expanded(
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           const Text('Procedencia', style: TextStyle(fontWeight: FontWeight.w500),),
                        //           Text('N/A', style: TextStyle(color: Colors.grey.shade500),),
                        //         ],
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15,),
              const Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 15),),
                  Text('Puntos de muestreo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 5),
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
                        (foliosHijos != null) ?
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: foliosHijos?.length ?? 0,
                          itemBuilder: (context, index) {
                            final punto = foliosHijos![index];
                            return Container(
                              decoration: BoxDecoration(
                                border: (index == foliosHijos!.length - 1)? null : const Border(bottom: BorderSide(width: 0.1),),
                              ),
                              child: ListTile(
                                leading: Icon(Icons.do_not_disturb_on_total_silence_rounded, color: Theme.of(context).colorScheme.primary,),
                                // leading: Text('${punto.idFolio}', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 14),),
                                title: Row(
                                  children: [
                                    Text('${punto.idFolio} ', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold), softWrap: true,),
                                    Text('${punto.punto}', style: const TextStyle(fontWeight: FontWeight.bold), softWrap: true,),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Conductividad: ${punto.conductividad ?? 'Sin conductividad'}', softWrap: true,),
                                    // Text('Cloruros: ${punto.cloruros ?? 'Sin cloruros'}', softWrap: true,),
                                    obtenerCloruros(punto.cloruros),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.arrow_forward_ios, color: Theme.of(context).colorScheme.primary,),
                                  onPressed: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => PuntoMuestreoPage(puntoMuestreo: punto)),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        )
                            :
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('No hay puntos de muestreo que mostrar', style: TextStyle(fontSize: 15, ),),
                          ],
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Text('No hay puntos de muestreo que mostrar', style: TextStyle(fontSize: 15, ),),
                        //   ],
                        // ),
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
                        Row(
                          children: [
                            Flexible(
                              fit: FlexFit.tight,
                              child: SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: (parametrosGenerados == null)? null : (){},
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.resolveWith((states){
                                      if(states.contains(WidgetState.pressed)){
                                        return const Color.fromRGBO(0, 168, 23, 1);
                                      }
                                      if(states.contains(WidgetState.disabled)){
                                        return const Color.fromRGBO(0, 168, 89, 0.4);
                                      }
                                      return const Color.fromRGBO(0, 168, 80, 1);
                                    }),
                                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                      const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(8)),
                                      ),
                                    ),
                                    elevation: WidgetStateProperty.resolveWith((states){
                                      if(states.contains(WidgetState.disabled)){
                                        return 0;
                                      }
                                      return 8;
                                    }),
                                  ),
                                  child: const Text('Generar Codigos', style: TextStyle(color: Colors.white),),
                                ),
                              ),
                            ),
                          ],
                        ),
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
        return const Text('Cloruros: < 500', softWrap: true,);
      case 500:
        return const Text('Cloruros: 500', softWrap: true,);
      case 1000:
        return const Text('Cloruros: 1000', softWrap: true,);
      case 1500:
        return const Text('Cloruros: > 1000', softWrap: true,);
      default:
        return const Text('Cloruros: Sin cloruros');
    }
  }
}