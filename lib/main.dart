import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => MyHomePage(),
          '/login': (context) => LoginPage(),
          '/listPage': (context) => ListPage()
        });
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.school_rounded,
              size: 200,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: Size(200, 50)),
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text("Login"))
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _login = TextEditingController();
  final TextEditingController _senha = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: _formKey,
          child: Center(
            child: Container(
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school_rounded, size: 200),
                  SizedBox(height: 20),
                  TextField(
                      controller: _login,
                      decoration: const InputDecoration(
                        hintText: 'Entre com o login', //hint
                        prefixIcon: Icon(Icons.account_circle_outlined), //icon
                        enabledBorder: OutlineInputBorder(
                          //borda ao redor da entrada
                          borderSide:
                              BorderSide(color: Colors.black), //cor da borda
                        ), //quando receber o foco, altera cor da borda
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      )),
                  SizedBox(height: 20),
                  TextField(
                      controller: _senha,
                      decoration: const InputDecoration(
                        hintText: 'Entre com o login', //hint
                        prefixIcon: Icon(Icons.lock_outline_rounded), //icon
                        enabledBorder: OutlineInputBorder(
                          //borda ao redor da entrada
                          borderSide:
                              BorderSide(color: Colors.black), //cor da borda
                        ), //quando receber o foco, altera cor da borda
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      )),
                  SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text("Entrar"))
                ],
              ),
            ),
          )),
    );
  }
}

class ListPage extends StatefulWidget {
  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
