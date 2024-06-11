import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'login_screen.dart';
import 'serviceList.dart'; // Importa el nuevo archivo

const Color primaryColor = Color(0xFF1E3E59);
const Color secondaryColor = Color(0xFF14548C);
const Color lightPrimary = Color(0xFF83BEF2);
const Color extraLightColor = Color(0xFFBDE0FF);
const Color backgroundColor = Color(0xFFF5F5F5);
const Color accentColor = Color(0xFF4A90E2);
const Color textColor = Color(0xFF424242);

const String svgIcon = '''
<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<g id="SVGRepo_bgCarrier" stroke-width="0"></g>
<g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g>
<g id="SVGRepo_iconCarrier">
<path d="M3 21.0001H21M4 18.0001H20M6 18.0001V13.0001M10 18.0001V13.0001M14 18.0001V13.0001M18 18.0001V13.0001M12 7.00695L12.0074 7.00022M21 10.0001L14.126 3.88986C13.3737 3.2212 12.9976 2.88688 12.5732 2.75991C12.1992 2.64806 11.8008 2.64806 11.4268 2.75991C11.0024 2.88688 10.6263 3.2212 9.87404 3.88986L3 10.0001H21Z" stroke="#000000" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path>
</g>
</svg>
''';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banco App',
      theme: ThemeData(
        primaryColor: primaryColor,
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          secondary: secondaryColor,
          onPrimary: Colors.white,
          surface: backgroundColor,
        ),
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: textColor),
        ),
        useMaterial3: true,
      ),
      home: const BancoScreen(),
    );
  }
}

class BancoScreen extends StatelessWidget {
  const BancoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PUCE BANK'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 35),
            Center(
              child: SvgPicture.string(svgIcon, height: 185, color: primaryColor),
            ),
            const SizedBox(height: 10),
            LoginButton(
              icon: Icons.person,
              text: 'Usuario y contraseña',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
            LoginButton(
              icon: Icons.fingerprint,
              text: 'Huella / Face ID',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ServiceListScreen()),
                );
              },
            ),
            const LoginButton(icon: Icons.lock, text: 'PIN de 6 dígitos'),
            TextButton(
              onPressed: () {},
              child: const Text('¿Problemas para ingresar?', style: TextStyle(color: primaryColor)),
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ActionButton(text: 'Ubícanos', icon: Icons.location_on),
                ActionButton(text: 'Clave digital', icon: Icons.vpn_key),
                ActionButton(text: 'Contáctanos', icon: Icons.phone),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const LoginButton({super.key, required this.icon, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: primaryColor),
        title: Text(text, style: const TextStyle(color: primaryColor)),
        onTap: onTap,
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String text;
  final IconData icon;

  const ActionButton({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: primaryColor),
        const SizedBox(height: 5),
        Text(text, style: const TextStyle(color: primaryColor)),
      ],
    );
  }
}
