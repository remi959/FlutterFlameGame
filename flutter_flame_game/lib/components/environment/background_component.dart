import 'package:flame/components.dart';
import 'package:flame/cache.dart';
import 'package:flame/extensions.dart';

class BackgroundComponent extends PositionComponent {
  final Images images;
  final String imagePath;
  final double tileWidthWorld;
  final double tileHeightWorld;

  late Sprite _sprite;

  BackgroundComponent({
    required this.images,
    required this.imagePath,
    required this.tileWidthWorld,
    required this.tileHeightWorld,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final image = await images.load(imagePath);
    _sprite = Sprite(image);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    final game = findGame()!;
    final camera = game.camera;
    
    // Get the visible world bounds from camera
    final visibleRect = camera.visibleWorldRect;
    
    // Calculate tile range to cover visible area
    final startTileX = (visibleRect.left / tileWidthWorld).floor();
    final endTileX = (visibleRect.right / tileWidthWorld).ceil();
    final startTileY = (visibleRect.top / tileHeightWorld).floor();
    final endTileY = (visibleRect.bottom / tileHeightWorld).ceil();

    // Render tiles in world coordinates
    for (int ix = startTileX; ix <= endTileX; ix++) {
      for (int iy = startTileY; iy <= endTileY; iy++) {
        final worldPos = Vector2(
          ix * tileWidthWorld,
          iy * tileHeightWorld,
        );

        _sprite.render(
          canvas,
          position: worldPos,
          size: Vector2(tileWidthWorld, tileHeightWorld),
        );
      }
    }
  }
}