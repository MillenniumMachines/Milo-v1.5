; speed.g - Configure speed limits, acceleration and jerk.

; Configure acceleration
M201 X{global.miloAcceleration[0]} Y{global.miloAcceleration[1]} Z{global.miloAcceleration[2]}

; Configure maximum speeds
M203 X{global.miloRapidSpeed[0]} Y{global.miloRapidSpeed[1]} Z{global.miloRapidSpeed[2]}

; Configure jerk
M566 X{global.miloJerk[0]} Y{global.miloJerk[1]} Z{global.miloJerk[2]}