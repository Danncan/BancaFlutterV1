import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const Color primaryColor = Color(0xFF1E3E59);
const Color secondaryColor = Color(0xFF14548C);
const Color backgroundColor = Color(0xFFF5F5F5);
const Color accentColor = Color(0xFF4A90E2);
const Color textColor = Color(0xFF424242);

class ServiceListScreen extends StatelessWidget {
  const ServiceListScreen({super.key});

  final List<Map<String, String>> services = const [
    {
      'name': 'Electricidad',
      'description': 'Pago de servicios eléctricos',
      'svg': '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"> <g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"><path d="M12 22C13.1046 22 14 21.1046 14 20H10C10 21.1046 10.8954 22 12 22ZM18 16V11C18 7.603 15.584 4.787 12.3 4.127V3C12.3 2.284 11.716 1.7 11 1.7C10.284 1.7 9.7 2.284 9.7 3V4.127C6.416 4.787 4 7.603 4 11V16L2 18V19H22V18L20 16H18Z" fill="#000000"></path></g></svg>',
    },
    {
      'name': 'Electricidad',
      'description': 'Pago de servicios eléctricos',
      'svg': '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"> <g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"><path d="M12 22C13.1046 22 14 21.1046 14 20H10C10 21.1046 10.8954 22 12 22ZM18 16V11C18 7.603 15.584 4.787 12.3 4.127V3C12.3 2.284 11.716 1.7 11 1.7C10.284 1.7 9.7 2.284 9.7 3V4.127C6.416 4.787 4 7.603 4 11V16L2 18V19H22V18L20 16H18Z" fill="#000000"></path></g></svg>',
    },
    {
      'name': 'Electricidad',
      'description': 'Pago de servicios eléctricos',
      'svg': '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"> <g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"><path d="M12 22C13.1046 22 14 21.1046 14 20H10C10 21.1046 10.8954 22 12 22ZM18 16V11C18 7.603 15.584 4.787 12.3 4.127V3C12.3 2.284 11.716 1.7 11 1.7C10.284 1.7 9.7 2.284 9.7 3V4.127C6.416 4.787 4 7.603 4 11V16L2 18V19H22V18L20 16H18Z" fill="#000000"></path></g></svg>',
    },
    {
      'name': 'Electricidad',
      'description': 'Pago de servicios eléctricos',
      'svg': '<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"> <g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"><path d="M12 22C13.1046 22 14 21.1046 14 20H10C10 21.1046 10.8954 22 12 22ZM18 16V11C18 7.603 15.584 4.787 12.3 4.127V3C12.3 2.284 11.716 1.7 11 1.7C10.284 1.7 9.7 2.284 9.7 3V4.127C6.416 4.787 4 7.603 4 11V16L2 18V19H22V18L20 16H18Z" fill="#000000"></path></g></svg>',
    },
    // Agrega aquí los otros servicios de la misma manera
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Servicios'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Búsqueda',
                prefixIcon: const Icon(Icons.search, color: primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.8, // Ajuste de aspecto para evitar desbordamiento
                ),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return ServiceCard(
                    name: service['name']!,
                    description: service['description']!,
                    svg: service['svg']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String name;
  final String description;
  final String svg;

  const ServiceCard({
    super.key,
    required this.name,
    required this.description,
    required this.svg,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Reducir el padding para evitar desbordamiento
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              name,
              style: const TextStyle(
                color: primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SvgPicture.string(svg, height: 60, color: secondaryColor), // Reducir la altura del SVG
            Text(
              description,
              style: const TextStyle(color: textColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 36, // Altura del botón ajustada
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Pagar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
