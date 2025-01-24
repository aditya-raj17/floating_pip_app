import 'dart:math';

import 'package:floating/floating.dart';
import 'package:flutter/material.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final floating = Floating();
  String pipStatus = 'PipStatus.disabled';

  Future<void> enablePip(
    BuildContext context, {
    bool autoEnable = false,
  }) async {
    final rational = Rational(12, 16);
    final screenSize =
        MediaQuery.of(context).size * MediaQuery.of(context).devicePixelRatio;
    final height = screenSize.width ~/ rational.aspectRatio;

    final arguments = autoEnable
        ? OnLeavePiP(
            aspectRatio: rational,
            sourceRectHint: Rectangle<int>(
              0,
              (screenSize.height ~/ 2) - (height ~/ 2),
              screenSize.width.toInt(),
              height,
            ),
          )
        : ImmediatePiP(
            aspectRatio: rational,
            sourceRectHint: Rectangle<int>(
              0,
              (screenSize.height ~/ 2) - (height ~/ 2),
              screenSize.width.toInt(),
              height,
            ),
          );

    final status = await floating.enable(arguments);
    debugPrint('PiP enabled? $status');
    setState(() {
      pipStatus = status.toString();
    });
  }

  @override
  void dispose() {
    floating.cancelOnLeavePiP();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PiPSwitcher(
      childWhenDisabled: Scaffold(
        appBar: AppBar(
          title: const Text('Map Screen'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Image.asset('assets/image.png'),
              const SizedBox(height: 50),
              FutureBuilder<bool>(
                future: floating.isPipAvailable,
                initialData: false,
                builder: (context, snapshot) => snapshot.data ?? false
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => enablePip(context),
                            label: const Text('Enable PiP'),
                            icon: const Icon(Icons.picture_in_picture),
                          ),
                          const SizedBox(height: 12),
                          Text(pipStatus),
                          ElevatedButton.icon(
                            onPressed: () =>
                                enablePip(context, autoEnable: true),
                            label: const Text('Enable PiP on app minimize'),
                            icon: const Icon(Icons.auto_awesome),
                          ),
                        ],
                      )
                    : const Card(
                        child: Text('PiP unavailable'),
                      ),
              ),
            ],
          ),
        ),
      ),
      childWhenEnabled: // Column(
          //   children: [
          Image.asset(
        'assets/image.png',
        fit: BoxFit.fill,
      ),
      // ElevatedButton(
      //   onPressed: () {
      //     print('Button pressed');
      //   },
      //   child: Text('Button'),
      // ),
      //   ],
      // ),
    );
  }
}
