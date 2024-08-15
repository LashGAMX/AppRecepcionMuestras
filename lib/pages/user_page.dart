import 'package:flutter/material.dart';
import 'package:recepcion_app/api/servicio_api.dart';
import 'package:recepcion_app/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? finalIdUsuario;
String? finalAvatar;
String? finalUser;
String? finalNombre;
String? finalIniciales;

class UserPage extends StatefulWidget{
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>{
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final String urlBaseStorage = 'http://sistemasofia.ddns.net:85/sofia/public/storage/';
  bool datosObtenidos = false;
  ServicioAPI servicioAPI = ServicioAPI();

  getUser() async {
    SharedPreferences variablesSesion = await SharedPreferences.getInstance();
    int? idUsuario = variablesSesion.getInt('idUsuario');
    String? avatar = variablesSesion.getString('avatar');
    setState(() {
      finalIdUsuario = idUsuario;
      finalAvatar = avatar;
      datosObtenidos = true;
    });
    servicioAPI.getUser(idUsuario!).then((value) {
      setState(() {
        finalUser = value.user;
        finalNombre = value.nombre;
        finalIniciales = value.iniciales;
      });
    });
  }

  borrarSesion() async {
    SharedPreferences variablesSesion = await SharedPreferences.getInstance();
    variablesSesion.remove('sesionIniciada');
    variablesSesion.remove('idUsuario');
    variablesSesion.remove('avatar');
  }

  @override
  void initState() {
    // TODO: implement initState
    finalIdUsuario = null;
    finalAvatar = null;
    finalUser = null;
    finalNombre = null;
    finalIniciales = null;
    getUser();
    super.initState();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
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
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.topCenter,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                          ),
                          child: Column(
                            children: [
                              Transform.translate(
                                offset: const Offset(0, -100/2),
                                child: (finalAvatar != null)?
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 45,
                                    child: CircleAvatar(
                                      radius: 40, 
                                      backgroundImage: Image.network('$urlBaseStorage$finalAvatar', errorBuilder: (context, exception, stacktrace){
                                        return const Icon(Icons.account_circle_outlined, size: 90,);
                                      },).image,),)
                                    :
                                  const CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 45,
                                    child: Icon(Icons.account_circle_outlined, size: 90),
                                  ),
                              ),
                              Transform.translate(
                                offset: const Offset(0, -40),
                                child: Text('$finalNombre', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17), softWrap: true,),
                              ),
                              Transform.translate(
                                offset: const Offset(0, -30),
                                child: Text('$finalIniciales', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      borrarSesion();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    child: Container(
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
                      child: Row(
                        children: [
                          const Padding(padding: EdgeInsets.symmetric(vertical: 32, horizontal: 10)),
                          Icon(Icons.logout_outlined, color: Theme.of(context).colorScheme.primary, size: 30,),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          const Text('Cerrar Sesión', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                        ],
                      ),
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