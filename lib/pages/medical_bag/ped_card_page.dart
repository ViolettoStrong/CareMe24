import 'dart:io';
import 'package:careme24/api/api.dart';
import 'package:dio/dio.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:careme24/theme/app_style.dart';

class PetCardPage extends StatefulWidget {
  final String? animalName;
  final String? cardId;
  final String? animalType;
  final String? animalSize;
  final String? animalPhoto;

  const PetCardPage({
    super.key,
    this.animalName,
    this.cardId,
    this.animalType,
    this.animalSize,
    this.animalPhoto,
  });

  @override
  State<PetCardPage> createState() => _PetCardPageState();
}

class _PetCardPageState extends State<PetCardPage> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedType = "Кошка";
  double _petSize = 1;
  File? _selectedImage;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();

    if (widget.animalName != null) {
      _isEditing = true;
      _nameController.text = widget.animalName!;
    }
    if (widget.animalType != null) {
      _selectedType = widget.animalType!;
    }
    if (widget.animalSize != null) {
      switch (widget.animalSize) {
        case "Мелкий":
          _petSize = 0;
          break;
        case "Средний":
          _petSize = 1;
          break;
        case "Крупный":
          _petSize = 2;
          break;
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasNetworkPhoto =
        widget.animalPhoto != null && widget.animalPhoto!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? "Редактировать питомца" : "Мед карта питомца"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : hasNetworkPhoto
                          ? NetworkImage(widget.animalPhoto!)
                          : const AssetImage("assets/images/pet.png")
                              as ImageProvider,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(Icons.camera_alt, color: Colors.blue),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Введите имя питомца",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.pets),
                hintText: "Имя",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Выберите тип питомца",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTypeButton("Собака"),
                _buildTypeButton("Кошка"),
                _buildTypeButton("Птица"),
                _buildTypeButton("Грызун"),
                _buildTypeButton("Пресмыкающееся"),
                _buildTypeButton("Другое"),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Размер питомца",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Slider(
              value: _petSize,
              min: 0,
              max: 2,
              divisions: 2,
              label: _petSize == 0
                  ? "Мелкий"
                  : _petSize == 1
                      ? "Средний"
                      : "Крупный",
              activeColor: Colors.blue,
              onChanged: (value) {
                setState(() {
                  _petSize = value;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Мелкий"),
                Text("Средний"),
                Text("Крупный"),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                onPressed: _handleSubmit,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(colors: [
                      Color.fromRGBO(65, 73, 255, 1),
                      Color.fromRGBO(41, 142, 235, 1),
                    ]),
                  ),
                  child: Center(
                    child: Text(
                      _isEditing ? 'Обновить' : 'Создать',
                      style: AppStyle.txtMontserratf18w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    final name = _nameController.text.trim();
    final size = _petSize == 0
        ? "Мелкий"
        : _petSize == 1
            ? "Средний"
            : "Крупный";

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Введите имя питомца")),
      );
      return;
    }

    if (_selectedImage == null && !_isEditing) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Выберите фото питомца")),
      );
      return;
    }

    try {
      if (_isEditing) {
        /// 🔹 ԹԱՐՄԱՑՈՒՄ
        final success = await Api.updateAnimalMedCard(
          cardId: widget.cardId ?? '',
          animalName: name,
          animalType: _selectedType,
          animalSize: size,
          animalPhoto: _selectedImage,
        );

        if (success) {
          ElegantNotification.success(
            description: const Text('Данные питомца обновлены'),
          ).show(context);
          Navigator.pop(context);
        } else {
          ElegantNotification.error(
            description: const Text('Ошибка при обновлении медкарты'),
          ).show(context);
        }
      } else {
        /// 🔹 ՍՏԵՂԾՈՒՄ
        final res = await Api.addAnimalMedCard(
          animalName: name,
          animalType: _selectedType,
          animalSize: size,
          animalPhoto: _selectedImage!,
        );

        if (res != null) {
          ElegantNotification.success(
            description: const Text('Медкарта успешно добавлена'),
          ).show(context);
          Navigator.pop(context);
        } else {
          ElegantNotification.error(
            description: const Text('Ошибка при добавлении медкарты'),
          ).show(context);
        }
      }
    } catch (e) {
      ElegantNotification.error(
        description: Text('Ошибка: $e'),
      ).show(context);
    }
  }

  Widget _buildTypeButton(String type) {
    final isSelected = _selectedType == type;
    return ChoiceChip(
      label: Text(type),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _selectedType = type;
        });
      },
      selectedColor: Colors.blue.shade100,
    );
  }
}
