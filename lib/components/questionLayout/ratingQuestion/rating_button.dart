import 'package:flutter/material.dart';
import 'package:lucid_org/changeNotifiers/ratingBarState.dart';
import 'package:provider/provider.dart';

class RatingButton extends StatelessWidget {
  final int index;
  final bool selected;
  final bool errorDisplay;
  const RatingButton({super.key, required this.index, this.selected = true, this.errorDisplay = false});

  BoxDecoration getDecoration() {
    if (errorDisplay) {
      // No selection made red error
      return BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.red[300]!, width: 1));
    } else if (selected) {
      // Box Selected
      return BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.20), blurRadius: 4)], color: Color(0xFFFFBB40), borderRadius: BorderRadius.circular(12));
    } else {
      // Not selected
      return BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.20), blurRadius: 4)], color: Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(12));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7),
      child: GestureDetector(
        onTap: () {
          Provider.of<Ratingbarstate>(context, listen: false).setRating(index.toDouble());
        },
        child: Container(
          decoration: getDecoration(),
          height: 55,
          width: 56,
          child: Center(
            child: Text(
              index.toString(),
              style: TextStyle(color: Color(0xFF000000), fontFamily: 'Noto Sans', fontSize: 17),
            ),
          ),
        ),
      ),
    );
  }
}
