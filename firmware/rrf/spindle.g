; spindle.g - Configure VFD control

; Set minimum and maximum spindle RPM.
; Minimum is achieved at 0% pulse width, Maximum is at 100% pulse width.

; TODO: We need to work out a good value for Q.
M950 R0 C{ global.miloPins[5] ^ "+" ^ global.miloPins[4]} L24000 Q100
