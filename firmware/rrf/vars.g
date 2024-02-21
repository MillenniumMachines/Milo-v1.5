; vars.g - Global variables used to configure the RRF firmware for Milo.

; Machine name. Used in the web interface to identify the machine.
global miloMachineName = "Millennium Machines Milo"

; Password for Duet Web Control
global miloUIPassword = "rrf"

; Set WiFi Mode. Set to true to enable AP mode, default
; is client mode.
global miloAPMode = false

; Machine speed limits in mm/min for X, Y and Z axes.
global miloRapidSpeed = { 2000, 2000, 1200 }

; Machine acceleration in mm/sec^2 for X, Y and Z axes.
; Note that this is in mm/sec^2, not mm/min^2 like the other
; speed settings! This is an RRF peculiarity.
global miloAcceleration = { 600, 600, 400 }

; Machine jerk (allowable instantaneous speed change)
; in mm/min for X, Y and Z axes.
global miloJerk = { 400, 400, 200 }

; Homing speed limit in mm/min. The first value is an initial speed,
; used to find the rough location of the endstop, and the second
; value is a slower speed used to home more accurately.
global miloHomingSpeed = { 1200, 180 }

; Homing distance - the distance in millimeters to back-off after
; activating each endstop, before repeating the homing operation
; at a lower speed.
global miloHomingDist = 5

; Pin names for defining the board functionality in the following order:
; X endstop
; Y endstop
; Z endstop
; Toolsetter
; Spindle Enable
; Spindle Speed (PWM)
; Touch Probe (Unset)
; Fan 0
; Fan 1
; Software E-Stop - (Unset - not used by LDO kit as the E-Stop kills all power)
global miloPins = { "xmin", "ymin", "zmin", "zmax", "Laser", "Neopixel", null, "fan0", "fan1", null }