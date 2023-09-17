import 'package:flutter/material.dart';

import '../Screens/choose_screen.dart';
import '../router/app_router.dart';

class BackHomeMenuWidget extends StatelessWidget {
  const BackHomeMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        AppRouter.router.pushWithReplacementFunction(const ChooseCardScreen());
      },
      itemBuilder: (BuildContext context) {
        return {
          'Back Home',
        }.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }
}
