G90 ; Absolute Travel
M83 ; Reletive Extrusion

G1 E15 F600  ;Purge through nozzle
G1 E-1 F2000  ;Retract

G91 ; Set relative
G0 Y-15 F6000 ;Wipe on silicon
G0 Y13 F6000
G0 Y-15 F6000
G0 Y13 F6000
G1 E-1 F2000  ;Retract

G90 ; Set absolute

G92 E0

