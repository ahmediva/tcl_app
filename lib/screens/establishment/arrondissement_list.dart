import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/arrondissement_provider.dart';
import '../../models/arrondissement_model.dart';

class ArrondissementList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Arrondissements'),
      ),
      body: Consumer<ArrondissementProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }

          return ListView.builder(
            itemCount: provider.arrondissements.length,
            itemBuilder: (context, index) {
              final arrondissement = provider.arrondissements[index];
              return ListTile(
                title: Text(arrondissement.libelle),
                subtitle: Text('Code: ${arrondissement.code}'),
                onTap: () {
                  // Handle selection or navigation
                },
              );
            },
          );
        },
      ),
    );
  }
}
