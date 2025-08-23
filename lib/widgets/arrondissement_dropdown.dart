import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/arrondissement_provider.dart';
import '../models/arrondissement_model.dart';

class ArrondissementDropdown extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final bool showOnlyActive;

  ArrondissementDropdown({
    required this.selectedValue,
    required this.onChanged,
    this.showOnlyActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ArrondissementProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return CircularProgressIndicator();
        }

        if (provider.error != null) {
          return Text('Erreur: ${provider.error}');
        }

        final arrondissements = showOnlyActive
            ? provider.arrondissements.where((a) => a.estActif).toList()
            : provider.arrondissements;

        return DropdownButtonFormField<String>(
          value: selectedValue,
          onChanged: onChanged,
          items: arrondissements.map((ArrondissementModel arrondissement) {
            return DropdownMenuItem<String>(
              value: arrondissement.code,
              child: Text('${arrondissement.code} - ${arrondissement.libelle}'),
            );
          }).toList(),
          decoration: InputDecoration(
            labelText: 'Arrondissement',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez sélectionner un arrondissement';
            }
            return null;
          },
        );
      },
    );
  }
}
