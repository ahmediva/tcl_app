import 'package:flutter/material.dart';

class ArrondissementDropdown extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  ArrondissementDropdown({
    required this.selectedValue,
    required this.onChanged,
  });

  // Hardcoded arrondissement data from your JSON
  static const List<Map<String, String>> _arrondissements = [
    {"code": "01", "libelle": "01حي البستان_"},
    {"code": "02", "libelle": "02حي الجنان_"},
    {"code": "03", "libelle": "03حي المستشفى_"},
    {"code": "04", "libelle": "04حي القصيبة_"},
    {"code": "05", "libelle": "05الحي الشرقي_"},
    {"code": "06", "libelle": "06وسط المدينة_"},
    {"code": "07", "libelle": "07حي الرياض_"},
    {"code": "08", "libelle": "08حي الزهور_"},
    {"code": "09", "libelle": "09حي المرداس_"},
    {"code": "10", "libelle": "10حي الشاطئ_"},
    {"code": "11", "libelle": "عين قرنز"},
    {"code": "12", "libelle": "تقديمـان"},
    {"code": "13", "libelle": "الذروة"},
    {"code": "14", "libelle": "عمادة وادي الخطف معتمدية قليبية"},
    {"code": "15", "libelle": "عمادة قليبية الغربية معتمدية قليبية"},
    {"code": "16", "libelle": "بني رزين"},
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      onChanged: onChanged,
      items: _arrondissements.map((arrondissement) {
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
