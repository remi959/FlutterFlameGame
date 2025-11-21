import 'package:flame/components.dart';
import 'package:flame/rendering.dart';
import 'package:flame/effects.dart';

class CharacterAnimator extends Component with HasGameReference {
  final Vector2 characterSize;
  final String idleSpritePath;
  final String? attackAnimationPath;
  final int attackFrameCount;
  final double attackStepTime;
  final Vector2 frameSize;

  late SpriteComponent idleSprite;
  SpriteAnimationComponent? attackAnimation;
  bool _isAttacking = false;

  CharacterAnimator({
    required this.characterSize,
    required this.idleSpritePath,
    this.attackAnimationPath,
    this.attackFrameCount = 1,
    this.attackStepTime = 0.1,
    required this.frameSize,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load idle sprite
    final sprite = await game.loadSprite(idleSpritePath);
    idleSprite = SpriteComponent(
      sprite: sprite,
      size: characterSize,
      position: -characterSize / 2,
      anchor: Anchor.topLeft,
    );

    // Add shadow decorator
    idleSprite.decorator.addLast(
      Shadow3DDecorator(
        base: Vector2(0, characterSize.y), // Shadow base at character's feet
        angle: -1.4, // Angle of the light source
        xShift: 1.5, // Horizontal shift
        yScale: 1.3, // Vertical squash (makes shadow flatter)
        opacity: 1.0, // Shadow transparency
        blur: 0.5, // Shadow blur amount
      ),
    );

    add(idleSprite);

    // Load attack animation if provided
    if (attackAnimationPath != null) {
      await _loadAttackAnimation();
    }
  }

  Future<void> _loadAttackAnimation() async {
    final spriteSheet = await game.images.load(attackAnimationPath!);
    final animation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: attackFrameCount,
        stepTime: attackStepTime,
        textureSize: frameSize,
        loop: false,
      ),
    );

    attackAnimation =
        SpriteAnimationComponent(animation: animation, anchor: Anchor.center)
          ..size = characterSize
          ..position = Vector2.zero();

    // Add shadow to attack animation too
    attackAnimation!.decorator.addLast(
      Shadow3DDecorator(
        base: Vector2(0, characterSize.y / 2),
        angle: -1.4,
        xShift: 0.5,
        yScale: 0.3,
        opacity: 0.5,
        blur: 0.5,
      ),
    );

    attackAnimation!.animationTicker?.onComplete = _onAttackComplete;
  }

  void _onAttackComplete() {
    _isAttacking = false;
    attackAnimation?.removeFromParent();
    add(idleSprite);
  }

  void playAttack() {
    if (attackAnimation != null && !_isAttacking) {
      _isAttacking = true;
      idleSprite.removeFromParent();
      attackAnimation!.animationTicker?.reset();
      add(attackAnimation!);
    }
  }

  void flipHorizontally() {
    idleSprite.flipHorizontallyAroundCenter();
    attackAnimation?.flipHorizontallyAroundCenter();
  }

  void playDamageFlash({
    int flashes = 3,
    double lowOpacity = 0.3,
    double stepDuration = 0.05,
  }) {
    final target = _isAttacking ? attackAnimation : idleSprite;
    if (target == null) return;

    // Remove existing effects safely
    final existingEffects = target.children
        .whereType<SequenceEffect>()
        .toList();
    for (final effect in existingEffects) {
      effect.removeFromParent();
    }

    final effects = <Effect>[];
    for (var i = 0; i < flashes; i++) {
      effects.add(
        OpacityEffect.to(lowOpacity, EffectController(duration: stepDuration)),
      );
      effects.add(
        OpacityEffect.to(1.0, EffectController(duration: stepDuration)),
      );
    }

    target.add(SequenceEffect(effects));
  }

  bool get isAttacking => _isAttacking;
}
