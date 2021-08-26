if !move.axes[0].homed || !move.axes[1].homed
	M140 S60
	G28