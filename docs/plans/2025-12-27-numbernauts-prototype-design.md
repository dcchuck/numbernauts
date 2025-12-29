# Numbernauts - Prototype Design

**Date:** 2025-12-27
**Version:** 1.0 - Single Level Prototype
**Inspiration:** Number Munchers (classic educational game)

## Overview

Numbernauts is a 2D educational puzzle game where players control an astronaut navigating a grid-based space environment, collecting numbers that match mathematical challenges while avoiding patrolling enemies.

## Core Concept

- **Genre:** Puzzle/Educational
- **Platform:** Godot Engine 4.x
- **Art Style:** Placeholder pixel art
- **Target:** First playable prototype with core mechanics

## Game Design

### Gameplay Loop

1. Level starts with a mathematical challenge displayed (e.g., "Collect all multiples of 3!")
2. Player moves astronaut on a grid using arrow keys
3. Player lands on planets/asteroids containing numbers
4. Collecting correct numbers removes them and adds to score
5. Enemy patrols the grid in a predictable pattern
6. Win condition: collect all correct numbers
7. Lose condition: collide with enemy or collect wrong number

### Movement System

**Grid-Based Movement:**
- 8x8 grid of spaces
- Arrow keys (or WASD) for directional input
- One keypress = one grid space moved
- Only cardinal directions (no diagonals)
- Turn-based: player moves, then enemy moves

**Collision Rules:**
- Cannot move off grid edges
- Can move through empty space
- Must land on planets to collect numbers
- Collision with enemy = game over

### Challenge System (Prototype)

**First Level Challenge:** Multiples
- Display: "Collect all multiples of 3!"
- Generate random numbers 1-50 across the grid
- Mark correct answers (3, 6, 9, 12, etc.)
- Player must collect all correct numbers to win

**Future Challenges** (not in prototype):
- Even/odd numbers
- Prime numbers
- Number ranges (e.g., "between 10 and 20")
- Mathematical operations

### Enemy Behavior

**Patrol Pattern:**
- Enemy follows predefined waypoints on the grid
- Moves one space per turn toward next waypoint
- Loops through waypoint sequence continuously
- Predictable pattern allows strategic planning

**Example Patrol:**
```
Waypoints: [2,2] → [2,6] → [6,6] → [6,2] → loop
```

## Technical Architecture

### Scene Structure

```
Main.tscn (Root - Game Manager)
├── Grid.tscn (Game board)
│   └── GridSpace.tscn (x64 instances)
├── Player.tscn (Astronaut)
├── Enemy.tscn (Patrolling enemy)
└── UI.tscn (HUD - challenge, score)
```

### Key Components

**Main Scene (Game Manager):**
- Tracks game state (playing, win, lose)
- Manages: `correct_numbers`, `collected_count`, `target_multiple`
- Handles signals: `number_collected`, `game_over`, `level_complete`
- Controls game flow and restarts

**Grid System:**
- Option 1: `TileMap` node for visual grid
- Option 2: Programmatic grid using Vector2i positions (simpler for v1)
- Grid size: 8x8 tiles
- Tile size: 64x64 pixels

**Player (Astronaut):**
- Node type: `CharacterBody2D` or `Node2D`
- Child nodes: `Sprite2D`, `CollisionShape2D` (optional)
- GDScript variables:
  ```gdscript
  var grid_position: Vector2i
  var grid_size: int = 64
  var can_move: bool = true
  ```
- Functions:
  - `_input()` - Capture arrow keys
  - `move(direction: Vector2i)` - Handle grid movement
  - `collect_number(value: int)` - Check if correct, update score
- Position calculation: `position = grid_position * grid_size`

**Enemy:**
- Similar structure to Player
- GDScript variables:
  ```gdscript
  var waypoints: Array[Vector2i]
  var current_waypoint_index: int = 0
  var grid_position: Vector2i
  ```
- Functions:
  - `move_toward_waypoint()` - Called after player moves
  - `get_next_waypoint()` - Loop through patrol route

**Number/Planet Nodes:**
- Node type: `Area2D` (detects player entry)
- Child nodes:
  - `Sprite2D` (planet/asteroid graphic)
  - `Label` (displays number)
  - `CollisionShape2D`
- Properties:
  - `number_value: int`
  - `is_correct: bool`
- Signal: `body_entered` connects to Player/Main

**UI:**
- `Label` for challenge text ("Collect multiples of 3!")
- `Label` for score/collected count
- Game over/win screens
- Restart button/prompt

### Game Flow

```
Start Level
  ↓
Generate Numbers (1-50, random positions)
  ↓
Set Challenge (multiples of 3)
  ↓
Mark Correct Numbers
  ↓
[GAME LOOP]
  ↓
Player Input → Move Player
  ↓
Check Collision (planet/enemy)
  ↓
If Planet: Collect Number → Check if Correct
  ↓
If Enemy: Game Over
  ↓
Move Enemy (patrol pattern)
  ↓
Check if All Correct Collected → Win
  ↓
[REPEAT LOOP]
```

### Input Handling

```gdscript
func _input(event):
    if event.is_action_pressed("ui_right"):
        move(Vector2i.RIGHT)
    elif event.is_action_pressed("ui_left"):
        move(Vector2i.LEFT)
    elif event.is_action_pressed("ui_up"):
        move(Vector2i.UP)
    elif event.is_action_pressed("ui_down"):
        move(Vector2i.DOWN)
```

## Visual Design

### Pixel Art Assets

**Astronaut (32x32 or 64x64):**
- Simple design: helmet, body, jetpack
- 4 directional sprites (optional for v1, can just flip)
- Clear silhouette against space background

**Planets/Asteroids (48x48 or 64x64):**
- 3-4 color variations for visual variety
- Round/irregular shapes
- Numbers overlaid in clear pixel font (white text, dark outline)

**Enemy (32x32 or 64x64):**
- Contrasting color (red/purple) to indicate danger
- Distinct from astronaut design
- Simple animation (optional: bobbing/rotating)

**Background:**
- Simple starfield or dark gradient
- Non-distracting, keeps focus on gameplay

**UI:**
- Pixel font for numbers and text
- High contrast for readability

### Visual Feedback

- **Movement:** Smooth interpolation between grid positions
- **Collection:** Brief particle effect or "pop" animation when collecting
- **Correct Number:** Subtle highlight/glow on correct planets (optional)
- **Directional Sprites:** Astronaut faces movement direction

## Audio (Optional for Prototype)

- **Collect Sound:** Simple beep/chime
- **Wrong Number:** Negative tone
- **Game Over:** Failure sound
- **Win:** Success fanfare
- **Background Music:** Optional, can add later

## Success Criteria

This prototype is complete when:

1. ✓ Astronaut moves smoothly on grid with arrow keys
2. ✓ Numbers generate correctly across grid
3. ✓ Challenge displays ("Collect multiples of 3!")
4. ✓ Collecting correct numbers works and tracks progress
5. ✓ Collecting wrong number triggers game over
6. ✓ Enemy patrols predictably along waypoints
7. ✓ Enemy collision triggers game over
8. ✓ Win condition works (all correct numbers collected)
9. ✓ Can restart after win/lose
10. ✓ Game is playable and fun for 2-3 minutes

## Future Enhancements

**Post-Prototype:**
- Multiple levels with different challenges
- Level progression and difficulty scaling
- Additional enemy types and behaviors
- Power-ups (invincibility, freeze enemies, reveal correct answers)
- More math challenge types (primes, ranges, operations)
- Menu system and settings
- High score tracking
- Sound effects and music
- Improved pixel art and animations
- Mobile touch controls

## Development Notes

**Godot Learning Focus:**
- Scene system and node hierarchy
- GDScript basics (variables, functions, signals)
- Input handling
- Position and movement in 2D
- Collision detection with Area2D
- UI and Labels
- Game state management

**Implementation Order:**
1. Set up grid and basic scene structure
2. Implement player movement
3. Add number generation and display
4. Implement collection mechanics
5. Add enemy with patrol
6. Implement win/lose conditions
7. Add UI and game state management
8. Polish and visual feedback
9. Playtesting and iteration

## Technical Constraints

- Keep it simple - focus on core mechanics
- Use Godot's built-in nodes when possible
- Avoid complex physics (grid-based is simpler)
- Placeholder art is fine for prototype
- Prioritize playability over polish

---

**Next Steps:**
1. Set up Godot project structure
2. Create detailed implementation plan
3. Build prototype following plan
4. Playtest and iterate
