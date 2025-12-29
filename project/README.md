# Numbernauts

Educational puzzle game built with Godot 4.3

## Overview

Numbernauts is a grid-based puzzle game where you control an astronaut collecting numbers that match mathematical challenges while avoiding a patrolling enemy. Inspired by the classic "Number Munchers" game, Numbernauts makes learning math fun through engaging gameplay.

## How to Play

- **Objective:** Collect all multiples of 3 (green planets) to win
- **Movement:** Use arrow keys to move your astronaut one grid space at a time
- **Challenge:** Avoid the red enemy patrol - collision means game over!
- **Strategy:** Plan your path carefully - collecting wrong numbers also ends the game

### Controls

- **Arrow Keys (↑ ↓ ← →):** Move astronaut on grid
- **UI Buttons:** Restart game after win/lose

## Running the Game

### Prerequisites
- Godot 4.3 or higher

### Installation
1. Install Godot 4.3+ from [godotengine.org](https://godotengine.org/)
2. Clone or download this repository
3. Open `project.godot` in Godot Engine
4. Press **F5** to play

## Project Structure

```
project/
├── scenes/          # Godot scene files (.tscn)
│   ├── Main.tscn           # Game manager scene
│   ├── Player.tscn         # Astronaut character
│   ├── Enemy.tscn          # Patrolling enemy
│   ├── NumberPlanet.tscn   # Collectible numbers
│   └── UI.tscn             # User interface
├── scripts/         # GDScript files (.gd)
│   ├── main.gd             # Game logic and state management
│   ├── player.gd           # Player movement controller
│   ├── enemy.gd            # Enemy AI and patrol
│   ├── number_planet.gd    # Collectible logic
│   └── ui.gd               # UI controller
├── assets/          # Art and audio (placeholder)
├── project.godot    # Godot project file
└── README.md        # This file
```

## Gameplay Features

### Current Prototype (v1.0)
- **Grid System:** 8x8 grid-based movement
- **Challenge:** Collect multiples of 3
- **Smart Number Generation:** 15 random numbers (1-50) with visual color coding
  - Green planets = Correct (multiples of 3)
  - Blue planets = Wrong (avoid these!)
- **Enemy Patrol:** Predictable square patrol pattern
- **Win Condition:** Collect all correct numbers
- **Lose Conditions:**
  - Collision with enemy
  - Collecting wrong number
- **Game Loop:** Full restart functionality

### Planned Features
- Multiple levels with increasing difficulty
- Additional math challenges (primes, even/odd, ranges)
- Power-ups (invincibility, freeze enemies)
- Sound effects and music
- Improved pixel art and animations
- High score tracking
- Mobile touch controls

## Technical Details

- **Engine:** Godot 4.3
- **Language:** GDScript
- **Architecture:** Scene-based with signal-driven communication
- **Grid Size:** 8x8 (64px tiles)
- **Movement:** Smooth tween-based animations
- **Collision:** Area2D-based detection

## Development

This is a learning project built to explore:
- Godot scene system and node hierarchy
- GDScript fundamentals
- Grid-based movement systems
- Game state management
- Signal-based communication
- Educational game design

## Credits

**Design & Development:** Prototype v1.0
**Engine:** Godot Engine (godotengine.org)
**Inspiration:** Number Munchers (MECC, 1986)

## License

Educational prototype - see repository license for details.

## Version History

**v1.0 (2025-12-27)** - Initial prototype
- Core gameplay mechanics
- Single challenge type (multiples of 3)
- Enemy patrol AI
- Win/lose conditions
- Basic UI system
