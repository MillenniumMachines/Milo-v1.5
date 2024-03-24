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

; Move quickly to X and Y axis endstops and stop there (first pass)
G53 G1 H1 X{-(move.axes[0].max - move.axes[0].min + global.miloHomingDist) } Y{ move.axes[1].max - move.axes[1].min + global.miloHomingDist } F{global.miloHomingSpeed[0]}

; Move away from X and Y endstops
G53 G1 H2 X{global.miloHomingDist} Y{-global.miloHomingDist}

; Repeat X and Y home at low speed. Do not move further than
; 2 * global.miloHomingDist further than the expected endstop locations.
G53 G1 H1 X{-global.miloHomingDist*2} Y{global.miloHomingDist*2} F{global.miloHomingSpeed[1]}

; Absolute positioning
G90

; Set Z position to axis maximum
G53 G92 Z{move.axes[2].max}