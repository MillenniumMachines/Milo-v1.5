; fans.g - Configures fans

; TODO: Is Q500 appropriate?

; Configure fan port 0 and enable at startup
if { global.miloPins[7] != null }
    M950 F0 C{global.miloPins[7]} Q500
    M106 P0 S1 H-1

; Configure fan port 1 and enable at startup
if { global.miloPins[8] != null }
    M950 F1 C{global.miloPins[8]} Q500
    M106 P1 S1 H-1