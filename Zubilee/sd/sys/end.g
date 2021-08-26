T-1

G91                          ; Relative Mode.
G1 Z2                        ; Pop Z up slightly so we don't crash while traveling over the usable bed region.
G90                          ; Absolute Mode.

G0 X10 Y10 F8000
M84