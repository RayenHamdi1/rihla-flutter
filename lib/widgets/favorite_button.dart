import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/destination.dart';
import '../providers/favoris_model.dart';

/// TP6 — Partie 2.4 : à écrire VOUS-MÊME, sans Copilot.
/// Le bouton ne mémorise plus rien : il lit l'état partagé et demande le changement.
class FavoriteButton extends StatelessWidget {
  final Destination destination;

  const FavoriteButton({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    // Le bouton se reconstruit quand le modèle signale une modification.
    final favori = context.watch<FavorisModel>().estFavori(destination);

    return IconButton(
      tooltip: favori ? 'Retirer des favoris' : 'Ajouter aux favoris',
      onPressed: () {
        final ajoute = context.read<FavorisModel>().basculer(destination);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                ajoute ? 'Ajouté aux favoris' : 'Retiré des favoris',
              ),
              duration: const Duration(seconds: 1),
            ),
          );
      },
      icon: Icon(
        favori ? Icons.favorite : Icons.favorite_border,
        color: favori ? Colors.red : null,
      ),
    );
  }
}
