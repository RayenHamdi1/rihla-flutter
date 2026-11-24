import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/destination_card.dart';
import '../data/destinations.dart';
import '../providers/favoris_model.dart';
import '../widgets/home_header.dart';
import '../widgets/search_box.dart';
import '../widgets/hero_banner.dart';
import '../widgets/section_title.dart';
import '../models/destination.dart';
import '../providers/reglages_model.dart';
import '../services/api_service.dart';

import 'dart:ui' show PointerDeviceKind;

import 'favoris_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _categorie = 'Tout'; // l'état : la catégorie choisie
  int _onglet = 0;
  late Future<List<Destination>> _futurDestinations;

  List<Destination> _filtrer(List<Destination> toutes) => _categorie == 'Tout'
      ? toutes
      : toutes.where((d) => d.categorie == _categorie).toList();

  @override
  void initState() {
    super.initState();
    _futurDestinations = ApiService.getDestinations();
  }

  Future<void> _recharger() async {
    final futur = ApiService.getDestinations();
    setState(() {
      _futurDestinations = futur;
    });
    try {
      await futur;
    } catch (_) {}
  }

  Widget _construireExplorer() {
    return FutureBuilder<List<Destination>>(
      future: _futurDestinations,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return ErreurReseau(
            message: snapshot.error.toString(),
            onReessayer: _recharger,
          );
        }
        final destinations = snapshot.data!;
        return ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
          ),
          child: RefreshIndicator(
            onRefresh: _recharger,
            child: Column(
              children: [
                if (ApiService.depuisCache)
                  Container(
                    width: double.infinity,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.wifi_off,
                          size: 20,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Hors connexion : données enregistrées',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(child: _construireAccueil(destinations)),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final nombreFavoris = context.watch<FavorisModel>().nombre;
    final reglages = context.watch<ReglagesModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(switch (_onglet) {
          0 => 'Explorer',
          1 => 'Favoris',
          _ => 'Profil',
        }),
        actions: [
          IconButton(
            tooltip: reglages.sombre
                ? 'Activer le thème clair'
                : 'Activer le thème sombre',
            onPressed: () {
              context.read<ReglagesModel>().basculerTheme();
            },
            icon: Icon(reglages.sombre ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: _onglet == 0
          ? _construireExplorer()
          : _onglet == 1
          ? const FavorisScreen()
          : const SafeArea(child: Center(child: Text('Bientôt disponible'))),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _onglet,
        onDestinationSelected: (i) {
          setState(() {
            _onglet = i;
          });
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explorer',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: nombreFavoris > 0,
              label: Text('$nombreFavoris'),
              child: const Icon(Icons.favorite_border),
            ),
            selectedIcon: Badge(
              isLabelVisible: nombreFavoris > 0,
              label: Text('$nombreFavoris'),
              child: const Icon(Icons.favorite),
            ),
            label: 'Favoris',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _construireAccueil(List<Destination> destinations) {
    final filtrees = _filtrer(destinations);
    return SafeArea(
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        children: [
          const HomeHeader(prenom: 'Rayen'),
          const SizedBox(height: 20),
          const SearchBox(),
          const SizedBox(height: 20),
          HeroBanner(destination: destinations.first),
          const SizedBox(height: 20),
          const SectionTitle(titre: 'Catégories'),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final c in categories)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(c),
                      selected: _categorie == c,
                      onSelected: (_) {
                        setState(() {
                          _categorie = c;
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SectionTitle(titre: 'Populaires', action: 'Voir tout'),
          const SizedBox(height: 12),
          for (final d in filtrees)
            DestinationCard(key: ValueKey(d.id), destination: d),
        ],
      ),
    );
  }
}

class ErreurReseau extends StatelessWidget {
  final String message;
  final VoidCallback onReessayer;
  const ErreurReseau({
    super.key,
    required this.message,
    required this.onReessayer,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off,
              size: 56,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            const Text(
              'Vérifiez que json-server est lancé.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: onReessayer,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}

// Pourquoi late ? _futurDestinations n'a pas de valeur à sa déclaration,
// elle est affectée dans initState.
// Sans snapshot.hasError : le code ferait snapshot.data! sur null et planterait.
// Le changement de catégorie ne refait pas de requête : il filtre seulement
// la liste déjà reçue en mémoire.
