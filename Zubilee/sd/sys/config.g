; Jubilee CoreXY ToolChanging Printer - Config File
; This file intended for Duet 3 hardware, main board plus onr expansion boards

; Name and network
; This is configured from the connected Raspberry Pi or here if in stand alone
; mode
;-------------------------------------------------------------------------------
; Networking
;M550 P"Jubilee"           ; Name used in ui and for mDNS  http://Jubilee.local
;M552 P192.168.1.2 S1      ; Use Ethernet with a static IP, 0.0.0.0 for dhcp
;M553 P255.255.255.0       ; Netmask
;M554 192.168.1.1          ; Gateway


;M575 P1 S3 B57600  ;  TFT




; General setup
;-------------------------------------------------------------------------------
M111 S0                    ; Debug off 
M929 P"eventlog.txt" S1    ; Start logging to file eventlog.txt

; General Preferences
M555 P2                    ; Set Marlin-style output
G21                        ; Set dimensions to millimetres
G90                        ; Send absolute coordinates...
M83                        ; ...but relative extruder moves




; Stepper mapping
;-------------------------------------------------------------------------------
; Connected to the MB6HC as the table below.
; Note: first row is numbered left to right and second row right to left
; _________________________________
; | X(Right) | Y(Left)  | U(lock) |
; | Z(Back)  | Z(Right) | Z(Left) |

M584 X0 Y1                ; X and Y for CoreXY
M584 U2                   ; U for toolchanger lock
M584 Z3:4:5               ; Z has three drivers for kinematic bed suspension. 

M569 P0 S0                ; Drive 0 | X stepper
M569 P1 S0                ; Drive 1 | Y Stepper
M906 X{(1500*0.95)/sqrt(2)}; XY 1500mA RMS the TMC2209 driver on duet3
M906 Y{(1500*0.95)/sqrt(2)}; generates a sinusoidal coil current so we can 
                          ; divide by sqrt(2) to get peak used for M906
                          ; Do not exceed 90% without heatsinking the XY 
                          ; steppers.
                                            
M569 P2 S0                  ; Drive 2 | U Tool Changer Lock  670mA
M906 U650 I60 ; 70% of 670mA RMS idle 60%
                            ; Note that the idle will be shared for all drivers

M569 P3 S0                ; Drive 3 | Front Left Z
M569 P4 S0                ; Drive 4 | Front Right Z
M569 P5 S0                ; Drive 5 | Back Z
M906 Z650  ; 70% of 1680mA RMS

; Expansion 1
; Tool steppers on expansion board (adapt this to your own set up)
M584 E6:7:8:9:10        ; Extruders for two tools on expansion board address 1
M569 P6 S0 D2           ; Drive 6 | Extruder T0 1400mA Spreadcycle Mode
M569 P7 S0 D2			; Drive 7 | Extruder T1 1400mA Spreadcycle Mode
M569 P8 S0 D2			; Drive 8 | Extruder T1 1400mA Spreadcycle Mode
M569 P9 S0 D2			; Drive 9 | Extruder T1 1400mA Spreadcycle Mode
M569 P10 S0 D2			; Drive 10 | Extruder T1 1400mA Spreadcycle Mode

M906 E{(1500*0.95)/sqrt(2)} 
                          	; E don't support expressions in 3.2.0-beta4




; Kinematics
;-------------------------------------------------------------------------------
M669 K1                   ; CoreXY mode

; Kinematic bed ball locations.
; Locations are extracted from CAD model assuming lower left build plate corner
; is (0, 0) on a 305x305mm plate.
M671 X297.5:2.5:150 Y313.5:313.5:-16.5 S10 ; Front Left: (297.5, 313.5)
                                           ; Front Right: (2.5, 313.5)
                                           ; Back: (150, -16.5)
                                           ; Up to 10mm correction


M557 X20:280 Y20:280 P5:5


; Axis and motor configuration 
;-------------------------------------------------------------------------------

M350 X1 Y1 Z1 U1 E1:1:1:1:1  ; Disable microstepping to simplify calculations
M92 X{1/(1.8*16/180)}  ; step angle * tooth count / 180
M92 Y{1/(1.8*16/180)}  ; The 2mm tooth spacing cancel out with diam to radius
M92 Z{360/1.8/2}       ; 1.8 deg stepper / lead (2mm) of screw 
M92 U{19.19/1.8}       ; gear ration / step angle for tool lock geared motor.
M92 E26.375:26.375:26.375:26.375:26.375               ; Extruder - BMG 1.8 deg/step

; Enable microstepping all step per unit will be multiplied by the new step def
M350 X16 Y16 I1        ; 16x microstepping for CoreXY axes. Use interpolation.
M350 U4 I1             ; 4x for toolchanger lock. Use interpolation.
M350 Z16 I1            ; 16x microstepping for Z axes. Use interpolation.
M350 E16:16:16:16:16 I1         ; 16x microstepping for Extruder axes. Use interpolation.

; Speed and acceleration
;-------------------------------------------------------------------------------
M201 X1100 Y1100                        ; Accelerations (mm/s^2)
M201 Z100                               ; LDO ZZZ Acceleration
M201 U800                               ; LDO U Accelerations (mm/s^2)
M201 E1300                              ; Extruder

M203 X18000 Y18000 Z800 E8000 U9000     ; Maximum axis speeds (mm/min)
M566 X500 Y500 Z500 E3000 U50           ; Maximum jerk speeds (mm/min)



; Endstops and probes 
;-------------------------------------------------------------------------------
; Connected to the MB6HC as the table below.
; | U | Z |
; | X |
; | Y |

M574 U1 S1 P"^EI2"  ; homing position U1 = low-end, type S1 = switch
M574 X1 S1 P"^xstop"  ; homing position X1 = low-end, type S1 = switch
M574 Y1 S1 P"^ystop"  ; homing position Y1 = low-end, type S1 = switch

M574 Z0                ; we will use the switch as a Z probe not endstop 
M558 P8 C"zstop" H3 F360 T6000 ; H = dive height F probe speed T travel speed
G31 P200 X0 Y0 Z-1     ; Switch free position 7.2, Operating pos 6.4+-.2mm 
                       ; 7.2-6.2 = 1mm, set Z to worst case free position

; Set axis software limits and min/max switch-triggering positions.
; Adjusted such that (0,0) lies at the lower left corner of a 300x300mm square 
; in the 305mmx305mm build plate.
M208 X-13.75:318 Y-41:344 Z0:295
M208 U0:200            ; Set Elastic Lock (U axis) max rotation angle



; Heaters and temperature sensors
;-------------------------------------------------------------------------------

; Bed
M308 S0 P"bedtemp" Y"thermistor" T100000 B3950 A"Bed" ; Keenovo thermistor
M950 H0 C"bed" T0                  ; H = Heater 0
                                    ; C is output for heater itself
                                    ; T = Temperature sensor
M143 H0 S130                        ; Set maximum temperature for bed to 130C    
M307 H0 R0.882 C466.700:466.700 D8.00 S1.00 V0.0 B0
M140 H0                             ; Assign H0 to the bed


; Tools
; Heaters and sensors must be wired to main board for PID tuning (3.2.0-beta4)

M308 S1 P"e3temp" Y"thermistor" T100000 B4092 ;A"Heater0" ; PT100 on main board
M950 H1 C"e3heat" T1                      ; Heater for extruder out tool 0
M143 H1 S300                              ; Maximum temp for hotend to 300C
M570 H1 P15 S20
M307 H1 R3.580 C173.900:115.700 D7.80 S1.00 V24.0 B0

M308 S2 P"e4temp" Y"thermistor" T100000 B4092 ;A"Heater1" ; PT100 on main board
M950 H2 C"e4heat" T2                      ; Heater for extruder out tool 0
M143 H2 S300 								; Maximum temp for hotend to 300C
M570 H2 P15 S20
M307 H2 R3.960 C173.100:113.600 D7.10 S1.00 V24.0 B0

M308 S3 P"e5temp" Y"thermistor" T100000 B4092 ;A"Heater2" ; PT100 on main board
M950 H3 C"e5heat" T3                      ; Heater for extruder out tool 0
M143 H3 S300                              ; Maximum temp for hotend to 300C
M570 H3 P15 S20
M307 H3 R3.770 C171.200:116.600 D8.40 S1.00 V24.0 B0

M308 S4 P"e6temp" Y"thermistor" T100000 B4092 ;A"Heater3" ; PT100 on main board
M950 H4 C"e6heat" T4                      ; Heater for extruder out tool 0
M143 H4 S300                              ; Maximum temp for hotend to 300C
M570 H4 P15 S20
M307 H4 R3.725 C179.200:126.900 D7.80 S1.00 V24.0 B0

M308 S5 P"e7temp" Y"thermistor" T100000 B4092 ;A"Heater4" ; PT100 on main board
M950 H5 C"e7heat" T5                      ; Heater for extruder out tool 0
M143 H5 S300                              ; Maximum temp for hotend to 300C
M570 H5 P15 S20
M307 H5 R3.764 C177.100:126.700 D7.30 S1.00 V24.0 B0



;Wipe Servo
;-----------------------

M950 P0 C"servo0"
M42 P0 S.2

; Fans
;-------------------------------------------------------------------------------
;Heat Pins
M950 P1 C"fan_M1"

M950 P2 C"fan_M2"
							
M950 P3 C"fan_M3"
									  
M950 P4 C"fan_M4"
							
M950 P5 C"fan_M5"


; Parts Cooler  Defining one pin for use by change macros.  (not enough pins for everything in software) 10 pin max
;M950 F0 C"nil"
;M106 P0

;M950 F1 C"fan2"
;M106 P1

;M950 F2 C"fan1"
;M106 P2

;M950 F3 C"fan0"
;M106 P3

;M950 F4 C"e2heat"
;M106 P4

;M950 F5 C"e1heat"
;M106 P5




; Tool definitions
;-------------------------------------------------------------------------------
; Tool 0
M563 P0 S"Tool 0" D0 H1 F0  ; Px = Tool number
                            ; Dx = Drive Number
                            ; H1 = Heater Number
                            ; Fx = Fan number print cooling fan
G10  P0 S0 R0               ; Set tool 0 operating and standby temperatures
                            ; (-273 = "off")
M572 D0 S0.085              ; Set pressure advance


; Tool 1

M563 P1 S"Tool 1" D1 H2 F0  ; Px = Tool number
                            ; Dx = Drive Number
                            ; H1 = Heater Number
                            ; Fx = Fan number print cooling fan
G10  P1 S0 R0               ; Set tool 0 operating and standby temperatures
                            ; (-273 = "off")
M572 D1 S0.085              ; Set pressure advance


;Tool 2

M563 P2 S"Tool 2" D2 H3 F0  ; Px = Tool number
                            ; Dx = Drive Number
                            ; H1 = Heater Number
                            ; Fx = Fan number print cooling fan
G10  P2 S0 R0               ; Set tool 0 operating and standby temperatures
                            ; (-273 = "off")
M572 D2 S0.085              ; Set pressure advance


; Tool 3

M563 P3 S"Tool 3" D3 H4 F0  ; Px = Tool number
                            ; Dx = Drive Number
                            ; H1 = Heater Number
                            ; Fx = Fan number print cooling fan
G10  P3 S0 R0               ; Set tool 0 operating and standby temperatures
                            ; (-273 = "off")
M572 D3 S0.085              ; Set pressure advance


; Tool 4

M563 P4 S"Tool 4" D4 H5 F0  ; Px = Tool number
                            ; Dx = Drive Number
                            ; H1 = Heater Number
                            ; Fx = Fan number print cooling fan
G10  P4 S0 R0               ; Set tool 0 operating and standby temperatures
                            ; (-273 = "off")
M572 D4 S0.085              ; Set pressure advance




global safeYTool = 250
global safeY = 300

global parkX0 = -4
global parkY0 = 343

global parkX1 = 73
global parkY1 = 343

global parkX2 = 147
global parkY2 = 343

global parkX3 = 223
global parkY3 = 343

global parkX4 = 300
global parkY4 = 343




M98  P"/sys/Toffsets.g"     ; Set tool offsets from the bed

G31 Z0  ; Fix Z Offset


M501                        ; Load saved parameters from non-volatile memory

