import 'package:flutter/material.dart';

class NumericFieldWidget extends StatefulWidget {
  const NumericFieldWidget({
    super.key,
    required this.controller,
    required this.initialValue,
    this.hintText,
    this.labelText,
  });

  final TextEditingController controller;
  final int initialValue;
  final String? labelText;
  final String? hintText;

  @override
  State<NumericFieldWidget> createState() => _NumericFieldWidgetState();
}

class _NumericFieldWidgetState extends State<NumericFieldWidget> {
  int _value = 0;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    widget.controller.text = _value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  labelText: widget.labelText,
                ),
                controller: widget.controller,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  int parsedValue = int.tryParse(value) ?? 0;
                  setState(() {
                    _value = parsedValue;
                  });
                },
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _value++;
                      widget.controller.text = _value.toString();
                    });
                  },
                  icon: const Icon(Icons.arrow_drop_up),
                ),
                IconButton(
                  onPressed: () {
                    if (_value > 0) {
                      setState(() {
                        _value--;
                        widget.controller.text = _value.toString();
                      });
                    }
                  },
                  icon: const Icon(Icons.arrow_drop_down),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
