extends HBoxContainer

func resized():
	var w = $".".get_parent().get_parent().get_parent().size.x
	var n = $".".get_child_count()
	
	var scal = w / $".".size.x
	
	#$".".scale.x = scal
	#$".".scale.y = scal
	
	var combo_tile_width = 0
	for tile in $".".get_children():
		combo_tile_width += tile.aspect_ratio_x
	for tile in $".".get_children():
		tile.custom_minimum_size.x = tile.aspect_ratio_x * (w / combo_tile_width)
		if 1 * (w / combo_tile_width) >= w && n <= 4:
			tile.custom_minimum_size.x = tile.aspect_ratio_x * (w / (combo_tile_width / (0.4 + (0.1*n))))
