
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/domain/user_repository/user_repository_bloc.dart';

List<UserRepository> userRepo = [
  UserRepository({
    "login" : "login",
    "passkey" : "pass"
  }, {

  })
];

void main() async {
  runApp(MainApp());
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => UserRepositoryBloc(),
  child: MaterialApp(
      routes: {
        '/auth': (context) => const LoginPage(),
        '/home': (context) => HomePage()
      },
      home: LoginPage(),
    ),
);
  }
}



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _loginController = TextEditingController();
  TextEditingController _passkeyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width / 5,
            minHeight: MediaQuery.of(context).size.width / 5,
            maxWidth: MediaQuery.of(context).size.width / 5,
            maxHeight: MediaQuery.of(context).size.width / 5,
          ),
          child: BlocListener<UserRepositoryBloc, UserRepositoryState>(
            listener: (context, state) {
              if(state is UserRepositoryLoginSuccessState){
                Navigator.pushNamed(context, '/home');
              } else if (state is UserRepositoryLoginFailedState){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login or password incorrect')));
              }
            },
            child: Column(
            children: [
              const Text('Login', style: TextStyle(fontSize: 36),),
              TextField(controller: _loginController,),
              TextField(controller: _passkeyController,),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: (){
                context.read<UserRepositoryBloc>().add(URLoginUserEvent({"login" : _loginController.text, "password" : _passkeyController.text}));
              }, child: Text('Lets dance'))
            ],
          ),
    ),
        ),
      ),
    );
  }
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed:
        (){
          Navigator.of(context).pushNamed('/auth');
        }, child: Text('Logout'))
      )
    );
  }
}
