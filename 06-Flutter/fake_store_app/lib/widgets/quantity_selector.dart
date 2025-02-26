import 'package:flutter/material.dart';

class QuantitySelector extends StatefulWidget {
  final Function(int) onQuantityChange;

  const QuantitySelector({super.key, required this.onQuantityChange});

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.remove, size: 48),
          onPressed: () {
            setState(() {
              if (_quantity > 1) {
                _quantity--;
                widget.onQuantityChange(_quantity);
              }
            });
          },
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 60,
          child: Center(
            child: Text('$_quantity', style: const TextStyle(fontSize: 30)),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.add, size: 48),
          onPressed: () {
            setState(() {
              if (_quantity < 999) _quantity++;
              widget.onQuantityChange(_quantity);
            });
          },
        ),
      ],
    );
  }
}
