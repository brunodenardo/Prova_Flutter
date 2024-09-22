import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
          '/notasAlunos': (context) => ListPage()
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
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Center(
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
  String token = "";

  Future<void> pegaToken() async {
    final response = await http.get(Uri.parse("http://localhost:3000/login"));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        token = jsonResponse["data"]["token"];
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  final TextEditingController _login = TextEditingController();
  final TextEditingController _senha = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Form(
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
                          prefixIcon:
                              Icon(Icons.account_circle_outlined), //icon
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
                          if (token == "") {
                            pegaToken();
                          } else {
                            Navigator.pushNamed(context, '/notasAlunos');
                          }
                        },
                        child: Text("Entrar")),
                    SizedBox(height: 20),
                    Text(token)
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

class ListPage extends StatefulWidget {
  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<dynamic> listaOriginal = [];
  List<dynamic> listaFiltradaMenos60 = [];
  List<dynamic> listaFiltradaMais60 = [];
  List<dynamic> listaFiltradaIgual100 = [];
  
  String filtro = "todos";

  Future<void> pegaNotasAlunos() async {
    final response =
        await http.get(Uri.parse("http://localhost:3000/notasAlunos"));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        listaOriginal = jsonResponse["data"]["alunos"];
        listaFiltradaIgual100 = listaOriginal.where((aluno) => aluno["nota"] == 100).toList();
        listaFiltradaMais60 = listaOriginal.where((aluno) => aluno["nota"] >= 60 && aluno["nota"] < 100).toList();
        listaFiltradaMenos60 = listaOriginal.where((aluno) => aluno["nota"] < 60).toList();
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  void initState() {
    super.initState();
    pegaNotasAlunos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "Notas dos Alunos",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: geraListaFiltrada(filtro, listaOriginal).length,
                itemBuilder: (BuildContext context, int index) {
                  if (filtro == "todos") {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                          color: (index % 2 == 1)
                              ? const Color.fromARGB(255, 255, 231, 254)
                              : const Color.fromARGB(255, 208, 190, 208),
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(listaOriginal[index]["matricula"]),
                            SizedBox(width: 20),
                            Text(listaOriginal[index]["nomeAluno"]),
                            SizedBox(width: 20),
                            Text(listaOriginal[index]["nota"].toString()),
                          ],
                        ),
                      ),
                    );
                  }
                  if (filtro == "Nota < 60") {
                      return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                          color: (index % 2 == 1)
                              ? const Color.fromARGB(255, 255, 231, 254)
                              : const Color.fromARGB(255, 208, 190, 208),
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(listaFiltradaMenos60[index]["matricula"]),
                            SizedBox(width: 20),
                            Text(listaFiltradaMenos60[index]["nomeAluno"]),
                            SizedBox(width: 20),
                            Text(listaFiltradaMenos60[index]["nota"].toString()),
                          ],
                        ),
                      ),
                    );
                  }
                  if (filtro == "Nota >= 60") {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                          color: (index % 2 == 1)
                              ? const Color.fromARGB(255, 255, 231, 254)
                              : const Color.fromARGB(255, 208, 190, 208),
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(listaFiltradaMais60[index]["matricula"]),
                            SizedBox(width: 20),
                            Text(listaFiltradaMais60[index]["nomeAluno"]),
                            SizedBox(width: 20),
                            Text(listaFiltradaMais60[index]["nota"].toString()),
                          ],
                        ),
                      ),
                    );
                  }
                  if (filtro == "Nota = 100") {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                          color: (index % 2 == 1)
                              ? const Color.fromARGB(255, 255, 231, 254)
                              : const Color.fromARGB(255, 208, 190, 208),
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(listaFiltradaIgual100[index]["matricula"]),
                            SizedBox(width: 20),
                            Text(listaFiltradaIgual100[index]["nomeAluno"]),
                            SizedBox(width: 20),
                            Text(listaFiltradaIgual100[index]["nota"].toString()),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
              ElevatedButton(
                child: (Text("Nota < 60")),
                onPressed: () {
                  if (filtro != "Nota < 60") {
                    setState(() {             
                      filtro = "Nota < 60";
                    });
                    
                  } else {
                    setState(() {             
                      filtro = "todos";
                    });
                  }
                },
              ),
              ElevatedButton(
                child: (Text("Nota >= 60")),
                onPressed: () {
                  if (filtro != "Nota >= 60") {
                    setState(() {
                      filtro = "Nota >= 60";
                    });
                  } else {
                    setState(() {             
                      filtro = "todos";
                    });

                  }
                },
              ),
              ElevatedButton(
                child: (Text("Nota = 100")),
                onPressed: () {
                  if (filtro != "Nota = 100") {
                    setState(() {
                      filtro = "Nota = 100";
                    });
                  } else {
                    setState(() {             
                      filtro = "todos";
                    });
                  }
                },
              ),
            ]),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

geraListaFiltrada(String filtro, List listaAlunos){
  if(filtro == "todos"){
    return listaAlunos;
  }
  else if(filtro == "Nota >= 60"){
    List listaFiltrada = listaAlunos.where((aluno) => aluno["nota"] >= 60 && aluno["nota"] != 100).toList();
    return listaFiltrada;
  }
  else if(filtro == "Nota < 60"){
    List listaFiltrada = listaAlunos.where((aluno) => aluno["nota"] < 60).toList();
    return listaFiltrada;
  }
  else if(filtro == "Nota = 100"){
    List listaFiltrada = listaAlunos.where((aluno) => aluno["nota"] == 60).toList();
    return listaFiltrada;
  }
}
