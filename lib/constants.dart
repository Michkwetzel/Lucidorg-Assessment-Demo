import 'package:flutter/material.dart';

const kCardQuestionTextStyle = TextStyle(
  fontFamily: 'Nunito',
  fontSize: 21,
  decoration: TextDecoration.none,
);

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

const kH1TextStyle = TextStyle(
  fontFamily: 'Nunito',
  fontSize: 44,
  color: Color(0xFF2F2F2F),
  fontWeight: FontWeight.w500,
  decoration: TextDecoration.none,
);

const kH2TextStyle = TextStyle(
  fontFamily: 'Nunito',
  fontSize: 28,
  color: Color(0xFF2F2F2F),
  fontWeight: FontWeight.w400,
  decoration: TextDecoration.none,
);

const kH3TextStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 28,
  color: Color(0xFF2F2F2F),
  fontWeight: FontWeight.w400,
  decoration: TextDecoration.none,
);

const kWelcomeScreenH1TextStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 44,
  color: Color(0xFFFFFFFF),
  fontWeight: FontWeight.w400,
  decoration: TextDecoration.none,
);

const kWelcomeScreenH2TextStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 24,
  color: Color(0xFFFFFFFF),
  fontWeight: FontWeight.w400,
  decoration: TextDecoration.none,
);

const kBodyTextStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 18,
  color: Color(0xFF343434),
  decoration: TextDecoration.none,
);

const kBottomModalSheetTextStyle = TextStyle(
  fontFamily: 'Nunito',
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: Color.fromARGB(255, 108, 108, 108),
  decoration: TextDecoration.none,
);

const kRatingQTextStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 22,
  color: Color(0xFF343434),
  fontWeight: FontWeight.w400,
  decoration: TextDecoration.none,
);

const kStartButtonTextStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 22,
  color: Color(0xFF343434),
  fontWeight: FontWeight.w400,
  decoration: TextDecoration.none,
);

const kRatingBarHintTextStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 17,
  color: Color(0xFF878787),
  fontWeight: FontWeight.w400,
  decoration: TextDecoration.none,
);
