; homex.g
; Lifts Z, then homes X using existing machine limits

; Relative positioning
G91

; Raise Z towards machine limit as it is already homed
G53 G0 Z{move.axes[2].max}

; Move quickly to X axis endstop and stop there (first pass)
G53 G1 H1 X{-(move.axes[0].max - move.axes[0].min + global.miloHomingDist) } F{global.miloHomingSpeed[0]}

; Move away from X endstop
G53 G1 H2 X{global.miloHomingDist}

; Repeat X home at low speed. Do not move further than
; 2 * global.miloHomingDist further than the expected endstop location.
G53 G1 H1 X{-global.miloHomingDist*2} F{global.miloHomingSpeed[1]}

; Absolute positioning
G90