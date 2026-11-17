import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favoris_model.dart';
import '../widgets/destination_card.dart';

class FavorisScreen extends StatelessWidget {
  const FavorisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoris = context.watch<FavorisModel>().liste;

    return SafeArea(
      child: favoris.isEmpty
          ? const Center(child: Text('Aucun favori pour le moment'))
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              children: [
                Text(
                  'Mes favoris',
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                for (final destination in favoris)
                  DestinationCard(
                    key: ValueKey(destination.id),
                    destination: destination,
                  ),
              ],
            ),
    );
  }
}
