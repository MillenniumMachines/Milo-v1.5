; homeall.g
; Homes Z, then homes X and Y together using existing machine limits

; Relative positioning
G91

; Raise Z towards endstop at high speed
G53 G1 H1 Z{move.axes[2].max - move.axes[2].min + global.miloHomingDist} F{global.miloHomingSpeed[0]}

; Move away from Z endstop
G53 G1 H2 Z{-global.miloHomingDist}

; Repeat Z home at low speed. Do not move further than
; 2 * global.miloHomingDist above the expected endstop location.
G53 G1 H1 Z{global.miloHomingDist*2} F{global.miloHomingSpeed[1]}

; Absolute positioning
G90

; Set Z position to axis maximum
G53 G92 Z{move.axes[2].max}