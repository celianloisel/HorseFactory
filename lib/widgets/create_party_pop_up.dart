import 'package:flutter/material.dart';
import 'package:horse_factory/models/party.dart';
import 'package:horse_factory/utils/mongo_database.dart';

class CreatePartyPopUp extends StatefulWidget {
  const CreatePartyPopUp({Key? key, required this.onPartyCreated})
      : super(key: key);

  final Function() onPartyCreated;

  @override
  _CreatePartyPopUpState createState() => _CreatePartyPopUpState();
}

class _CreatePartyPopUpState extends State<CreatePartyPopUp> {
  int? _selectedValue;
  String partyName = '';
  DateTime selectedDate = DateTime.now();
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: const Text(
        'Proposer une soirée',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTextField('Nom de la soirée'),
          const SizedBox(height: 10.0),
          _buildDateField(),
          const SizedBox(height: 5.0),
          _buildPartyTypeRow(),
          if (errorMessage != null) _buildErrorCard(errorMessage!),
        ],
      ),
      actions: <Widget>[
        _buildCancelButton(),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildTextField(String label) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
      ),
      onChanged: (value) {
        setState(() {
          partyName = value;
        });
      },
    );
  }

  Widget _buildPartyTypeRow() {
    return Row(
      children: [
        const Text('Type de soirée:'),
        const SizedBox(width: 10.0),
        _buildChoiceChip('Apéro', 0),
        const SizedBox(width: 10.0),
        _buildChoiceChip('Repas', 1),
      ],
    );
  }

  Widget _buildChoiceChip(String label, int value) {
    return ChoiceChip(
      label: Text(label),
      selected: _selectedValue == value,
      selectedColor: Colors.blue,
      onSelected: (isSelected) {
        setState(() {
          _selectedValue = isSelected ? value : null;
        });
      },
    );
  }

  Widget _buildDateField() {
    return Row(
      children: [
        const Text('Date:'),
        const SizedBox(width: 10.0),
        Expanded(
          child: TextButton(
            onPressed: _selectDate,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year} ${selectedDate.hour}:${selectedDate.minute}',
                ),
                const Icon(Icons.edit, size: 20.0),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await _selectTime();

      if (pickedTime != null) {
        final DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          selectedDate = selectedDateTime;
        });
      }
    }
  }

  Future<TimeOfDay?> _selectTime() async {
    return await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }

  Widget _buildCancelButton() {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text('Annuler'),
    );
  }

  Widget _buildSubmitButton() {
    return TextButton(
      onPressed: _submitParty,
      child: const Text('Créer'),
    );
  }

  void _submitParty() {
    if (partyName.isEmpty) {
      _showErrorMessage('Veuillez entrer un nom pour la soirée');
    } else if (_selectedValue == null) {
      _showErrorMessage('Veuillez sélectionner un type de soirée');
    } else {
      final String partyType = _selectedValue == 0 ? 'Apéro' : 'Repas';
      final Party party = Party(
        name: partyName,
        type: partyType,
        dateTime: selectedDate,
        participants: [],
        comments: [],
      );

      MongoDatabase().createParty(party);

      widget.onPartyCreated();

      Navigator.of(context).pop();
    }
  }

  void _showErrorMessage(String message) {
    setState(() {
      errorMessage = message;
    });
  }

  Widget _buildErrorCard(String errorMessage) {
    return Column(
      children: [
        const SizedBox(height: 10.0),
        Card(
          color: Colors.red,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
