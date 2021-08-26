if heat.heaters[1].current >= 60
	M42 P1 S1
else
	M42 P1 S0
	
if heat.heaters[2].current >= 60
	M42 P2 S1
else
	M42 P2 S0
	
if heat.heaters[3].current >= 60
	M42 P3 S1
else
	M42 P3 S0
	
if heat.heaters[4].current >= 60
	M42 P4 S1
else
	M42 P4 S0
	
if heat.heaters[5].current >= 60
	M42 P5 S1
else
	M42 P5 S0