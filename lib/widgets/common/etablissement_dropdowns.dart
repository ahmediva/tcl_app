import 'package:flutter/material.dart';
import '../../models/etablissement_model.dart';

class EtablissementDropdown extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final String labelText;
  final IconData icon;
  final List<Map<String, String>> options;
  final String? Function(String?)? validator;

  const EtablissementDropdown({
    Key? key,
    required this.selectedValue,
    required this.onChanged,
    required this.labelText,
    required this.icon,
    required this.options,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      onChanged: onChanged,
      items: options.map((option) {
        return DropdownMenuItem<String>(
          value: option["value"],
          child: Text(option["label"] ?? option["value"] ?? ''),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      validator: validator,
    );
  }
}

// Specific dropdown widgets for common use cases
class EtatDropdown extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const EtatDropdown({
    Key? key,
    required this.selectedValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EtablissementDropdown(
      selectedValue: selectedValue,
      onChanged: onChanged,
      labelText: 'État - الحالة',
      icon: Icons.check_circle,
      options: EtablissementModel.etatOptions,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez sélectionner un état';
        }
        return null;
      },
    );
  }
}

class RedTypePrporDropdown extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const RedTypePrporDropdown({
    Key? key,
    required this.selectedValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EtablissementDropdown(
      selectedValue: selectedValue,
      onChanged: onChanged,
      labelText: 'Type Propriétaire',
      icon: Icons.person,
      options: EtablissementModel.redTypePrporOptions,
    );
  }
}

class CatActiviteDropdown extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const CatActiviteDropdown({
    Key? key,
    required this.selectedValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EtablissementDropdown(
      selectedValue: selectedValue,
      onChanged: onChanged,
      labelText: 'Catégorie Activité',
      icon: Icons.category,
      options: EtablissementModel.artCatActiviteOptions,
    );
  }
}
