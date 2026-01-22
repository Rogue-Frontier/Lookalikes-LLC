class_name Emotion

var coins: Array[bool]
var size:int = 5
var level:int

func addCoin(c:bool):
	coins.push_back(c)
	onGainCoin.emit(c)
signal onGainCoin
