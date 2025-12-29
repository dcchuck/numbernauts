# Mobile Viewport Design

## Overview

Adapt Numbernauts from 512x512 desktop resolution to 1080x1920 portrait resolution for mobile deployment (iOS and Android).

## Goals

- Support iPhone, iPad, and Android devices
- Maintain pixel art aesthetic with crisp rendering
- Keep existing 8x8 grid gameplay unchanged
- Prepare foundation for future mobile controls

## Target Resolution

**1080x1920 (1080p portrait)**

- Standard mobile resolution
- Portrait orientation (phones held vertically)
- Matches pixel art style with clean scaling

## Viewport Configuration

### Display Settings

```ini
[display]
window/size/viewport_width=1080
window/size/viewport_height=1920
window/size/resizable=true
window/stretch/mode="viewport"
window/stretch/aspect="keep"
```

### Rationale

- **Stretch mode "viewport"**: Renders at base resolution then scales - maintains crisp pixels for pixel art
- **Aspect "keep"**: Preserves aspect ratio with letterboxing on different screens - ensures consistent gameplay
- Works across device variations (iPhone 19.5:9, iPad 4:3, Android variants)

## Layout Design

### Screen Layout

```
┌─────────────────┐ 1080px wide
│   Top UI Area   │ 200-400px (score, level info)
├─────────────────┤
│                 │
│   8x8 Grid      │ 512x512 (centered)
│   (512x512)     │
│                 │
├─────────────────┤
│  Bottom UI/     │ 800-1000px (controls, future touch input)
│  Controls       │
└─────────────────┘
```

### Spacing

- **Horizontal margins**: 284px on each side of grid
- **Vertical space**: ~1408px available for UI above/below grid
- **Grid positioning**: Centered horizontally, positioned with room for UI

## Implementation Changes

### Files to Update

1. **project/project.godot**
   - Update viewport_width: 512 → 1080
   - Update viewport_height: 512 → 1920
   - Add stretch mode and aspect settings

2. **project/scenes/Main.tscn**
   - Camera position: (256, 256) → (540, 960)
   - Background ColorRect: 512x512 → 1080x1920
   - Position game grid within new canvas

3. **project/scenes/UI.tscn**
   - Reposition UI elements for new layout
   - Utilize top/bottom areas

### What Stays Unchanged

- 8x8 grid dimensions
- 64px tile size
- All grid coordinates and logic
- Player/enemy movement mechanics
- Game rules and collision detection

## Testing

- Run in Godot editor to verify new viewport
- Test that grid remains centered and playable
- Verify UI elements positioned correctly
- Future: Test on actual mobile devices

## Future Considerations

- Touch controls (swipe gestures or virtual buttons)
- Mobile export settings for iOS/Android
- Performance optimization for mobile devices
- Device-specific testing and adjustments
