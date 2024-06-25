extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var n = [[1,2],[1]]
	for shelves in n:
		var shelf = HBoxContainer.new()
		$Split/Shelf/Container/Background/Scroll/Shelves.add_child(shelf)
		var m = 0
		for box in n[m]:
			m += 1
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
