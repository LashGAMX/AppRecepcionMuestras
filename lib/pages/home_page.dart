import 'package:flutter/material.dart';
import 'package:recepcion_app/pages/agua_page.dart';
import 'package:recepcion_app/pages/alimentos_page.dart';
import 'package:recepcion_app/pages/user_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? finalIdUsuario;
String? finalAvatar;

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final String urlBaseStorage = 'http://sistemasofia.ddns.net:85/sofia/public/storage/';

  getUsuario() async {
    SharedPreferences variablesSesion = await SharedPreferences.getInstance();
    int? idUsuario = variablesSesion.getInt('idUsuario');
    String? avatar = variablesSesion.getString('avatar');
    setState(() {
      finalIdUsuario = idUsuario;
      finalAvatar = avatar;
    });
  }

  borrarSesion() async {
   SharedPreferences variablesSesion = await SharedPreferences.getInstance();
   variablesSesion.remove('sesionIniciada');
   variablesSesion.remove('idUsuario');
   variablesSesion.remove('avatar');
  }

  @override
  Widget build(BuildContext context){
    getUsuario();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey.shade100,
      bottomNavigationBar: OrientationBuilder(
        builder: (context, orientation){
          return SafeArea(
            child: (orientation == Orientation.portrait)? const Image(image: AssetImage('assets/images/banner-inferior2.png'),) : const Text(''),
          );
        },
      ),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const UserPage()),
                      );
                    },
                      child: (finalAvatar != '')? CircleAvatar(radius: 30, backgroundImage: NetworkImage('$urlBaseStorage$finalAvatar'), ) : const Icon(Icons.account_circle_outlined, size: 60,),
                  ),
                ],
              ),
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AguaPage()),
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
                          const Padding(padding: EdgeInsets.symmetric(vertical: 43, horizontal: 10)),
                          CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            radius: 28,
                            child: const Icon(Icons.water_drop, color: Colors.white, size: 25,),
                          ),
                          // Icon(Icons.water_drop, color: Theme.of(context).colorScheme.primary, size: 40,),
                          const Padding(padding: EdgeInsets.only(left: 20)),
                          const Text('Recepción de agua', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AlimentosPage()),
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
                          const Padding(padding: EdgeInsets.symmetric(vertical: 43, horizontal: 10)),
                          CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            radius: 28,
                            child: const Icon(Icons.food_bank, color: Colors.white, size: 25,),
                          ),
                          // Icon(Icons.water_drop, color: Theme.of(context).colorScheme.primary, size: 40,),
                          const Padding(padding: EdgeInsets.only(left: 20)),
                          Column(
                            children: [
                              const Text('Recepción de alimentos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                              Text('¡Proximamente!', style: TextStyle(color: Colors.grey.shade700),),
                            ],
                          ),
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