import 'package:flutter/material.dart';
import 'package:lucid_org/changeNotifiers/radioButtonsState.dart';
import 'package:lucid_org/constants.dart';
import 'package:provider/provider.dart';

class RadioButtonCard extends StatelessWidget {
  final String text;
  final String? textExtra;
  final int radioButtonIndex;

  const RadioButtonCard({super.key, required this.text, this.textExtra, required this.radioButtonIndex});

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry padding = const EdgeInsets.only(bottom: 24, left: 32, right: 32);

    if (MediaQuery.of(context).size.width > 600) {
      padding = const EdgeInsets.only(bottom: 24);
    }

    return Padding(
      padding: padding,
      child: MaterialButton(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 22),
        elevation: 0,
        onPressed: () => Provider.of<RadioButtonState>(context, listen: false).onRadioButtonSelected(radioButtonIndex),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Provider.of<RadioButtonState>(context).errorDisplay ? Colors.red[300]! : Color(0xFFCACACA)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Consumer<RadioButtonState>(
                builder: (context, radioButtonCardState, child) {
                  if (radioButtonCardState.selectedIndex == radioButtonIndex) {
                    return Icon(Icons.radio_button_checked);
                  } else {
                    return Icon(Icons.radio_button_off, color: Color(0xFF767575));
                  }
                },
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: kBodyTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
