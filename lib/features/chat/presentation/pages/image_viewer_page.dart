import 'dart:io';

import 'package:flutter/material.dart';

class ImageViewerPage extends StatefulWidget {
  final String? imageUrl;
  const ImageViewerPage({
    super.key,
    required this.imageUrl,
  });

  @override
  State<ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  final TransformationController _transformationController =
      TransformationController();
  double _currentScale = 1.0;
  final double _minScale = 1.0;

  void _handleDoubleTap(TapDownDetails details) {
    setState(() {
      if (_currentScale == _minScale) {
        // Zoom in on the tap position
        _currentScale = 2.0; // Adjust zoom level
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final Offset localPosition =
            renderBox.globalToLocal(details.globalPosition);

        // Calculate the zoom focal point
        _transformationController.value = Matrix4.identity()
          ..translate(-localPosition.dx * (_currentScale - 1),
              -localPosition.dy * (_currentScale - 1))
          ..scale(_currentScale);
      } else {
        // Reset zoom to the initial scale
        _currentScale = _minScale;
        _transformationController.value = Matrix4.identity();
      }
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: GestureDetector(
            onDoubleTapDown: _handleDoubleTap,
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: 1.0,
              maxScale: 6.0,
              child: widget.imageUrl == null
                  ? const SizedBox()
                  : widget.imageUrl!.startsWith('http')
                      ? Image.network(
                          widget.imageUrl!,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.blue,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox();
                          },
                        )
                      : Image.file(
                          File(
                            widget.imageUrl!,
                          ),
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox();
                          },
                        ),
            ),
          ),
        ),
      ),
    );
  }
}
