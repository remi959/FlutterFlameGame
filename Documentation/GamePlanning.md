# **8-Hour Game Plan — Side-Scrolling Arena Shooter (Flutter + Flame)**

## **Scope Summary (Small but Complete)**

The game will have:

* Player movement (left/right)
* Jump (simple gravity)
* Shooting (projectiles)
* One enemy type (walks toward player)
* Simple collisions:

  * projectile → enemy = destroy enemy
  * enemy → player = lose HP
* Game over screen
* Basic HUD (score + HP)
* Minimal art (colored boxes or 1 sprite each)
* No advanced physics, no tiles, no animations unless time remains

---

## **Time Budget Overview (8 hours total)**

| Phase                          | Time      | Notes                              |
| ------------------------------ | --------- | ---------------------------------- |
| 1. Setup & project skeleton    | **0.5 h** | Create project, folders, add Flame |
| 2. Player movement + jump      | **1.5 h** | Basic platformer motion            |
| 3. Shooting + projectile logic | **1 h**   | Bullet component + firing          |
| 4. Enemy creation + AI         | **1.5 h** | Simple walking enemy + spawn timer |
| 5. Collision system            | **1.5 h** | Bullet hits, player damage         |
| 6. UI (HUD + Game Over)        | **1 h**   | Score, HP, restart                 |
| 7. Polish + testing            | **1 h**   | Tuning movement, minor effects     |

### Total: **8 hours**

This schedule is aggressive but realistic *if you keep assets simple*.

---

## **Detailed 8-Hour Plan**

---

### **Hour 0.0 – 0.5 → Setup & Project Initialization (30 min)**

#### Tasks

* `flutter create`
* Add Flame + audio deps to `pubspec.yaml`
* Create folder structure:

  ```
  lib/
    game/
    components/
    ui/
  assets/
  ```

* Add basic assets (colored squares or 1 sprite for player/enemy)
* Create `MyGame` class & render a blank background

#### Deliverable

A running Flame game with an empty screen.

---

### **Hour 0.5 – 2.0 → Player Movement + Jump (1.5 hours)**

#### Tasks

* Create `PlayerComponent`
* Properties:

  * position
  * velocity
  * speed
  * gravity
* Implement:

  * Left/right movement (buttons or keyboard)
  * Jump:

    * `velocity.y += gravity * dt`
    * If on ground → allow jump
* Clamp player to arena boundaries
* Optional if time: placeholder sprite

#### Deliverable

Player can move left/right and jump smoothly.

---

### **Hour 2.0 – 3.0 → Shooting Mechanic (1 hour)**

#### Tasks

* Create `ProjectileComponent`
* Fire on button press
* Add bullets to game
* Move bullets horizontally
* Remove when off-screen

#### Deliverable

Player shoots visible projectiles.

---

### **Hour 3.0 – 4.5 → Enemy System (1.5 hours)**

#### Tasks

* Create `EnemyComponent`
* Simple behavior: walk toward player
* Enemy spawner (timer every 2–3 seconds)
* Enemy dies when hit by projectile (to implement in collisions phase)

#### Deliverable

Enemies spawn and move toward player.

---

### **Hour 4.5 – 6.0 → Collisions + Game Logic (1.5 hours)**

#### Tasks

* Add hitboxes to:

  * Player
  * Enemies
  * Projectiles
* Implement collision callbacks:

  * Projectile hits enemy → enemy removed, score++
  * Enemy hits player → HP--

#### Deliverable

Full gameplay loop: fight enemies and survive.

---

### **Hour 6.0 – 7.0 → UI (HUD + Game Over) (1 hour)**

#### Tasks

* HUD overlay:

  * HP
  * Score
* Game Over overlay using Flame overlays:

  * "Game Over"
  * "Restart"
* Reset game state on restart

#### Deliverable

Game can be played → died → restarted.

---

### **Hour 7.0 – 8.0 → Polish + Testing (1 hour)**

#### Optional polish in this hour

* Add simple sound effects (shoot, hit)
* Add simple visuals (particle when enemy dies)
* Improve movement feel (tune speed, gravity)
* Add splash screen or simple main menu
* Fix collision edge cases

#### Deliverable

Fully playable and stable 8-hour prototype.

---

## Final Scope Result After 8 Hours

A fully functional micro-game:

* Side-scrolling movement
* Jumping with gravity
* Shooting projectiles
* Enemies spawning and chasing
* Enemy death logic
* Player HP + score system
* Game over → restart flow
* Basic UI overlays
* Minimal but functional visual polish
