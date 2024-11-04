import 'package:flutter/material.dart';

const kCardQuestionTextStyle = TextStyle(fontFamily: 'Nunito', fontSize: 21);

final kCardQuestionBoxDecoration = BoxDecoration(
  color: Colors.white,
  border: Border.all(color: Colors.black, width: 0.6, style: BorderStyle.solid),
  borderRadius: BorderRadius.circular(12),
);

final kMainContainerBoxDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(12),
  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), offset: Offset(0, 1), spreadRadius: 0.5, blurRadius: 0.5)],
);

const kH1TextStyle = TextStyle(fontFamily: 'Nunito', fontSize: 28, color: Color(0xFF2F2F2F), fontWeight: FontWeight.w500);