import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:stories_editor/src/utils/color/color_detection.dart';


class FileImageBG extends StatefulWidget {
  final File? filePath;
  final void Function(Color color1, Color color2) generatedGradient;
  const FileImageBG({Key? key,
    required this.filePath,
    required this.generatedGradient
  }) : super(key: key);
  @override
  _FileImageBGState createState() => _FileImageBGState();
}

class _FileImageBGState extends State<FileImageBG> {
  GlobalKey imageKey = GlobalKey();
  GlobalKey paintKey = GlobalKey();

  GlobalKey? currentKey;

  final StreamController<Color> stateController = StreamController<Color>();
  Color color1 = const Color(0xFFFFFFFF);
  Color color2 = const Color(0xFFFFFFFF);

  @override
  void initState() {
    currentKey = paintKey;
    Timer.periodic(const Duration(milliseconds: 500), (callback) async {
      if (imageKey.currentState!.context.size!.height == 0.0) {
      } else {
        var cd1 = await ColorDetection(
          currentKey: currentKey,
          paintKey: paintKey,
          stateController: stateController,
        ).searchPixel(Offset(imageKey.currentState!.context.size!.width / 2, 480));
        var cd12 = await ColorDetection(
          currentKey: currentKey,
          paintKey: paintKey,
          stateController: stateController,
        ).searchPixel(Offset(imageKey.currentState!.context.size!.width / 2.03, 530));
        color1 = cd1;
        color2 = cd12;
        setState(() {});
        widget.generatedGradient(color1, color2);
        callback.cancel();
        stateController.close();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return SizedBox(
        height: _size.height,
        width: _size.width,
        child: RepaintBoundary(
            key: paintKey,
            child: Center(
              child: Image.file(
                File(widget.filePath!.path),
                key: imageKey,
                filterQuality: FilterQuality.high,
              )
            )
        )
    );

  }
}