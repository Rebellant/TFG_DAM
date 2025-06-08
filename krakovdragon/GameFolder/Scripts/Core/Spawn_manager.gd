extends Node

class_name SpawnManager

# Tres arrays, uno por nivel
var checkpoints_nivel_1: Array = []
var checkpoints_nivel_2: Array = []
var checkpoints_nivel_3: Array = []

# Variable para saber en qué nivel estás
var nivel_actual: int = 1

func registrar_checkpoint(cp: Checkpoint) -> void:
	match nivel_actual:
		1:
			if not cp in checkpoints_nivel_1:
				checkpoints_nivel_1.append(cp)
		2:
			if not cp in checkpoints_nivel_2:
				checkpoints_nivel_2.append(cp)
		3:
			if not cp in checkpoints_nivel_3:
				checkpoints_nivel_3.append(cp)

func get_ultimo_checkpoint() -> Checkpoint:
	match nivel_actual:
		1:
			return checkpoints_nivel_1.back() if checkpoints_nivel_1.size() > 0 else null
		2:
			return checkpoints_nivel_2.back() if checkpoints_nivel_2.size() > 0 else null
		3:
			return checkpoints_nivel_3.back() if checkpoints_nivel_3.size() > 0 else null
	return null
