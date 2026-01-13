# Astronaut Player Sprite Design

**Date:** 2026-01-13
**Status:** Design Complete - Ready for Implementation
**Author:** Design session with Claude

## Overview

Replace the current dark purple square placeholder player sprite with a fully animated pixel art astronaut character featuring a rocket pack with animated flames. The sprite will support 4-directional movement (up, down, left, right) with smooth 3-frame walk/float animations.

## Current State

**Existing Implementation:**
- File: `project/scenes/Player.tscn`
- Type: `Sprite2D` with `PlaceholderTexture2D`
- Size: 48×48 pixels (base)
- Display size: ~93×93 pixels (scaled by 1.94×)
- Color: Green modulate tint (0.3, 1, 0.3, 1)

## Design Specifications

### Spritesheet Specifications

**Dimensions:**
- Total spritesheet size: 288px wide × 384px tall
- Individual frame size: 96×96 pixels
- Grid: 4 rows × 3 columns = 12 frames total
- Output format: PNG with transparency

**Layout Organization:**
```
Row 1 (Down):  [Frame 0] [Frame 1] [Frame 2]
Row 2 (Left):  [Frame 3] [Frame 4] [Frame 5]
Row 3 (Right): [Frame 6] [Frame 7] [Frame 8]
Row 4 (Up):    [Frame 9] [Frame 10] [Frame 11]
```

**Frame Animation Pattern:**
- Frame 0: Left-lean pose (one rocket flame extended)
- Frame 1: Center/neutral pose (both flames equal)
- Frame 2: Right-lean pose (opposite rocket flame extended)

This creates a gentle bobbing/floating animation when looped.

**Visual Requirements:**
- Pixel art style with crisp, sharp edges
- No anti-aliasing or blur effects
- 96×96 per frame with internal padding (~85-90px actual character)
- Visible grid lines between frames for verification
- Frame numbers labeled for easy identification
- Transparent background
- Consistent color palette across all frames (~16-20 colors max)
- Rocket pack flames: yellow-orange-red gradient

### Character Design

**Astronaut Details:**
- Classic white/light gray space suit with colored accents
- Clear round helmet showing simple friendly face
- Rocket pack mounted on back
- Chibi proportions: larger head, smaller body (cute style)
- Recognizable silhouette in all four directions

**Animation Details:**
- Subtle bobbing motion suggesting floating movement
- Rocket flames pulse/flicker between frames
- Consistent character design across all directions
- Smooth looping animation

### Art Style

- **Style:** 16-bit pixel art
- **Technique:** Pure pixel art, no anti-aliasing
- **Palette:** Limited to approximately 16-20 colors
- **Background:** Transparent (PNG alpha channel)
- **Aesthetic:** Retro game feel, clean and readable at small sizes

## AI Generation Approach

### DALL-E Optimized Prompt

```
Create a pixel art spritesheet of a cute astronaut character with a rocket pack. The image should be exactly 288 pixels wide by 384 pixels tall, organized in a strict 4x3 grid layout with visible black grid lines separating each cell. Each cell is exactly 96x96 pixels.

Grid layout with frame numbers labeled:
Row 1 (Facing DOWN): [0] [1] [2]
Row 2 (Facing LEFT): [3] [4] [5]
Row 3 (Facing RIGHT): [6] [7] [8]
Row 4 (Facing UP): [9] [10] [11]

Character design:
- Classic astronaut: white/light gray space suit with colored accents
- Clear round helmet showing a simple friendly face
- Rocket pack on back with yellow-orange-red flame effects
- Chibi proportions: larger head, smaller body (cute style)
- Each sprite fits within 96x96 pixels with small padding

Animation details:
- Each row shows a 3-frame walking/floating animation for that direction
- Frame pattern: left-lean, center, right-lean for subtle bobbing motion
- Rocket flames should pulse/flicker between frames
- Consistent pixel art style across all 12 frames

Technical requirements:
- Pure pixel art style with no anti-aliasing or blur
- Transparent background (PNG format)
- Limited color palette (approximately 16-20 colors max)
- Sharp, crisp pixel edges
- Visible grid lines between frames for verification
```

### Generation Tips

- Use DALL-E via ChatGPT Plus or OpenAI API
- Generate 2-3 variations to select the best result
- Grid lines may require 2-3 attempts to get exactly right
- If grid fails, can be added manually in post-processing
- Save output as PNG to preserve transparency

## Godot Implementation

### File Structure

```
project/
  assets/
    sprites/
      player_astronaut_spritesheet.png  (new 288×384 spritesheet)
  scenes/
    Player.tscn  (update from Sprite2D to AnimatedSprite2D)
  scripts/
    player.gd  (update sprite references and add animation logic)
```

### Implementation Steps

**1. Replace Node Type:**
- Current: `Sprite2D` node with `PlaceholderTexture2D`
- New: `AnimatedSprite2D` node with `SpriteFrames` resource

**2. Configure SpriteFrames:**
- Import spritesheet PNG into `project/assets/sprites/`
- Create new `SpriteFrames` resource in AnimatedSprite2D
- Configure spritesheet slicing:
  - Horizontal frames (columns): 3
  - Vertical frames (rows): 4
- Create 4 animations: "down", "left", "right", "up"
- Assign frames to animations:
  - "down": frames 0, 1, 2 (row 1)
  - "left": frames 3, 4, 5 (row 2)
  - "right": frames 6, 7, 8 (row 3)
  - "up": frames 9, 10, 11 (row 4)
- Set animation FPS: 6-8 (adjustable based on feel)

**3. Update Player Script:**

Changes needed in `project/scripts/player.gd`:

```gdscript
# Change references from $Sprite2D to $AnimatedSprite2D

# Add animation logic based on movement direction
func update_animation(velocity: Vector2):
    if velocity.y > 0:
        $AnimatedSprite2D.play("down")
    elif velocity.y < 0:
        $AnimatedSprite2D.play("up")
    elif velocity.x < 0:
        $AnimatedSprite2D.play("left")
    elif velocity.x > 0:
        $AnimatedSprite2D.play("right")
    # If stationary, keep playing current animation or default to "down"
```

**4. Scene Updates:**

In `project/scenes/Player.tscn`:
- Remove green color modulate (was for placeholder visibility)
- Existing scale factor (1.94) will automatically apply
- 96×96 frames will display at ~186×186 pixels in-game
- Maintain centered positioning

## Verification & Quality Control

### Visual Inspection Checklist

After AI generation, verify:

- [ ] Dimensions are exactly 288×384 pixels
- [ ] Grid lines are visible and frames are clearly separated
- [ ] All 12 frames are present and properly positioned
- [ ] Transparent background (check with checkerboard pattern)
- [ ] Consistent pixel art style (no blurry anti-aliasing)
- [ ] Astronaut is recognizable in all four directions
- [ ] Rocket flames visible and animated differently per frame
- [ ] Character fits well within each 96×96 cell with padding

### Frame Verification

1. Open spritesheet in image editor (GIMP, Photoshop, Aseprite)
2. Count frames: 3 columns × 4 rows = 12 total
3. Verify each row represents the correct direction
4. Check frame progression shows smooth animation motion

### Test Import in Godot

1. Import PNG into project
2. Create test scene with AnimatedSprite2D
3. Configure spritesheet slicing (3×4 grid)
4. Play each animation to verify frames are correct
5. Check for visual glitches or incorrect frame order
6. Test at game scale (1.94×) to verify readability

### Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| Grid lines too thick/covering sprite | Crop them out or regenerate with thinner lines |
| Frames inconsistent style | Regenerate with emphasis on "consistent pixel art style" |
| Wrong dimensions | Use image editor to resize canvas to exact 288×384 |
| No transparency | Use "remove background" tool or regenerate |
| Animation doesn't loop well | Adjust frame order or regenerate with "looping animation" |
| Astronaut too small in frame | Manually scale up in pixel art editor |
| Flames not visible enough | Increase brightness/saturation manually |

## Implementation Workflow

### Phase 1: Asset Generation (User)

1. Copy DALL-E optimized prompt to ChatGPT Plus
2. Generate 2-3 variations
3. Select best result based on checklist
4. Download as PNG
5. Verify dimensions (288×384)
6. Save as `player_astronaut_spritesheet.png`

### Phase 2: Import & Setup (Collaborative)

1. Place PNG in `project/assets/sprites/`
2. Verify Godot auto-import settings
3. Open `project/scenes/Player.tscn`
4. Replace `Sprite2D` with `AnimatedSprite2D`
5. Create and configure `SpriteFrames` resource
6. Set up 4 animations with proper frame assignments

### Phase 3: Script Updates (Collaborative)

1. Modify `project/scripts/player.gd`
2. Update sprite node references
3. Add animation direction logic
4. Remove placeholder modulate color
5. Test movement in all 4 directions

### Phase 4: Testing & Polish

1. Run game and test movement
2. Verify animations play correctly
3. Check scaling looks good at 1.94×
4. Adjust animation FPS if needed (6-8 recommended)
5. Fine-tune any visual issues

## Fallback Options

If AI generation doesn't meet requirements:

1. **Manual touch-up:** Import AI result into Aseprite and manually fix frames
2. **Pre-made assets:** Search itch.io for "astronaut spritesheet pixel art" and adapt
3. **Simplified version:** Generate 4 static directional sprites first, add animation later
4. **Different AI tool:** Try Midjourney or Leonardo.ai with adjusted prompt
5. **Commission artist:** Find pixel artist on Fiverr or itch.io for custom sprite

## Future Enhancements

Post-implementation polish opportunities:

- Add idle animations (gentle bobbing when stationary)
- Add particle effects for extra rocket trail sparkles
- Create directional boost/dash animation
- Adjust sprite colors to match game's palette better
- Create alternate suit color variants
- Add special animations (victory pose, damage reaction)
- Implement smoother directional transitions

## Success Criteria

The implementation will be considered complete when:

- [ ] Astronaut sprite replaces placeholder in all game modes
- [ ] Smooth 3-frame animations play in all 4 directions
- [ ] Rocket pack flames are visible and animated
- [ ] AnimatedSprite2D properly configured in Godot
- [ ] No visual glitches or animation artifacts
- [ ] Sprite scales correctly and looks good at game resolution
- [ ] Character is easily recognizable as an astronaut
- [ ] Animation feels smooth and natural at chosen FPS

## Technical Notes

**Scaling Behavior:**
- Base sprite: 96×96 pixels
- Scale factor: 1.94 (from `main.gd`)
- Display size: ~186×186 pixels
- Total spritesheet: 288×384 → displays as 559×746 in memory

**Performance:**
- AnimatedSprite2D is optimized for spritesheets
- 12 frames at 96×96 = minimal memory footprint
- No performance concerns for single player sprite

**Compatibility:**
- Godot 4.x AnimatedSprite2D node
- PNG with alpha transparency
- Standard spritesheet grid format
- No special shaders or effects required

## References

- Current player scene: `project/scenes/Player.tscn`
- Player script: `project/scripts/player.gd`
- Main game config: `project/scripts/main.gd`
- SPRITE_SCALE constant: 1.94 (124/64 tile size ratio)
