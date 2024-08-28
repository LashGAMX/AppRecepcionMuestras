import 'package:flutter/material.dart';
import 'package:recepcion_app/api/servicio_api.dart';
import 'package:recepcion_app/models/informacion_agua_model.dart';
import 'package:recepcion_app/pages/punto_muestreo_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? idUsuario;
bool errorEncontrar = false;
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
String? fechaFinMuestreo;
String? fechaConformacion;
String? procedencia;
bool? parametrosGenerados;
List<FoliosHijosModel>? foliosHijos;
List<ParametrosModel>? parametros;
bool? folioEncontrado;
int? idNorma;
bool cargandoParametros = false;
bool condiciones = false;
bool historial = false;
String? fechaEmision;
bool cargandoFolio = false;

class AguaPage extends StatefulWidget{
  final FoliosHijosModel? regresado;
  const AguaPage({super.key, this.regresado});

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
    getVariablesSesion();
    errorEncontrar = false;
    idSolicitud = null;
    folio = null;
    muestraIngresada = null;
    codigosGenerados = null;
    siralab = null;
    descarga = null;
    cliente = null;
    empresa = null;
    fechaMuestreo = null;
    horaRecepcion = null;
    horaEntrada = null;
    fechaFinMuestreo = null;
    fechaConformacion = null;
    procedencia = null;
    parametrosGenerados = null;
    foliosHijos = null;
    parametros = null;
    idNorma = null;
    folioEncontrado = false;
    cargandoParametros = false;
    condiciones = false;
    historial = false;
    fechaEmision = null;
    cargandoFolio = false;
    super.initState();
  }

  getInformacionFolio(String folioMandado) async {
    setState(() {
      cargandoFolio = true;
    });
    servicioAPI.getInformacionFolioAgua(folioMandado).then((value) {
      if(value != null) {
        if (value.mensaje == 'exito') {
          setState(() {
            errorEncontrar = false;
            idSolicitud = value.idSolicitud;
            folio = value.folio;
            muestraIngresada = value.muestraIngresada;
            codigosGenerados = value.codigosGenerados;
            siralab = value.siralab;
            descarga = value.descarga;
            cliente = value.cliente;
            empresa = value.empresa;
            fechaMuestreo = value.fechaMuestreo;
            horaRecepcion = value.horaRecepcion;
            horaEntrada = value.horaEntrada;
            foliosHijos = value.puntosMuestreo;
            idNorma = value.idNorma;
            fechaEmision = value.fechaEmision;
            historial = value.historial!;
            folioEncontrado = true;
          });
          getParametros(folioMandado);
        }
        else {
          setState(() {
            errorEncontrar = true;
            idSolicitud = null;
            folio = null;
            muestraIngresada = null;
            codigosGenerados = null;
            siralab = null;
            descarga = null;
            cliente = null;
            empresa = null;
            fechaMuestreo = null;
            horaRecepcion = null;
            horaEntrada = null;
            fechaFinMuestreo = null;
            fechaConformacion = null;
            procedencia = null;
            parametrosGenerados = null;
            foliosHijos = null;
            parametros = null;
            idNorma = null;
            folioEncontrado = false;
            cargandoParametros = false;
            condiciones = false;
            historial = false;
            fechaEmision = null;
          });
        }
      }
      else{
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Algo salió mal al buscar el folio')));
        }
      }
      setState(() {
        cargandoFolio = false;
      });
    });
  }

  getVariablesSesion() async {
    await SharedPreferences.getInstance().then((value){
      setState(() {
        idUsuario = value.getInt('idUsuario');
      });
    });
  }

  getParametros(String folioMandado) async {
    setState(() {
      cargandoParametros = true;
    });
    servicioAPI.getParametros(folioMandado).then((value) {
      if(value is String) {
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Algo salió mal al obtener los parametros... Intenta otra vez')));
        }
        setState(() {
          cargandoParametros = false;
        });
      }
      else {
        setState(() {
          parametros = value;
          if (parametros != null && parametros!.isNotEmpty) {
            parametrosGenerados = true;
          }
          else if (parametros != null && parametros!.isEmpty) {
            parametrosGenerados = false;
          }
          cargandoParametros = false;
        });
      }
    });
  }

  upHoraRecepcion(String folio, int tipoHora, String hora) async {
    servicioAPI.upHoraRecepcion(folio, tipoHora, hora);
  }

  setCodigos() async {
    if(idNorma! == 27){
      bool errorNorma = false;
      for (FoliosHijosModel folio in foliosHijos!){
        if(folio.conductividad == null || folio.cloruros == null){
          errorNorma = true;
        }
      }
      if(errorNorma == true){
        if(context.mounted){
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: SizedBox(
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Error al generar códigos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500), softWrap: true,),
                        const SizedBox(height: 20,),
                        const Text('Los puntos de muestreo deben tener conductividad y cloruros', softWrap: true,),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            const Expanded(child: SizedBox()),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: (){
                                  Navigator.of(context, rootNavigator: true).pop();
                                },
                                child: const Text('Entendido'),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
          );
        }
      }
      else{
        List<int?> conductividades = [];
        List<int?> cloruros = [];
        for (FoliosHijosModel folio in foliosHijos!){
          conductividades.add(folio.conductividad);
          cloruros.add(folio.cloruros);
        }
        setState(() {
          cargandoParametros = true;
        });
        servicioAPI.setCodigos(idSolicitud!, condiciones, conductividades, cloruros).then((value) {
          if(value == "Codigos creados correctamente"){
            setState(() {
              codigosGenerados = true;
            });
            if(mounted){
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Códigos creados correctamente')));
            }
            getParametros(folio!);
          }
          else{
            setState(() {
              cargandoParametros = false;
            });
          }
        });
      }
    }
    else{
      List<int?> conductividades = [];
      List<int?> cloruros = [];
      for (FoliosHijosModel folio in foliosHijos!){
        conductividades.add(folio.conductividad);
        cloruros.add(folio.cloruros);
      }
      setState(() {
        cargandoParametros = true;
      });
      servicioAPI.setCodigos(idSolicitud!, condiciones, conductividades, cloruros).then((value) {
        if(value == "Codigos creados correctamente"){
          setState(() {
            codigosGenerados = true;
          });
          if(mounted){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Códigos creados correctamente')));
          }
          getParametros(folio!);
        }
        else{
          setState(() {
            cargandoParametros = false;
          });
        }
      });
    }
  }

  ingresarMuestra() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ingresar muestra'),
          content: const Text('¿Realmente deseas ingresar la muestra?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(true),
              child: const Text('Ingresar'),
            ),
          ],
        );
      }
    ).then((resultado) {
      if(resultado == null) return;

      if(resultado){
        if(horaRecepcion == null || horaEntrada == null){
          if(mounted){
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: const Text('Se necesita especificar la hora de recepción'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                      child: const Text('Entiendo'),
                    ),
                  ],
                );
              }
            );
          }
        }
        else{
          servicioAPI.setIngresar(idSolicitud!, folio!, descarga!, cliente!, empresa!, horaRecepcion!, horaEntrada!, historial, idUsuario!).then((value){
            if(value[0] == "Muestra ingresada"){
              setState(() {
                muestraIngresada = true;
                fechaEmision = value[1];
              });
              if(mounted){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Muestra ingresada')));
              }
            }
          });
        }
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
                                    onPressed: (cargandoFolio == false)? (){
                                      if(_formKey.currentState!.validate()) {
                                        getInformacionFolio(_controlerFolio.text);
                                      }
                                      FocusManager.instance.primaryFocus?.unfocus();
                                    } : null,
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.resolveWith((states){
                                        if(states.contains(WidgetState.pressed)){
                                          return Theme.of(context).colorScheme.inversePrimary;
                                        }
                                        if(states.contains(WidgetState.disabled)){
                                          return Theme.of(context).colorScheme.primary.withOpacity(0.4);
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
              (folioEncontrado == true)? const SizedBox(height: 15,) : const SizedBox(),
              (folioEncontrado == true)?
                Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 15),),
                    Expanded(
                      child: (muestraIngresada == true)? const Text('Muestra ingresada', style: TextStyle(color: Colors.green), softWrap: true,) : Text('Falta ingresar', style: TextStyle(color: Colors.yellow.shade800), softWrap: true,),
                    ),
                    Expanded(
                      child: (siralab == true)? const Text('Folio Siralab', style: TextStyle(color: Colors.green), softWrap: true,) : Text('Folio no Siralab', style: TextStyle(color: Colors.yellow.shade800), softWrap: true,),
                    ),
                  ],
                )
                  :
                const SizedBox(),
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
                                              initialDate: DateTime.parse('$fechaMuestreo'),
                                              firstDate: DateTime.parse('$fechaMuestreo'),
                                              // firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
                                              lastDate: DateTime.now().add(const Duration(days: 30)),
                                            ).then((diaSeleccionado) {
                                              if(diaSeleccionado != null){
                                                if(context.mounted){
                                                  showTimePicker(
                                                    context: context,
                                                    initialTime: TimeOfDay.now(),
                                                    // initialTime: TimeOfDay.fromDateTime(DateTime.parse('$horaRecepcion')),
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
                                                      if(muestraIngresada == true){
                                                        servicioAPI.upHoraRecepcion(folio!, 1, fechaConvertida).then((value) {
                                                          if(value != null){
                                                            setState(() {
                                                              horaRecepcion = fechaConvertida;
                                                            });
                                                          }
                                                          else{
                                                            if(context.mounted) {
                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo actualizar la hora')));
                                                            }
                                                          }
                                                        });
                                                      }
                                                      else{
                                                        setState(() {
                                                          horaRecepcion = fechaConvertida;
                                                        });
                                                      }
                                                    }
                                                  });
                                                }
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
                                        child: Text((horaEntrada != null)? '$horaEntrada' : 'N/A', style: TextStyle(color: Colors.grey.shade500),),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: (folioEncontrado != false)? (){
                                            showDatePicker(
                                              context: context,
                                              initialDate: DateTime.parse('$fechaMuestreo'),
                                              firstDate: DateTime.parse('$fechaMuestreo'),
                                              // firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
                                              lastDate: DateTime.now().add(const Duration(days: 30)),
                                            ).then((diaSeleccionado){
                                              if(diaSeleccionado != null){
                                                if(context.mounted){
                                                  showTimePicker(
                                                    context: context,
                                                    initialTime: TimeOfDay.now(),
                                                    // initialTime: TimeOfDay.fromDateTime(DateTime.parse('$horaEntrada')),
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
                                                      if(muestraIngresada == true){
                                                        servicioAPI.upHoraRecepcion(folio!, 2, fechaConvertida).then((value) {
                                                          if(value != null) {
                                                            setState(() {
                                                              horaEntrada = fechaConvertida;
                                                            });
                                                          }
                                                          else {
                                                            if(context.mounted) {
                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo actualizar la hora')));
                                                            }
                                                          }
                                                        });
                                                      }
                                                      else{
                                                        setState(() {
                                                          horaEntrada = fechaConvertida;
                                                        });
                                                      }
                                                      // setState(() {
                                                      //   horaEntrada = fechaConvertida;
                                                      //   if(muestraIngresada == true){
                                                      //     servicioAPI.upHoraRecepcion(folio!, 2, horaEntrada!);
                                                      //   }
                                                      // });
                                                    }
                                                  });
                                                }
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
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15,),
              Row(
                children: [
                  const Padding(padding: EdgeInsets.only(left: 15),),
                  Text('Puntos de muestreo: ${foliosHijos != null ? '#${foliosHijos!.length}' : 'N/A'}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), softWrap: true,),
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
                        SizedBox(
                          height: 110,
                          child: ListView.builder(
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
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: '${punto.idFolio} ',
                                                style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold,),
                                              ),
                                              TextSpan(
                                                text: '${punto.punto}',
                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          softWrap: true,
                                        ),
                                      ),
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
                                    onPressed: () async {
                                      final vuelta = await Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => PuntoMuestreoPage(puntoMuestreo: punto, muestraIngresada: muestraIngresada!, codigosGenerados: codigosGenerados!,)),
                                      );

                                      if (vuelta != null){
                                        setState(() {
                                          foliosHijos![index].conductividad = vuelta.conductividad;
                                          foliosHijos![index].cloruros = vuelta.cloruros;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                            :
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('No hay puntos de muestreo que mostrar', style: TextStyle(fontSize: 15, ),),
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
                  Expanded(flex: 1, child: Text('Parametros', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,), softWrap: true,)),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(padding: EdgeInsets.only(left: 15),),
                  Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Fecha de emisión:  ',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        TextSpan(
                          text: fechaEmision ?? 'N/A',
                        ),
                      ],
                    ),
                    softWrap: true,
                  ),
                  IconButton(
                    onPressed: (muestraIngresada == true)? (){
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.parse('$fechaEmision'),
                        firstDate: DateTime.parse('$fechaMuestreo'),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      ).then((valor) {
                        if(valor != null){
                          String nuevaFechaEmision = '${valor.year.toString()}-${valor.month.toString().padLeft(2,'0')}-${valor.day.toString().padLeft(2,'0')}';
                          servicioAPI.upFechaEmision(folio!, nuevaFechaEmision).then((nuevoValor) {
                            if(nuevoValor != null){
                              setState(() {
                                fechaEmision = nuevaFechaEmision;
                              });
                            }
                            else{
                              if(context.mounted){
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo cambiar la fecha de emisión')));
                              }
                            }
                          });
                        }
                      });
                    } : null,
                    icon: Icon(Icons.edit, color: (muestraIngresada == true)? Theme.of(context).colorScheme.primary : Colors.grey, size: 20,),
                  ),
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
                            Expanded(
                              child: ListTileTheme(
                                horizontalTitleGap: 0,
                                child: CheckboxListTile(
                                  title: const Text('Sin condiciones', style: TextStyle(fontSize: 10), softWrap: true,),
                                  value: condiciones,
                                  enabled: (codigosGenerados == true)? false : true,
                                  onChanged: (nuevoValor){
                                    if(nuevoValor == true){
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('Alerta'),
                                              content: const Text('¿Realmente deseas generar códigos sin condiciones?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.of(context, rootNavigator: true).pop(false),
                                                  child: const Text('Cancelar'),
                                                ),
                                                TextButton(
                                                  onPressed: () => Navigator.of(context, rootNavigator: true).pop(true),
                                                  child: const Text('Aceptar'),
                                                ),
                                              ],
                                            );
                                          }
                                      ).then((resultado) {
                                        if(resultado == null) return;

                                        if(resultado){
                                          setState(() {
                                            condiciones = nuevoValor!;
                                          });
                                        }
                                      });
                                    }
                                    else{
                                      setState(() {
                                        condiciones = nuevoValor!;
                                      });
                                    }
                                  },

                                  controlAffinity: ListTileControlAffinity.trailing,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListTileTheme(
                                horizontalTitleGap: 0,
                                child: CheckboxListTile(
                                  title: const Text('Historial', style: TextStyle(fontSize: 10), softWrap: true,),
                                  value: historial,
                                  enabled: (muestraIngresada == true)? false : true,
                                  onChanged: (nuevoValor){
                                    setState(() {
                                      historial = nuevoValor!;
                                    });
                                  },
                                  controlAffinity: ListTileControlAffinity.trailing,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              fit: FlexFit.tight,
                              child: SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: (parametrosGenerados != null && parametrosGenerados == false)? (){
                                    setCodigos();
                                  } : null,
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.resolveWith((states){
                                      if(states.contains(WidgetState.pressed)){
                                        return const Color.fromRGBO(237, 187, 116, 1);
                                      }
                                      if(states.contains(WidgetState.disabled)){
                                        return const Color.fromRGBO(240, 173, 78, 0.4);
                                      }
                                      return const Color.fromRGBO(240, 173, 78, 1);
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
                        const SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                (cargandoParametros == false) ?
                                  (parametros != null && parametros!.isNotEmpty) ?
                                      SizedBox(
                                        height: 250,
                                        width: MediaQuery.of(context).size.width - 80,
                                        child: ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: parametros?.length ?? 0,
                                          itemBuilder: (context, index){
                                            final parametro = parametros![index];
                                            return Container(
                                              decoration: BoxDecoration(
                                                border: (index == parametros!.length - 1)? null : const Border(bottom: BorderSide(width: 0.2),),
                                              ),
                                              child: ListTile(
                                                title: IntrinsicHeight(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 4,
                                                        child: Text(parametro.codigo ?? 'NULL', softWrap: true,),
                                                      ),
                                                      const VerticalDivider(),
                                                      Expanded(
                                                        flex: 6,
                                                        child: Text(parametro.parametro ?? 'NULL', softWrap: true,),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                        :
                                      const Text('No hay parametros por mostrar', softWrap: true,)
                                    :
                                  const CircularProgressIndicator()
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              fit: FlexFit.tight,
                              child: SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: (muestraIngresada != null && muestraIngresada == false && codigosGenerados == true)? (){
                                    ingresarMuestra();
                                  } : null,
                                  style: ButtonStyle(
                                    overlayColor: WidgetStateProperty.all(Theme.of(context).colorScheme.inversePrimary),
                                    backgroundColor: WidgetStateProperty.resolveWith((states){
                                      if(states.contains(WidgetState.disabled)){
                                        return const Color.fromRGBO(0, 168, 80, 0.4);
                                      }
                                      return const Color.fromRGBO(0, 168, 80, 1);
                                    }),
                                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                      const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(8)),
                                      ),
                                    ),
                                  ),
                                  child: const Text('Ingresar', style: TextStyle(color: Colors.white),),
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
              const SizedBox(height: 15,),
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
        return const Text('Cloruros: Sin cloruros', softWrap: true,);
    }
  }
}