import 'package:flutter/material.dart';
import '../models/etablissement_model.dart';

class ArrondissementDropdown extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  ArrondissementDropdown({
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      onChanged: onChanged,
      items: EtablissementModel.arrondissements.map((arrondissement) {
        return DropdownMenuItem<String>(
          value: arrondissement["code"],
          child: Text('${arrondissement["code"]} - ${arrondissement["libelle"]}'),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Arrondissement - الحي',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.location_city),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez sélectionner un arrondissement';
        }
        return null;
      },
    );
  }
}
