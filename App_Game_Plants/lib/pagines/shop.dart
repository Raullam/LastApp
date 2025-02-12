import 'package:flutter/material.dart';
import 'package:flutter_loggin/models/models.dart';
import 'package:flutter_loggin/pagines/items/water_buy_page.dart';
import 'package:flutter_loggin/provider/theme_provider.dart';
import 'package:flutter_loggin/rutes/rutes.dart';
import 'package:flutter_loggin/widgets/menu/popupmenubutton.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el usuario de los argumentos
    final Usuari? usuari =
        ModalRoute.of(context)?.settings.arguments as Usuari?;

    // Obtener el tamaño de la pantalla (ancho y alto)
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final themeProvider = Provider.of<ThemeProvider>(context);

    // Ajustar el tamaño de los iconos dinámicamente en función del tamaño de la pantalla
    double iconSize =
        screenWidth / 12; // Usamos un tamaño relativo basado en el ancho

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tienda'),
        backgroundColor: Colors.teal,
        actions: [
          widgetPopupMenyButton(usuari: usuari, themeProvider: themeProvider)
        ],
      ),
      body: SingleChildScrollView(
        // Envolvemos todo el contenido en un SingleChildScrollView
        child: Column(
          children: [
            // Sección que muestra la cantidad de BTC en grande y las siglas BTC debajo
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius:
                          BorderRadius.circular(15), // Borde redondeado
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            usuari?.btc.toStringAsFixed(2) ?? '0.00',
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'BTC',
                          style: TextStyle(fontSize: 20, color: Colors.teal),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            // Espacio entre los elementos
            const SizedBox(height: 20),

            // Grid de íconos dentro de botones, envuelto en Expanded
            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 20), // Margen a los lados
              padding: const EdgeInsets.all(
                  10), // Padding para los íconos dentro del contenedor
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 177, 106, 0), // Color de fondo
                borderRadius: BorderRadius.circular(10), // Borde redondeado
                border:
                    Border.all(color: Colors.orange, width: 2), // Borde naranja
              ),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                padding: const EdgeInsets.all(20),
                children: [
                  _buildIconButton2(
                      context, Icons.local_drink, 'Bebida', iconSize, usuari),
                  _buildIconButton2(
                      context, Icons.fastfood, 'Comida', iconSize, usuari),
                  _buildIconButton2(
                      context, Icons.security, 'Defensa', iconSize, usuari),
                  _buildIconButton(
                      context, Icons.swap_calls, 'Ataque', iconSize),
                  _buildIconButton(
                      context, Icons.shopping_cart, 'Carrito', iconSize),
                  _buildIconButton(
                      context, Icons.health_and_safety, 'Salud', iconSize),
                  _buildIconButton(context, Icons.star, 'Estrella', iconSize),
                  _buildIconButton(context, Icons.shield, 'Escudo', iconSize),
                  _buildIconButton(
                      context, Icons.attach_money, 'Dinero', iconSize),
                ],
              ),
            ),

            // Botón "Recargar BTC" abajo
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Aquí puedes agregar la lógica para recargar BTC
                },
                child: const Text('Recargar BTC'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para crear los iconos dentro de botones
  Widget _buildIconButton(
      BuildContext context, IconData icon, String label, double iconSize) {
    return ElevatedButton(
      onPressed: () {
        if (label == 'Bebida') {
          // Navegar a la página BuyWater
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BuyWaterPage(),
            ),
          );
        }
        // Aquí puedes agregar lógica para otros botones si es necesario
        print('$label button pressed');
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(iconSize / 4),
        shape: const CircleBorder(
            side: BorderSide(color: Colors.deepOrange, width: 2)),
        backgroundColor: Colors.orange,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // Método para crear los iconos dentro de botones
  Widget _buildIconButton2(BuildContext context, IconData icon, String label,
      double iconSize, Usuari? usuari) {
    return ElevatedButton(
      onPressed: () {
        if (label == 'Bebida') {
          // Navegar a la página BuyWater
          if (usuari != null) {
            Rutes.navegarBuyWater(context, usuari);
          } else {
            // Handle the case when usuari is null, if necessary
          }
        } else if (label == 'Comida' && usuari != null) {
          Rutes.navegarBuyFood(context, usuari);
        } else if (label == 'Defensa' && usuari != null) {
          Rutes.naveegarBuyDefensa(context, usuari);
        }
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(iconSize / 4),
        shape: const CircleBorder(
            side: BorderSide(color: Colors.deepOrange, width: 2)),
        backgroundColor: Colors.orange,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
