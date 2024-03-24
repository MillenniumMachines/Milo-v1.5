; config.g: Load modular configuration for Milo CNC Mill

; Load default variables
M98 P"vars.g"

; If user vars file exists, load it
if { fileexists("0:/sys/user-vars.g") }
    M98 P"user-vars.g"

; Configure general settings
M98 P"general.g"

; Configure optional software e-stop,
; make sure it is deactivated before
; proceeding.
M98 P"estop.g"

; Continue with configuration.
M98 P"movement.g"
M98 P"drives.g"
M98 P"speed.g"
M98 P"limits.g"
M98 P"toolsetter.g"
M98 P"touchprobe.g"
M98 P"fans.g"
M98 P"spindle.g"
M98 P"network.g"

; Load MOS
; M98 P"mos.g"