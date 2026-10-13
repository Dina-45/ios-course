import 'package:flutter/material.dart';
import '../models/dog.dart';
import '../theme/app_colors.dart';
import '../widgets/dog_image.dart';

class DogDetailsScreen extends StatefulWidget {
  final Dog dog;
  const DogDetailsScreen({super.key, required this.dog});

  @override
  State<DogDetailsScreen> createState() => _DogDetailsScreenState();
}

class _DogDetailsScreenState extends State<DogDetailsScreen> {
  static const _slots = ['10:00', '13:30', '17:00'];
  String? _selectedSlot;
  bool _booked = false;

  void _bookWalk() {
    setState(() => _booked = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Walk with ${widget.dog.name} booked for $_selectedSlot! '
            'Staff will confirm your visit at the shelter.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dog = widget.dog;
    final imageHeight = MediaQuery.of(context).size.height * 0.38;

    String buttonText;
    if (_booked) {
      buttonText = 'Walk booked at $_selectedSlot';
    } else if (_selectedSlot == null) {
      buttonText = 'Choose a time';
    } else {
      buttonText = 'Book a Walk at $_selectedSlot';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(dog.name,
            style: const TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(32)),
                        child: DogImage(
                          dog: dog,
                          width: double.infinity,
                          height: imageHeight,
                          iconSize: 80,
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.lime,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(dog.age,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.navy)),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(dog.name,
                            style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: AppColors.navy)),
                        Text('${dog.breed} · ${dog.age} · Energy: ${dog.energy}',
                            style: const TextStyle(color: Colors.black54)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: dog.tags
                              .map((t) => Chip(
                                    label: Text(t),
                                    backgroundColor: Colors.white,
                                    side: BorderSide.none,
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 12),
                        Text(dog.description,
                            style: const TextStyle(height: 1.4)),
                        const SizedBox(height: 20),
                        const Text('Good to know',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.navy)),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('• One dog per day'),
                              SizedBox(height: 4),
                              Text('• Staff approval required before the walk'),
                              SizedBox(height: 4),
                              Text('• Walks only near the shelter'),
                              SizedBox(height: 4),
                              Text('• Pick up and return the dog at the shelter'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text('Available today',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.navy)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _slots.map((slot) {
                            final selected = slot == _selectedSlot;
                            return GestureDetector(
                              onTap: _booked
                                  ? null
                                  : () => setState(() => _selectedSlot = slot),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 12),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? AppColors.navy
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Text(slot,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: selected
                                            ? Colors.white
                                            : AppColors.navy)),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Back to list'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: AppColors.lime,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28)),
                  ),
                  onPressed:
                      (_selectedSlot == null || _booked) ? null : _bookWalk,
                  child: Text(buttonText,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 16)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}