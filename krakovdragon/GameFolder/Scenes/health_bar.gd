extends Control

@onready var fill_max = $ColorRect.size.x
var fill_amount:float

func update_healthbar(health,max_health):
	fill_amount = (float(health) / max_health) * fill_max
	$ColorRect.size.x = fill_amount

#Logic: 80 / 100 health = 0.8 * 30px = 24
