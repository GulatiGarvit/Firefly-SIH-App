import 'package:flutter/material.dart';

class MyInputField extends StatefulWidget {
  final String? label;
  final Function onChanged;
  String? error;
  String? prefill;
  TextInputType? type;
  final double verticalPadding;
  final double borderRadius;
  MyInputField(
      {this.label,
      required this.onChanged,
      this.borderRadius = 16,
      this.verticalPadding = 20,
      this.error,
      this.type,
      this.prefill,
      super.key});

  @override
  State<MyInputField> createState() => _MyInputFieldState();
}

class _MyInputFieldState extends State<MyInputField> {
  final colorUnfocused = Colors.grey;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.prefill);
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14,
              height: 1.2,
              fontFamily: "Avenir"),
          decoration: InputDecoration(
            hintText: widget.label,
            hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                height: 1.2,
                fontFamily: "Avenir"),
            contentPadding: EdgeInsets.symmetric(
                vertical: widget.verticalPadding, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: colorUnfocused),
            ),
          ),
          keyboardType: widget.type ?? TextInputType.text,
          onChanged: (text) {
            widget.onChanged(text);
            setState(() {
              widget.error = null;
              widget.prefill = text;
            });
          },
        ),
        if (widget.error != null && widget.error!.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 8,
              ),
              Text(
                widget.error!,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 12,
                  height: 1.2,
                  fontFamily: "Avenir",
                ),
              ),
            ],
          )
      ],
    );
  }
}
