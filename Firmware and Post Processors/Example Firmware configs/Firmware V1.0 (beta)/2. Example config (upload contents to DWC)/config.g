;FIRMWARE NAME :            Millennium Milo V1.5 (STOCK)
;FIRMWARE VERSION :         RRF 3.4
;FIRMWARE CONFIG VERSION :  VERSION (BETA) v1.0
;CONTROL BOARD :            Mellow Fly CDY V3 

;This firmware has been modified by the Millennium Machines team to be used as an example config alongside a Mellow Fly CDY V3 control board
;and contains common pin maps for this board.

;===========================================================================
;============================= Getting Started =============================
;===========================================================================

;Here are some useful links that may help you get your mill setup

;DUET G-CODE DICTIONARY :                  https://docs.duet3d.com/en/User_manual/Reference/Gcodes

;PRUSA CALCULATOR FOR E-STEPS AND ACCELS : https://blog.prusa3d.com/calculator_3416/

;INSTALLING RRF ON MELLOW FLY :            https://www.youtube.com/watch?v=nhE0Txse3ZQ

;FLY E3 GENERAL INFO BY TEAMGLOOMY         https://teamgloomy.github.io/fly_cdyv3_general.html

;===========================================================================
;============================= Board Specifics =============================
;===========================================================================


;SECTION NAME / G-CODE EXPRESSION              ;DESCRIPTION                                                                               ;DEFAULT VALUES                                


; GENERAL PREFERENCES
G90                                            ; send absolute coordinates...
M550 P"Milo V1.5"                              ; set printer name
M453                                           ; set firmware to CNC Mode


; CONFIGURE NETWORK

M552 S1                                        ; enable network
M586 P0 S1                                     ; enable HTTP
M586 P1 S1                                     ; disable FTP
M586 P2 S1                                     ; disable Telnet


; CONFIGURE DRIVES

;NOTE: To change motor direction in firmware change S=0 to S=1 or vice versa

M569 P0 S0                                     ; physical drive 0 goes forwards using default driver timings                                                                             
M569 P1 S0                                     ; physical drive 1 goes forwards using default driver timings                                                                             
M569 P2 S0                                     ; physical drive 2 goes forwards using default driver timings                                                                             
M569 P3 S0                                     ; physical drive 3 goes forwards using default driver timings                                                                             
M584 X0 Y1 Z2                                  ; set drive mapping   


;===========================================================================
;============================== Motion setup ===============================
;===========================================================================
   
                          
; CONFIGURE AXES

M350 X16 Y16 Z16 I1                            ; configure microstepping with interpolation                                               (DEFAULT X16 Y16 Z16)
M92  X400 Y400 Z800.00                         ; set steps per mm                                                                         (DEFAULT X400 Y400 Z800)
M566 X600.00 Y600.00 Z400.00                   ; set maximum instantaneous speed changes (mm/min)                                         (DEFAULT X600 Y600 Z400)
M203 X3000.00 Y3000.00 Z1000.00                ; set maximum speeds (mm/min)                                                              (DEFAULT X3000 Y3000 Z3000)
M201 X800.00 Y800.00 Z400.00                   ; set accelerations (mm/s^2)                                                               (DEFAULT X800 Y800 Z400)
M906 X1200 Y1200 Z1200 I30                     ; set motor currents (mA) and motor idle factor in per cent                                (DEFAULT X1200 Y1200 Z1200 I30 )
M84 S30                                        ; Set idle timeout                                                                         (DEFAULT S30)


; CONFIGURE AXIS LIMITS

M208 X0 Y0 Z0 S1                               ; set axis minima                                                                          (DEFAULT X0 Y0 Z0 S1)
M208 X335 Y208 Z125 S0                         ; set axis maxima                                                                          (DEFAULT X335 Y208 Z125)
;M564 S0                                       ; allow movement outside axis limits                                                       (DEFAULT S0)


; CONFIGURE ENDSTOPS

M574 X1 S1 P"xstop"                            ; configure switch-type (e.g. microswitch) endstop for low end on X via pin xstop          (DEFAULT X1 S1 P"xstop")
M574 Y2 S1 P"ystop"                            ; configure switch-type (e.g. microswitch) endstop for low end on Y via pin ystop          (DEFAULT Y1 S1 P"ystop")
M574 Z2 S1 P"zstop"                            ; configure switch-type (e.g. microswitch) endstop for high end on Z via pin zstop         (DEFAULT Z2 S1 P"zstop")

; CONFIGURE BACKLASH COMPENSATION 

NOTE : backlash compensation is only available in RRF version 3.5 beta 2 so is disabled for this version of the config by default.
Upgrade to version 3.5 beta 2 should you wish to use it

;M425 X0                                        ;Set backlash compensation for the X axis                                                  (DEFAULT X0)
;M425 Y0                                        ;Set backlash compensation for the Y axis                                                  (DEFAULT Y0)
;M425 Z0                                        ;Set backlash compensation for the Z axis                                                  (DEFAULT Z0)


;===========================================================================
;============================= spindle setup ===============================
;===========================================================================


; SPINDLE

M950 R0 C"PB0+PB9" L24000                       ; Create spindle index 01, with PWM pin on heater 1 and 24000 RPM achieved at full PWM     (DEFAULT R0 C"e0heat" L24000)

; TOOL SETUP

M563 P1 S"Spindle 1" R0                        ; define tool 1 with spindle 01 
G10 P1 X0 Y0 Z0                                ; set tool 1 axis offsets


;===========================================================================
;=============================== CNC OUTPUTS ===============================
;===========================================================================


; CNC OUTPUTS

; Create custom outputs for external features such coolant sprayers, tool changers or relays you may also need to add io pins to ENABLE your spindle (Your imagination is the only limit).
; NOTE : PINS MUST BE ASSIGNED AND OUTPUTS MUST BE UNCOMMENTED BEFORE THESE FEATURES WILL WORK.

;M950 P1 C"XXXX"                               ; create io 1 on pin XXXX (TOOL CHANGER) 
;M950 P2 C"XXXX"                               ; create io 2 on pin XXXX (COOLANT)
;M950 P3 C"XXXX"                               ; create io 3 on pin XXXX (SPINDLE ENABLE) 
;M950 P4 C"XXXX"                               ; create io 4 on pin XXXX (SPINDLE DIRECTION)


;===========================================================================
;====================== MISCELLANEOUS STARTUP SETTINGS =====================
;===========================================================================
 

; Other Settings

;M575 P1 S0 B57600                             ; uncomment to enable support for Mellow fly 4.3/7.0 in touch screen 
M140 H-1								       ; Disable heated bed
M564 S1 H1 								       ; Disable jog commands when not homed
M911 S21.0 R23 P"G91 G1 Z3 F1000" 		       ; Configure power loss resume
M501									       ; Load Stored Parameters 


; initial setup

M5                                             ; STOP SPINDLE
;G28			          					   ; Home all axes on firmware startup (uncomment to enable this function)




