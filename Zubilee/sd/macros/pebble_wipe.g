G90 ; Absolute Travel
M83 ; Reletive Extrusion

M42 P0 S.2 ; Set Servo Position PreWipe

G0 Y262 F6000 ;Y Flush position 
G53 G0 X318 F6000 ; Farthest X as tool

G1 E12 F600  ;Purge through nozzle
G1 E-0.6 F2000  ;Retract

G91 ; Set relative
G0 Y-15 F6000 ;Wipe on silicon
G0 Y15 F6000
G90 ; Set absolute
M83 ; Relative Extrusion

G0 X309 Y274 F6000	; Set Up for Pebble Purge

G1 E15 F300 ;Purge to Pebble

M106 S255 ; Max Fan Speed

G4 P3000 ;Wait for 3 Seconds
G1 E-0.6 F2000  ;Retract

M42 P0 S.99; Servo Wipe

M106 S0 ; Fan Off

G4 P400	;Dwell for .2 Seconds

G0 Y262 F6000 ;Set Up for silicon Wipe Y
G53 G0 X318 F6000 ; SetUp silicon Wipe X

G91 ; Set relative
G0 Y-15 F6000 ;Wipe on silicon
G0 Y15 F6000
G90 ; Set absolute

G92 E0

