; general.g - Configures general machine settings

; Enable CNC Mode
M453

; Set Machine Name
M550 P{global.miloMachineName}

; Disable heated bed
M140 H-1
