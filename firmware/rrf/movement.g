; movement.g - Configure motion-specific parameters

; Enables segmentation of moves to allow for faster
; pauses and position reporting.

; K0 = Cartesian movement mode
; S5 = 5 segments per second, or 200ms per segment
; T0.5 = 0.5mm minimum segment length
M669 K0 S5 T0.5