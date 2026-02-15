# Super Mario Land - Godot Project Guidelines

## Project Overview
A modernized Game Boy Super Mario Land remake built in Godot 4.5. The project implements classic platformer mechanics with a retro 160x144 viewport.

## Technology & Setup
- **Engine**: Godot 4.5 (GL Compatibility rendering)
- **Language**: GDScript with type hints
- **Viewport**: 160x144 (Game Boy resolution), scaled to 960x880
- **Main Scene**: world-1-1.tscn

## Architecture Patterns

### State Machines
Characters use enum-based state machines with state-specific physics functions:
- `mario.gd:MarioState` enum with ON_GROUND, JUMP_ASCENT, JUMP_APEX, JUMP_DESCENT, LEDGE_DESCENT, PIPE_ENTRY, DEAD
- Each state has dedicated `_physics_*()` function called from `_physics_process()`
- Transition functions like `_transition_jump_ascent()` change state and initialize physics

### Game State (Singleton)
`scripts/game_state.gd` is an autoload (GameState) managing:
- Score, lives, coins, time remaining
- Current powerup state (NONE, MUSHROOM, FLOWER)
- Signals emitted on state changes: `score_changed`, `lives_changed`, `coins_changed`, `time_changed`
- All score/life/coin updates should go through this singleton

### Physics Layers
Defined in project.godot layer_names:
1. World - Static world geometry
2. Mario - Player character
3. Blocks - Interactive blocks
4. Collectibles - Coins, powerups
5. Enemies - Enemy entities
6. Hazards - Damage zones

**When adding new elements**: Set collision/mask layers appropriately to avoid unwanted interactions.

### Animation System
- Multiple `AnimationPlayer` nodes per character (e.g., mario.gd has $MovementAnimation and $PowerupAnimation)
- Use separate animators for different animation purposes to allow concurrent animations
- Call `animator.play("animation_name")` to trigger animations

### Character Sprites
Mario has size variants managed in code:
- `$SmallSprite` and `$LargeSprite` in mario.tscn
- Both sprites have `hframes` for sprite sheet columns
- Scaling and half-width calculations account for sprite metadata
- After powerup, update `block_ray` reference to use correct collision detection

### Input Actions
Defined in project.godot:
- `move_left` / `move_right` - Arrow keys
- `jump` - A key
- `run_fire` - S key
- `start` - Enter
- `select` - Shift

## Code Conventions

### Type Hints
Use explicit return types and parameter types:
```gdscript
func grab_mushroom() -> void:
func _physics_process(delta: float) -> void:
func update_mario_pos(left: float, right: float) -> bool:
```

### Variable Naming
- `_private_vars` with underscore prefix for internal state
- `exported_vars` without underscore for inspector-exposed properties
- Use `@export` for tweakable gameplay parameters

### Signal Naming
Signals describe state changes: `score_changed`, `lives_changed`, `coins_changed`

## Key Files & Their Roles

| File | Purpose |
|------|---------|
| scripts/game_state.gd | Central game state, autoload singleton |
| scripts/mario.gd | Player character with physics state machine |
| scripts/camera.gd | Camera following system with bounds |
| scripts/block.gd | Individual block behavior (coins, powerups) |
| scripts/blocks.gd | Block grid/collection management |
| scripts/coins.gd | Collectible coins |
| scripts/hud.gd | HUD display updates |
| scenes/world-1-1.tscn | Main level scene |

## Common Tasks

### Adding a Powerup
1. Add to `GameState.Powerup` enum
2. Create scene/script in `scenes/powerups/`
3. Implement collection in character script
4. Update HUD display in `hud.gd`
5. Define behavior changes (size, abilities, etc.)

### Adding a New Block Type
1. Create scene inheriting from `block.tscn`
2. Override `on_bumped()` to define behavior
3. Emit score via `GameState.score += value`
4. Add to level in `world-1-1.tscn`

### Adding Enemies/Hazards
1. Create scene with CharacterBody2D or Area2D
2. Set collision layer to "Enemies" or "Hazards"
3. Set collision mask to collide with Mario and World
4. Implement movement and collision callbacks
5. Test collision detection with proper physics layers

## Notes for AI Assistance
- Godot 4.5 uses `@onready` for node references and `@export` for exposed properties
- Physics uses `CharacterBody2D.move_and_slide()` and `is_on_floor()` for grounded checks
- Use `RayCast2D` for directed collision checks (e.g., block bumping from below)
- Always consider the Game Boy viewport (160x144) when positioning elements
- Test that screen boundaries work correctly with `camera.update_mario_pos()`
