import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinInput extends StatelessWidget {
  const PinInput({
    super.key,
    required this.textEditingController,
    required this.onChanged,
    required this.onCompleted,
  });

  final TextEditingController textEditingController;
  final ValueChanged<String> onChanged;
  final VoidCallback onCompleted;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Builder(
        builder: (context) {
          return PinCodeTextField(
            appContext: context,
            length: 4,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 60,
              fieldWidth: 50,
              activeFillColor: Colors.transparent,
              inactiveColor: Theme.of(context).dividerColor,
              inactiveFillColor: Colors.transparent,
              errorBorderColor: Colors.blue,
              activeColor: Theme.of(context).dividerColor,
              selectedFillColor: Colors.transparent,
            ),
            animationDuration: const Duration(milliseconds: 300),
            // backgroundColor: Colors.blue.shade50,
            enableActiveFill: true,
            backgroundColor: Colors.transparent,
            // errorAnimationController: errorController,
            controller: textEditingController,
            onCompleted: (_) => onCompleted(),
            onChanged: onChanged,
          );
        },
      ),
    );
  }
}
