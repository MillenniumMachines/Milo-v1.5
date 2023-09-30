; resume.g
; called before a print from SD card is resumed

G1 H1 Z120 F800        ; raise the Z to the highest position
G1 R1 X0 Y0            ; go to directly above position of the last print move
G1 R1 X0 Y0 Z0         ; go back to the last print move