import 'dart:ui';

import 'package:flame/components.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

class ParallaxBackgroundComponent extends Component with HasGameReference {
  final String imagePath;
  final double parallaxFactor;
  final Vector2 imageSize;
  late Sprite _sprite;

  ParallaxBackgroundComponent({
    required this.imagePath,
    this.parallaxFactor = 0.5,
    Vector2? imageSize,
  }) : imageSize = imageSize ?? Vector2(100, 100);

  @override
  Future<void> onLoad() async {
    final image = await game.images.load(imagePath);
    _sprite = Sprite(image);
  }

  @override
  void render(Canvas canvas) {
    final camera = game.camera;
    final cameraPos = camera.viewfinder.position;

    // Create custom transformation matrix
    final matrix = vm.Matrix4.identity()

      // Custom parallax translation transformation
      // Objects further back move slower
      ..translateByDouble(
        -cameraPos.x * parallaxFactor,
        -cameraPos.y * parallaxFactor * 0.5,
        0.0,
        1.0,
      )

      // Apply scaling to cover the screen
      ..scaleByDouble(
        imageSize.x / 10,
        imageSize.y / 10,
        1.0,
        1.0,
      );

    // Apply the custom transformation matrix to the canvas
    canvas.save();
    canvas.transform(matrix.storage);

    // Render multiple copies to tile the background
    for (double x = -200; x <= 200; x += 100) {
      for (double y = -100; y <= 100; y += 100) {
        _sprite.render(
          canvas,
          position: Vector2(x, y),
          size: Vector2(100, 100),
        );
      }
    }

    canvas.restore();
  }
}