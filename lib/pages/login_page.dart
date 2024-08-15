import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recepcion_app/api/servicio_api.dart';
import 'package:recepcion_app/models/login_model.dart';
import 'package:recepcion_app/pages/home_page.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controlerUsuario = TextEditingController();
  final TextEditingController _controlerContrasena = TextEditingController();

  bool esconderContrasena = true;
  bool errorSesion = false;

  @override
  void initState() {
    getSesionIniciada().then((value) {
      if(value == true){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    });
    super.initState();
  }

  void _mostrarContrasena(){
    setState(() {
      esconderContrasena = !esconderContrasena;
    });
  }

  void _errorSesion(bool estadoSesion){
    setState(() {
      errorSesion = estadoSesion;
    });
  }
  
  setSesionIniciada() async {
    SharedPreferences variablesSesion = await SharedPreferences.getInstance();
    variablesSesion.setBool('sesionIniciada', true);
  }
  
  getSesionIniciada() async {
    SharedPreferences variablesSesion = await SharedPreferences.getInstance();
    bool? sesionIniciada = variablesSesion.getBool('sesionIniciada');
    
    return sesionIniciada;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey.shade200,
      bottomNavigationBar:
      OrientationBuilder(
        builder: (context, orientation){
          return SafeArea(
            child: (orientation == Orientation.portrait)? const Image(image: AssetImage('assets/images/banner-inferior.png'),) : const Text(''),
          );
        },
      ),
      body: SafeArea(
        child: formulario(),
      ),
    );
  }

  Center formulario(){
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image(image: AssetImage('assets/images/logo.png'), width: 75, height: 75,),
                Text('acama', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 40),),
                Text('', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              ],
            ),
            const SizedBox(height: 25,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text('Bienvenido a la aplicación de ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey.shade700),),
                ),
                Text('recepción de muestras', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey.shade700),),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text('Por favor ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey.shade700),),
                ),
                Text('inicia sesión ', style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.inversePrimary, fontWeight: FontWeight.w500),),
                Text('para continuar', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey.shade700),),
              ],
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 25,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextFormField(
                      controller: _controlerUsuario,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'Favor de introducir su nombre de usuario';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Usuario',
                        prefixIcon: Icon(Icons.account_circle_outlined, color: Theme.of(context).colorScheme.primary,),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextFormField(
                      controller: _controlerContrasena,
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'Favor de introducir su contraseña';
                        }
                        return null;
                      },
                      obscureText: esconderContrasena,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Contraseña',
                        prefixIcon: Icon(Icons.lock_open_rounded, color: Theme.of(context).colorScheme.primary,),
                        suffixIcon: IconButton(
                          onPressed: (){_mostrarContrasena();},
                          icon: Icon(esconderContrasena? Icons.visibility_off_outlined : Icons.visibility_outlined),
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if(_formKey.currentState!.validate()) {
                                LoginRequestModel loginRequestModel = LoginRequestModel(usuario: _controlerUsuario.text, contrasena: _controlerContrasena.text);
                                ServicioAPI servicioAPI = ServicioAPI();
                                // _futureLoginResponseModel = servicioAPI.login(loginRequestModel);
                                // LoginResponseModel loginResponseModel = servicioAPI.login(loginRequestModel) as LoginResponseModel;
                                // print(loginResponseModel.toJson());
                                SharedPreferences variablesSesion =  await SharedPreferences.getInstance();
                                servicioAPI.login(loginRequestModel).then((value){
                                  variablesSesion.setInt('idUsuario', value.idUsuario);
                                  variablesSesion.setString('avatar', value.avatar);
                                  if(value.estado == 'exito'){
                                    _errorSesion(false);
                                    setSesionIniciada();
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => const HomePage()),
                                    );
                                  }
                                  else{
                                    _errorSesion(true);
                                  }
                                });
                              }
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
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                            child: const Text('Iniciar Sesión', style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5,),
                  (errorSesion == false) ? const Text('') : const Text('Nombre de usuario o contraseña incorrectos', style: TextStyle(color: Colors.red),),
                ],
              ),
            )
          ]
        ),
      ),
    );
  }

  // FutureBuilder<LoginResponseModel> buildFutureLoginResponseModelBuilder(){
  //   return FutureBuilder<LoginResponseModel>(
  //     future: _futureLoginResponseModel,
  //     builder: (context, snapshot) {
  //       if(snapshot.hasData){
  //         return Text('${snapshot.data!.estado} : ${snapshot.data!.mensaje}');
  //       } else if (snapshot.hasError) {
  //         return Text('${snapshot.error}');
  //       }
  //
  //       return const CircularProgressIndicator();
  //     }
  //   );
  // }
}