extends CanvasLayer


func _ready():
	$HealthBar.min_value = 0
	$HealthBar.max_value = GameManager.player_max_health
	GameManager.gained_coins.connect(update_coin_display)

	
func _process(delta):
	$HealthBar.value = GameManager.player_health
	$CoinDisplay.text = str(GameManager.coins)
	
func update_coin_display(gained_coins):
	$CoinDisplay.text = str(GameManager.coins)
