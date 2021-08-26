M290 R0 S0                 ; Reset baby stepping
M561                       ; Disable any Mesh Bed Compensation
G0 X150 Y10 F10000
G30 P0 X150 Y10 Z-99999   ; probe near back leadscrew
G0 X280 Y280 F10000
G30 P1 X280 Y280 Z-99999   ; probe near front left leadscrew
G0 X20 Y280 F10000
G30 P2 X20 Y280 Z-99999 S3  ; probe near front right leadscrew and calibrate 3 motors
G29 S1                     ; Enable Mesh Bed Compensation
