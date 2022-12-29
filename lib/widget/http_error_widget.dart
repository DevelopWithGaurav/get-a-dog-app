import 'package:flutter/material.dart';

class HttpErrorWidget extends StatelessWidget {
  const HttpErrorWidget({super.key, required this.reload});

  final Function reload;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/error.png',
            width: 150,
            height: 150,
          ),
          OutlinedButton.icon(
            onPressed: () => reload(),
            icon: const Icon(Icons.replay_outlined),
            label: const Text('Reload'),
          ),
        ],
      ),
    );
  }
}
