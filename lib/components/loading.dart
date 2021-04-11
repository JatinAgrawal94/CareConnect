// loading widget for all screens

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingHeart extends StatelessWidget {
  const LoadingHeart({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SpinKitWave(
          color: Colors.blue[400],
          size: 50,
        ),
      ),
    );
  }
}
