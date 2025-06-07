extends CanvasLayer


func _ready():
	GameManager.gained_coins.connect(update_coin_display)
	$HealthBar.min_value = 0
	$HealthBar.max_value = GameManager.player_max_health

	
func _process(delta):
	$HealthBar.value = GameManager.player_health
	
func update_coin_display(gained_coins):
	$CoinDisplay.text = str(GameManager.coins)
