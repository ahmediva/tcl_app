import 'package:flutter/material.dart';
import '../../models/etablissement_model.dart';

class ArrondissementList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Arrondissements'),
      ),
      body: ListView.builder(
        itemCount: EtablissementModel.arrondissements.length,
        itemBuilder: (context, index) {
          final arrondissement = EtablissementModel.arrondissements[index];
          return ListTile(
            title: Text(arrondissement['libelle'] ?? ''),
            subtitle: Text('Code: ${arrondissement['code']}'),
            onTap: () {
              // Handle selection or navigation
              Navigator.pop(context, arrondissement['code']);
            },
          );
        },
      ),
    );
  }
}
