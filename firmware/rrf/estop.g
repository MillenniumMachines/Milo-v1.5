; estop.g - Configure software-based emergency stop

; Configure emergency stop input if software estop is enabled.
; Not used for LDO kit as it wires the emergency stop directly
; into the PSU and VFD.

if { global.miloPins[9] != null }
    ; Configure emergency stop pin
    M950 J1 C{global.miloPins[9]}

    ; Fire trigger 0 (emergency stop) on status change
    M581 P1 T0 S1 R0

    ; Check e-stop is not active before continuing startup
    echo {"Checking Emergency Stop status..."}
    M582 T0
    echo {"Emergency Stop is not activated, continuing startup"}
