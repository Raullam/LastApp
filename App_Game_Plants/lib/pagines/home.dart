import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_loggin/models/usuari.dart';
import 'package:flutter_loggin/provider/crypto_provider.dart';
import 'package:flutter_loggin/rutes/rutes.dart';
import 'package:flutter_loggin/widgets/card_swiper.dart';
import 'package:flutter_loggin/widgets/menu/popupmenubutton.dart';
import 'package:provider/provider.dart';
import 'package:flutter_loggin/provider/theme_provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el usuario de los argumentos
    final Usuari? usuari =
        ModalRoute.of(context)?.settings.arguments as Usuari?;
    final provider = Provider.of<CryptoProvider>(context);

    // Acceso directo al ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Oculta la flecha de "atrás"
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.black, fontFamily: 'RiverAdventurer'),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF00C4B4),
        actions: [
          // Menu desplegable a l'imatge d'usuari
          widgetPopupMenyButton(usuari: usuari, themeProvider: themeProvider)
        ],
      ),
      body: Center(
        child: usuari == null
            ? Text(
                'No se encontró el usuario',
                style: TextStyle(
                  color: themeProvider
                      .textColor, // Usamos el color de texto dinámico
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CardSwiper(cryptos: provider.cryptos),
                ],
              ),
      ),
      backgroundColor:
          themeProvider.backgroundColor, // Usamos el color de fondo dinámico
    );
  }
}
