import 'package:flutter/material.dart';

class FechasView extends StatelessWidget {
  const FechasView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(),
          body: RefreshIndicator(
            onRefresh: () async {},
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
