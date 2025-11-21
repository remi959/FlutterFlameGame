# Requirements Tracking Document

## Planning and hosting game

- [x] A short 15-minute plan with time estimates
- [ ] A hosted working web game on github pages, provide us the url
  
## Gameplay Requirements

- [ ] The game has win and lose conditions
- [ ] The game level is replayable
- [ ] The game has placeholder art and audio assets

## Technical Requirements

- [x] The game should demonstrate a well-thought-out project structure that is scalable
- [ ] The game uses Flame effects to modify the properties/appearance of a component ([docs](https://docs.flame-engine.org/1.6.0/flame/effects.html))
- [x] The game has some form of input to change the game state
- [ ] The game has background music and some audio effects ([docs](https://docs.flame-engine.org/1.6.0/bridge_packages/flame_audio/audio.html#audio))
- [ ] The game uses some Flame particle effects ([docs](https://docs.flame-engine.org/1.6.0/flame/rendering/particles.html#particles))
- [x] The game has at least one spritesheet animation ([package](https://pub.dev/packages/flame_texturepacker))
- [ ] The game has UI that shows the game state, such as lives or points
- [x] The game has at least one decorator to change the appearance of a sprite ([docs](https://docs.flame-engine.org/1.6.0/flame/rendering/decorators.html#decorators))
- [x] The game has at least one custom space transformation (besides those the Flame engine already applies) to change the coordinate system or add an effect of sorts ([reference](https://www.brainvoyager.com/bv/doc/UsersGuide/CoordsAndTransforms/SpatialTransformationMatrices.html))

## BLOC and Design Patterns Requirements

**Apply at least three design patterns:**

- [x] Apply the state design pattern for player state ([refactoring.guru](https://refactoring.guru/design-patterns/state))
- [x] Apply the strategy design pattern for different strategies, possibly for enemies or projectiles ([refactoring.guru](https://refactoring.guru/design-patterns/strategy))
- [x] Apply the object pool design pattern to objects that are spawned in larger amounts, such as enemies or projectiles ([sourcemaking.com](https://sourcemaking.com/design_patterns/object_pool))
- [ ] Style you code according to the effective dart style guide ([dart.dev](https://dart.dev/effective-dart/style))

## Bonus Requirements

- [ ] Demonstrate that you can use Forge2D to add physics
- [x] Demonstrate that you can use Oxygen to add ECS
- [ ] Apply more design patterns
