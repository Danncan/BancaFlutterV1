import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart'; // Importación de Lottie

const Color primaryColor = Color(0xFF1E3E59);
const Color secondaryColor = Color(0xFF14548C);
const Color accentColor = Color(0xFF4A90E2);
const Color textColor = Color(0xFF424242);

class PaymentListScreen extends StatefulWidget {
  final String serviceName;

  const PaymentListScreen({super.key, required this.serviceName});

  @override
  PaymentListScreenState createState() => PaymentListScreenState();
}

class PaymentListScreenState extends State<PaymentListScreen> {
  late Future<List<Payment>> _payments;
  String? _clientFullName;
  double? _balance;

  Future<List<Payment>> _fetchPayments() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? ci = prefs.getString('username');
    final double? balance = prefs.getDouble('ctaSaldo');
    final String? cliNombre = prefs.getString('cliNombre');
    final String? cliApellido = prefs.getString('cliApellido');

    if (!mounted) return [];

    setState(() {
      _clientFullName = '$cliNombre $cliApellido';
      _balance = balance;
    });

    if (ci == null) {
      throw Exception("Usuario no encontrado");
    }

    final Uri url = Uri.parse('http://192.168.56.1:7771/api/Pruebas/mostrarPagos/$ci/${widget.serviceName}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Payment.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar los pagos');
    }
  }

  Future<void> _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/'); // Reemplaza con tu ruta de login
  }

  Future<void> _pay(Payment payment) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final double? balance = prefs.getDouble('ctaSaldo');
    final int? accountNumber = prefs.getInt('ctaNumero');

    if (balance != null && balance >= payment.monto) {
      final Uri updatePaymentUrl = Uri.parse('http://192.168.56.1:7771/api/Pruebas/actualizarEstado/${payment.codPago}/${widget.serviceName}');
      final response = await http.get(updatePaymentUrl);
     
      if (response.statusCode == 200) {
        bool updateSuccess = jsonDecode(response.body);

        if (updateSuccess) {
          final Uri updateBalanceUrl = Uri.parse('http://192.168.56.1:6565/api/Cuentas/actualizarSaldo/$accountNumber/${payment.monto}');
          final balanceResponse = await http.put(updateBalanceUrl);
         
          if (balanceResponse.statusCode == 200) {
            double newBalance = balance - payment.monto;
            await prefs.setDouble('ctaSaldo', newBalance);

            if (!mounted) return;
            setState(() {
              _balance = newBalance;
            });

            _showSuccessAnimation();
          } else {
            _showError('Error al actualizar el saldo');
          }
        } else {
          _showError('Error al actualizar el estado del pago');
        }
      } else {
        _showError('Error en la respuesta del servidor');
      }
    } else {
      _showError('Saldo insuficiente');
    }
  }

  void _showSuccessAnimation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pago exitoso'),
        content: Lottie.asset(
          'assets/success_animation.json',
          repeat: false,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _payments = _fetchPayments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagos - ${widget.serviceName}'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_clientFullName != null && _balance != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cliente: $_clientFullName', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Saldo: \$${_balance!.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          Expanded(
            child: FutureBuilder<List<Payment>>(
              future: _payments,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay pagos disponibles'));
                } else {
                  final payments = snapshot.data!;
                  return ListView.builder(
                    itemCount: payments.length,
                    itemBuilder: (context, index) {
                      final payment = payments[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(payment.codPago),
                          subtitle: Text('Monto: \$${payment.monto}'),
                          trailing: ElevatedButton(
                            onPressed: () => _pay(payment),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: accentColor,
                            ),
                            child: const Text('Pagar'),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Payment {
  final String codPago;
  final double monto;

  Payment({required this.codPago, required this.monto});

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      codPago: json['codPago'],
      monto: json['monto'],
    );
  }
}
