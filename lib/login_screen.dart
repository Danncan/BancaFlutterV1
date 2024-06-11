import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'servicelist.dart';

const Color primaryColor = Color(0xFF1E3E59);
const Color secondaryColor = Color(0xFF14548C);
const Color lightPrimary = Color(0xFF83BEF2);
const Color extraLightColor = Color(0xFFBDE0FF);
const Color backgroundColor = Color(0xFFF5F5F5);
const Color accentColor = Color(0xFF4A90E2);
const Color textColor = Color(0xFF424242);

const String loginSvgIcon = '''
<svg fill="#000000" viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"> <g id="ICON"> <path d="M59,43l-54,0l0,-8c0,-0.552 -0.448,-1 -1,-1c-0.552,-0 -1,0.448 -1,1l0,13c-0,0.796 0.316,1.559 0.879,2.121c0.562,0.563 1.325,0.879 2.121,0.879l4,0c0.552,0 1,-0.448 1,-1c0,-0.552 -0.448,-1 -1,-1l-4,0c-0.265,-0 -0.52,-0.105 -0.707,-0.293c-0.188,-0.187 -0.293,-0.442 -0.293,-0.707l0,-3l54,0l0,3c0,0.265 -0.105,0.52 -0.293,0.707c-0.187,0.188 -0.442,0.293 -0.707,0.293l-44,0c-0.552,0 -1,0.448 -1,1c0,0.552 0.448,1 1,1l12.606,0c-0.16,2.682 -0.855,6.147 -3.417,8l-1.689,0c-0.552,-0 -1,0.448 -1,1c0,0.552 0.448,1 1,1l21,0c0.552,-0 1,-0.448 1,-1c0,-0.552 -0.448,-1 -1,-1l-1.689,0c-2.562,-1.854 -3.257,-5.318 -3.417,-8l20.606,0c0.796,-0 1.559,-0.316 2.121,-0.879c0.563,-0.562 0.879,-1.325 0.879,-2.121c0,-6.028 0,-23.972 0,-30c0,-0.796 -0.316,-1.559 -0.879,-2.121c-0.562,-0.563 -1.325,-0.879 -2.121,-0.879l-10,0c-0.552,0 -1,0.448 -1,1c0,0.552 0.448,1 1,1l10,0c0.265,0 0.52,0.105 0.707,0.293c0.188,0.187 0.293,0.442 0.293,0.707l0,25Zm-23.606,8l-6.788,0c-0.155,2.531 -0.785,5.68 -2.585,8l11.958,0c-1.8,-2.32 -2.43,-5.47 -2.585,-8Zm17.606,-22c0,-1.657 -1.343,-3 -3,-3l-36,-0c-1.657,0 -3,1.343 -3,3c0,2.444 0,6.556 0,9c-0,1.657 1.343,3 3,3l36,-0c1.657,-0 3,-1.343 3,-3c0,-2.444 0,-6.556 0,-9Zm-2,0c0,2.444 0,6.556 0,9c0,0.552 -0.448,1 -1,1c-0,-0 -36,-0 -36,-0c-0.552,-0 -1,-0.448 -1,-1c0,-2.444 0,-6.556 -0,-9c-0,-0.552 0.448,-1 1,-1c0,-0 36,0 36,0c0.552,0 1,0.448 1,1Zm-7.228,2.768l-0.772,-0.446c-0.478,-0.276 -1.09,-0.112 -1.366,0.366c-0.276,0.478 -0.112,1.09 0.366,1.366l0.772,0.446l-0.772,0.446c-0.478,0.276 -0.642,0.888 -0.366,1.366c0.276,0.478 0.888,0.642 1.366,0.366l0.772,-0.446l-0,0.768c-0,0.552 0.448,1 1,1c0.552,-0 1,-0.448 1,-1l-0,-0.768l0.772,0.446c0.478,0.276 1.09,0.112 1.366,-0.366c0.276,-0.478 0.112,-1.09 -0.366,-1.366l-0.772,-0.446l0.772,-0.446c0.478,-0.276 0.642,-0.888 0.366,-1.366c-0.276,-0.478 -0.888,-0.642 -1.366,-0.366l-0.772,0.446l-0,-0.768c-0,-0.552 -0.448,-1 -1,-1c-0.552,-0 -1,0.448 -1,1l-0,0.768Zm-12.772,-0l-0.772,-0.446c-0.478,-0.276 -1.09,-0.112 -1.366,0.366c-0.276,0.478 -0.112,1.09 0.366,1.366l0.772,0.446l-0.772,0.446c-0.478,0.276 -0.642,0.888 -0.366,1.366c0.276,0.478 0.888,0.642 1.366,0.366l0.772,-0.446l0,0.768c0,0.552 0.448,1 1,1c0.552,-0 1,-0.448 1,-1l0,-0.768l0.772,0.446c0.478,0.276 1.09,0.112 1.366,-0.366c0.276,-0.478 0.112,-1.09 -0.366,-1.366l-0.772,-0.446l0.772,-0.446c0.478,-0.276 0.642,-0.888 0.366,-1.366c-0.276,-0.478 -0.888,-0.642 -1.366,-0.366l-0.772,0.446l0,-0.768c0,-0.552 -0.448,-1 -1,-1c-0.552,-0 -1,0.448 -1,1l0,0.768Zm-12.728,-0l-0.772,-0.446c-0.478,-0.276 -1.09,-0.112 -1.366,0.366c-0.276,0.478 -0.112,1.09 0.366,1.366l0.772,0.446l-0.772,0.446c-0.478,0.276 -0.642,0.888 -0.366,1.366c0.276,0.478 0.888,0.642 1.366,0.366l0.772,-0.446l-0,0.768c-0,0.552 0.448,1 1,1c0.552,-0 1,-0.448 1,-1l-0,-0.768l0.772,0.446c0.478,0.276 1.09,0.112 1.366,-0.366c0.276,-0.478 0.112,-1.09 -0.366,-1.366l-0.772,-0.446l0.772,-0.446c0.478,-0.276 0.642,-0.888 0.366,-1.366c-0.276,-0.478 -0.888,-0.642 -1.366,-0.366l-0.772,0.446l-0,-0.768c-0,-0.552 -0.448,-1 -1,-1c-0.552,-0 -1,0.448 -1,1l-0,0.768Zm-2.272,-16.768l-10,0c-0.796,0 -1.559,0.316 -2.121,0.879c-0.563,0.562 -0.879,1.325 -0.879,2.121c0,2.509 0,8.581 0,13.5c0,0.552 0.448,1 1,1c0.552,0 1,-0.448 1,-1l0,-13.5c-0,-0.265 0.105,-0.52 0.293,-0.707c0.187,-0.188 0.442,-0.293 0.707,-0.293c0,0 10,0 10,0c0.552,0 1,-0.448 1,-1c0,-0.552 -0.448,-1 -1,-1Zm10.098,-2.262c-0.446,0.311 -0.867,0.663 -1.258,1.053c-1.741,1.742 -2.72,4.104 -2.72,6.567c0,0.224 0,0.438 0,0.642c0,1.657 1.343,3 3,3l13.76,0c1.657,-0 3,-1.343 3,-3l-0,-0.642c-0,-2.463 -0.979,-4.825 -2.72,-6.567c-0.391,-0.39 -0.812,-0.742 -1.258,-1.053c1.31,-2.51 0.912,-5.683 -1.195,-7.789c-2.598,-2.598 -6.816,-2.598 -9.414,-0c-2.107,2.106 -2.505,5.279 -1.195,7.789Zm13.782,7.62l-0,0.642c-0,0.552 -0.448,1 -1,1c-0,0 -13.76,-0 -13.76,-0c-0.552,-0 -1,-0.448 -1,-1l0,-0.642c0,-1.932 0.768,-3.786 2.135,-5.153c1.366,-1.366 3.22,-2.134 5.152,-2.134c0.395,0 0.791,0 1.186,0c1.932,0 3.786,0.768 5.152,2.134c1.367,1.367 2.135,3.221 2.135,5.153Zm-3.734,-8.58c0.896,-1.751 0.611,-3.951 -0.853,-5.415c-1.818,-1.818 -4.768,-1.818 -6.586,-0c-1.464,1.464 -1.749,3.664 -0.853,5.415c1.116,-0.462 2.322,-0.707 3.553,-0.707c0.395,0 0.791,0 1.186,0c1.231,0 2.437,0.245 3.553,0.707Z"></path> </g> </g></svg>
''';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final Uri url = Uri.parse('http://192.168.56.1:6565/api/Clientes/$username');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['Cli_Password'] == password) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('username', username);
          await prefs.setString('cliNombre', data['Cli_Nombre']);
          await prefs.setString('cliApellido', data['Cli_Apellido']);

          final Uri cuentaUrl = Uri.parse('http://192.168.56.1:6565/api/Cuentas/ci/$username');
          final cuentaResponse = await http.get(cuentaUrl);

          if (cuentaResponse.statusCode == 200) {
            final cuentaData = jsonDecode(cuentaResponse.body);
            await prefs.setInt('ctaNumero', cuentaData['Cta_Numero']);
            await prefs.setDouble('ctaSaldo', cuentaData['Cta_Saldo']);

            _showMessage('Inicio de sesión correcto');
            Navigator.pushReplacement(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(builder: (context) => const ServiceListScreen()),
            );
          } else {
            _showMessage('Error al obtener los datos de la cuenta');
          }
        } else {
          _showMessage('Error: Contraseña incorrecta');
        }
      } else {
        _showMessage('Error: Usuario no encontrado');
      }
    } catch (e) {
      _showMessage('Error: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 40),
            Center(
              child: SvgPicture.string(loginSvgIcon, height: 120, color: primaryColor),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person, color: primaryColor),
                      labelText: 'Usuario',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock, color: primaryColor),
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text('Iniciar Sesión'),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.login, color: accentColor),
                    label: const Text('Iniciar con Google', style: TextStyle(color: accentColor)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: accentColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
