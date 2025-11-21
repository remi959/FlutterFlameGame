# **8-Hour Game Plan — Side-Scrolling Shooter (Flutter + Flame)**

## **Scope Summary**

The game will have:

* Player movement (left/right)
* Jump (simple gravity)
* Shooting (projectiles)
* One enemy type (walks toward player)
* Simple collisions:
  * projectile -> enemy = destroy enemy
  * enemy -> player = lose HP
* Game over screen
* Basic HUD (score + HP)
* Minimal art (colored boxes or 1 sprite each)
* No advanced physics, no tiles, no animations unless time remains

---

## **Time Budget Overview (8 hours total)**

| Phase                          | Time      | Notes                              |
| ------------------------------ | --------- | ---------------------------------- |
| 1. Setup & project skeleton    | **0.5 h** | Create project, folders, add Flame |
| 2. Player movement + jump      | **1 h**   | Basic platformer motion            |
| 3. Shooting + projectile logic | **1-2 h** | Bullet component + firing          |
| 4. Enemy creation + AI         | **1.5 h** | Simple walking enemy + spawn timer |
| 5. Collision system            | **1.5 h** | Bullet hits, player damage         |
| 6. UI (HUD + Game Over)        | **1 h**   | Score, HP, restart                 |
| 7. Polish + testing            | **1 h**   | Tuning movement, minor effects     |

### Total: **8 hours**

---

## **Detailed 8-Hour Plan**

---

### **Setup & Project Initialization**

#### Tasks

* Create project files
* Create `MyGame` class & render a blank background

#### Deliverable

A running Flame game with an empty screen.

---

### **Player Movement + Jump**

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
    * If on ground -> allow jump
* Clamp player to arena boundaries
* Optional: placeholder sprite

#### Deliverable

Player can move left/right and jump smoothly.

---

### **Shooting Mechanic**

#### Tasks

* Create `BulletComponent`
* Fire on button press
* Add bullets to game
* Move bullets horizontally
* Remove when off-screen

#### Deliverable

Player shoots visible projectiles.

---

### **Enemy System**

#### Tasks

* Create `EnemyComponent`
* Simple behavior: walk toward player
* Enemy spawner (timer every 2–3 seconds)
* Enemy dies when hit by projectile (to implement in collisions phase)

#### Deliverable

Enemies spawn and move toward player.

---

### **Collisions + Game Logic**

#### Tasks

* Add hitboxes to:

  * Player
  * Enemies
  * Projectiles
* Implement collision callbacks:

  * Projectile hits enemy -> enemy removed, score++
  * Enemy hits player -> HP--

#### Deliverable

Full gameplay loop: fight enemies and survive.

---

### **UI (HUD + Game Over)**

#### Tasks

* HUD overlay:

  * HP
  * Score
* Game Over overlay using Flame overlays:

  * "Game Over"
  * "Restart"
* Reset game state on restart

#### Deliverable

Game can be played -> died -> restarted.

---

### **Polish + Testing**

#### Tasks

* Add simple sound effects (shoot, hit)
* Add simple visuals (particle when enemy is hit)
* Improve movement feel (tune speed, gravity)

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
