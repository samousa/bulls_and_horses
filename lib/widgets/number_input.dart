import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_theme.dart';

class NumberInput extends StatefulWidget {
  final int length;
  final Function(String) onSubmit;
  final bool enabled;

  const NumberInput({
    Key? key,
    required this.length,
    required this.onSubmit,
    this.enabled = true,
  }) : super(key: key);

  @override
  _NumberInputState createState() => _NumberInputState();
}

class _NumberInputState extends State<NumberInput> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _submitGuess() {
    final guess = _controllers.map((c) => c.text).join();
    if (guess.length == widget.length) {
      widget.onSubmit(guess);
      for (var controller in _controllers) {
        controller.clear();
      }
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.length,
            (index) => Container(
              width: 50,
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                enabled: widget.enabled,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    if (index < widget.length - 1) {
                      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                    } else {
                      _submitGuess();
                    }
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: widget.enabled ? _submitGuess : null,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Submit Guess',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}
