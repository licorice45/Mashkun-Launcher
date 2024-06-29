extends Window


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#var rows_container = get_tree().get_root().get_node("Launcher").rows_container
	#var genre = []
	#var publisher = []
	#var series = []
	#
	#for row in rows_container.get_children():
		#for tile in row.get_children():
			#if tile.metadata.has("tags"):
				#if tile.metadata["tags"].has("genre") && tile.metadata["tags"]["genre"] != "" && genre.has(tile.metadata["tags"]["genre"]) != true:
					#$Margin/Container/Filters/Genre/Margin/Container/Input.add_item(tile.metadata["tags"]["genre"])
					#genre.append(tile.metadata["tags"]["genre"])
				#if tile.metadata["tags"].has("publisher") && tile.metadata["tags"]["publisher"] != "" && publisher.has(tile.metadata["tags"]["publisher"]) != true:
					#$Margin/Container/Filters/Publisher/Margin/Container/Input.add_item(tile.metadata["tags"]["publisher"])
					#publisher.append(tile.metadata["tags"]["publisher"])
				#if tile.metadata["tags"].has("series") && tile.metadata["tags"]["series"] != "" && series.has(tile.metadata["tags"]["series"]) != true:
					#$Margin/Container/Filters/Series/Margin/Container/Input.add_item(tile.metadata["tags"]["series"])
					#series.append(tile.metadata["tags"]["series"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_close_requested():
	$".".queue_free()
