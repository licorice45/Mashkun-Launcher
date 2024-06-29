extends Control

var current_tile
var edit_mode

func _ready():
	if FileAccess.file_exists("user://data/") == false:
		DirAccess.make_dir_absolute("user://data/")
	DisplayServer.window_set_min_size(Vector2(1030, 500))
	reload_data()
	$Split/Preview/Container/Buttons/Menu.get_popup().id_pressed.connect(self.btn_context_id_pressed)
	$Split/TilesList/Menu/BtnAdd.get_popup().id_pressed.connect(self.btn_add_id_pressed)
	reload_settings()

func reload_settings():
	await UserSettings.load_settings()
	if UserSettings.panel_on_left == true:
		$Split.move_child($Split/Preview, 0)
	else:
		$Split.move_child($Split/Preview, 1)
	
	if UserSettings.classic_list == true:
		$Split/TilesList/Scroll.visible = false
		$Split/TilesList/ClassicList.visible = true
	else:
		$Split/TilesList/Scroll.visible = true
		$Split/TilesList/ClassicList.visible = false


func reload_data(): # Reloads all tiles and loads their metadata
	var img = Image.new()
	var imtx = ImageTexture.new()
	
	var filter = $Split/TilesList/Menu/Filter.text
	var grid_position = Vector2(-1, -1)
	var last_tile_position = Vector2(0, 0)
	
	if current_tile != null:
		last_tile_position = current_tile.grid_position
	
	for row in $Split/TilesList/Scroll/Container.get_children():
		row.queue_free()
	
	$Split/TilesList/ClassicList.clear()
	
	if FileAccess.file_exists("user://data/order.json") == false:
		var order = FileAccess.open("user://data/order.json", FileAccess.WRITE)
		order.store_line("[[]]")
		order.close()
	var order = JSON.parse_string(FileAccess.get_file_as_string("user://data/order.json"))
	var classic_position = 0
	for row_data in order:
		var hbox = HBoxContainer.new()
		hbox.add_theme_constant_override("separation", 0)
		$Split/TilesList/Scroll/Container.add_child(hbox)
		grid_position.y += 1
		grid_position.x = -1
		for tile_data in row_data:
			var metadata = JSON.parse_string(FileAccess.get_file_as_string("user://data/"+tile_data+"/metadata.json"))
			var command = JSON.parse_string(FileAccess.get_file_as_string("user://data/"+tile_data+"/command.json"))
			var tile = load("res://scenes/launcher/tile.tscn").instantiate()
			
			if FileAccess.file_exists("user://data/"+tile_data+"/metadata.json"):
				tile.metadata = metadata
			else:
				tile.metadata = {"name":"Unknown", "color": ["#1B2838", "#2C77DB", "#ffffff"]}
			if FileAccess.file_exists("user://data/"+tile_data+"/command.json"):
				tile.command = command["command"]
				tile.arguments = command["arguments"]
			else:
				tile.command = ""
			
			tile.filename = tile_data
			tile.classic_position = classic_position
			
			$Split/TilesList/ClassicList.add_item(tile.metadata["name"]) #Classic list
			
			
			var cover = "user://data/" + tile_data + "/cover.png"
			if img.load_from_file(cover) == null:
				tile.texture = load("res://assets/textures/cover.png")
				$Split/TilesList/ClassicList.set_item_icon(classic_position, load("res://assets/textures/cover.png")) #Classic list
			else:
				tile.texture = imtx.create_from_image(img.load_from_file(cover))
				$Split/TilesList/ClassicList.set_item_icon(classic_position, imtx.create_from_image(img.load_from_file(cover))) #Classic list
			
			var bg = "user://data/" + tile_data + "/bg.png"
			if img.load_from_file(bg) == null:
				tile.texture_bg = load("res://assets/textures/bg.png")
			else:
				var img_bg = img.load_from_file(bg)
				img_bg.resize(1920, 620,Image.INTERPOLATE_NEAREST)
				tile.texture_bg = imtx.create_from_image(img_bg)
			
			var title = "user://data/" + tile_data + "/title.png"
			if img.load_from_file(title) == null:
				tile.texture_title = load("res://assets/textures/title.png")
			else:
				tile.texture_title = imtx.create_from_image(img.load_from_file(title))
			
			if tile.metadata["name"].to_lower().contains(filter) == true || filter == "":
				hbox.add_child(tile)
				grid_position.x += 1
				tile.grid_position = grid_position
			else:
				$Split/TilesList/ClassicList.remove_item(classic_position) #Classic list
				classic_position += -1
			
			classic_position += 1 #Classic list
			
		resize_tiles()
	if $Split/TilesList/Scroll/Container.get_child(last_tile_position.y).get_child(last_tile_position.x) != null:
		tile_click($Split/TilesList/Scroll/Container.get_child(last_tile_position.y).get_child(last_tile_position.x))
	$Split/Preview/Container/Buttons/Launch.disabled = true
	$Split/Preview/Container/Buttons/Menu.disabled = true

func tile_click(tile):
	current_tile = tile
	print("Clicked tile at: " + str(tile.grid_position))
	
	$Split/Preview/Container/Name.text = tile.metadata["name"]
	
	for tag in $Split/Preview/Container/Data/Tags/Margin/Scroll/Container.get_children():
		tag.queue_free()
	if tile.metadata.has("tags"):
		$Split/Preview/Container/Data/Tags.visible = true
		for tag in tile.metadata["tags"]:
			if str(tile.metadata["tags"][tag]) != "":
				var tag_node = load("res://scenes/launcher/tag.tscn").instantiate()
				tag_node.get_child(0).text = tag.capitalize() + ": "
				tag_node.get_child(0).add_theme_color_override("font_color", tile.metadata["color"][1])
				tag_node.get_child(1).text = str(tile.metadata["tags"][tag])
				tag_node.get_child(1).add_theme_color_override("font_color", tile.metadata["color"][2])
				$Split/Preview/Container/Data/Tags/Margin/Scroll/Container.add_child(tag_node)
	else:
		$Split/Preview/Container/Data/Tags.visible = false
	$Split/Preview/Container/Data/Description/Margin/Container/Label.add_theme_color_override("font_color", tile.metadata["color"][1])
	var img = Image.new()
	var imtx = ImageTexture.new()
	$Split/Preview/Container/Background.texture = tile.texture_bg
	$Split/Preview/Container/Background/Title.texture = tile.texture_title
	
	if tile.metadata.has("description"):
		if tile.metadata["description"] != "":
			$Split/Preview/Container/Data/Description/Margin/Container/Scroll/Description.text = tile.metadata["description"]
		else:
			$Split/Preview/Container/Data/Description/Margin/Container/Scroll/Description.text = "No description provided"
	else:
		$Split/Preview/Container/Data/Description/Margin/Container/Scroll/Description.text = "No description provided"
	
	if tile.texture_bg == null:
		$Split/Preview/Container/Background.texture = load("res://assets/textures/bg.png")
	
	if tile.command == "":
		$Split/Preview/Container/Buttons/Launch.disabled = true
	else:
		$Split/Preview/Container/Buttons/Launch.disabled = false
	
	$Split/Preview/Container/Buttons/Menu.disabled = false
	
	reload_theme()
	save_reorder()

func reload_theme():
	if UserSettings.color_fade == true:
		get_tree().create_tween().tween_property($Background, "color", Color(current_tile.metadata["color"][0]), 0.5)
	else:
		$Background.color = Color(current_tile.metadata["color"][0])
	
	$Split/Preview/Container/Name.add_theme_color_override("font_color", current_tile.metadata["color"][2])
	$Split/Preview/Container/Data/Description/Margin/Container/Scroll/Description.add_theme_color_override("font_color", current_tile.metadata["color"][2])
	
	$Split/TilesList/ClassicList.add_theme_color_override("font_color", current_tile.metadata["color"][2])
	var color2_light = Color(current_tile.metadata["color"][2])
	color2_light.v = 1.5
	$Split/TilesList/ClassicList.add_theme_color_override("font_hovered_color", color2_light)
	
	
	var themer = load("res://assets/themes/launcher.tres")
	var stylebox = StyleBoxFlat.new()
	var stylebox_dark = StyleBoxFlat.new()
	var stylebox_light = StyleBoxFlat.new()
	
	$Split/Preview/Container/Buttons/Launch.theme = themer
	
	stylebox.bg_color = current_tile.metadata["color"][1]
	stylebox_dark.bg_color = current_tile.metadata["color"][1]
	stylebox_light.bg_color = current_tile.metadata["color"][1]
	stylebox_dark.bg_color.v = 0.8
	stylebox_light.bg_color.v = 1.2
	
	themer.set_stylebox("normal", "Button", stylebox)
	themer.set_stylebox("hover", "Button", stylebox_light)
	themer.set_stylebox("pressed", "Button", stylebox_dark)
	
	themer.set_color("font_color", "Button", current_tile.metadata["color"][0])
	themer.set_color("font_hover_color", "Button", current_tile.metadata["color"][0])
	themer.set_color("font_pressed_color", "Button", current_tile.metadata["color"][0])
	themer.set_color("font_focus_color", "Button", current_tile.metadata["color"][0])
	
	themer.set_font_size("font_size", "button", 24)
	
	var themer_corner = $Split/Preview/Container/Buttons/Launch.theme.duplicate()
	var stylebox_corner = stylebox.duplicate()
	stylebox_corner.corner_radius_top_left = 32
	var stylebox_dark_corner = stylebox_dark.duplicate()
	stylebox_dark_corner.corner_radius_top_left = 32
	var stylebox_light_corner = stylebox_light.duplicate()
	stylebox_light_corner.corner_radius_top_left = 32
	
	themer_corner.set_stylebox("normal", "Button", stylebox_corner)
	themer_corner.set_stylebox("hover", "Button", stylebox_light_corner)
	themer_corner.set_stylebox("pressed", "Button", stylebox_dark_corner)
	
	$Split/Preview/Container/Buttons/Launch.theme = themer_corner

func save_reorder():
	if edit_mode != null:
		edit_mode = null
		
		var array = []
		var n = 0
		for row in $Split/TilesList/Scroll/Container.get_children():
			array.append([])
			for tile in row.get_children():
				array[n].append(tile.filename)
			n += 1
		
		var order = FileAccess.open("user://data/order.json", FileAccess.WRITE)
		order.store_line(str(array))
		order.close()
		
		reload_data()

func resized():
	resize_tiles()
	
	if $AudioStreamPlayer.playing != true:
		$AudioStreamPlayer.stream = load("res://assets/sfx/scroll.ogg")
		$AudioStreamPlayer.play()

func resize_tiles():
	var w = $Split/TilesList.size.x
	for hbox in $Split/TilesList/Scroll/Container.get_children():
		var combo_tile_width = 0
		var n = 0
		for tile in hbox.get_children():
			combo_tile_width += tile.aspect_ratio_x
			n += 1
		
		for tile in hbox.get_children():
			tile.custom_minimum_size.x = tile.aspect_ratio_x * (w / combo_tile_width)
			if 1 * (w / combo_tile_width) >= w && n <= 3:
				tile.custom_minimum_size.x = tile.aspect_ratio_x * (w / (combo_tile_width / (0.4 + (0.1*(n + 1)))))


func _input(event):
	if Input.is_action_just_pressed("help_screen"):
		$".".add_child(load("res://scenes/dialogs/info.tscn").instantiate())
	if Input.is_action_just_pressed("refresh"):
		reload_data()



func _on_button_pressed():
	if current_tile["command"] == "steam":
		current_tile["command"] = UserSettings.windows_steam_directory
	if current_tile["command"] == "web":
		current_tile["command"] = UserSettings.web_directory
	OS.create_process(current_tile["command"], current_tile["arguments"])
	print("Attempting to launching: " + current_tile["command"] + " " + str(current_tile["arguments"]))
	$AudioStreamPlayer.stream = load("res://assets/sfx/confirmation.ogg")
	$AudioStreamPlayer.play()

func btn_context_id_pressed(id):
	match id:
		0: #Metadata
			var dialog = load("res://scenes/dialogs/metadata_editor.tscn").instantiate()
			dialog.namer = current_tile.metadata["name"]
			dialog.filename = current_tile.filename
			if current_tile.metadata.has("description"):
				dialog.description = current_tile.metadata["description"]
			if current_tile.metadata.has("tags"):
				dialog.tags = {}
				if current_tile.metadata["tags"].has("genre"):
					dialog.tags.merge({"genre": current_tile.metadata["tags"]["genre"]})
				else:
					dialog.tags.merge({"genre": ""})
				if current_tile.metadata["tags"].has("publisher"):
					dialog.tags.merge({"publisher": current_tile.metadata["tags"]["publisher"]})
				else:
					dialog.tags.merge({"publisher": ""})
				if current_tile.metadata["tags"].has("series"):
					dialog.tags.merge({"series": current_tile.metadata["tags"]["series"]})
				else:
					dialog.tags.merge({"series": ""})
				if current_tile.metadata["tags"].has("year"):
					dialog.tags.merge({"year": current_tile.metadata["tags"]["year"]})
				else:
					dialog.tags.merge({"year": 2000})
			dialog.colors = current_tile.metadata["color"]
			$".".add_child(dialog)
		1: #Launcher
			var dialog = load("res://scenes/dialogs/command_editor.tscn").instantiate()
			dialog.filename = current_tile.filename
			if current_tile.command != "":
				dialog.command = current_tile.command
				dialog.args = current_tile.arguments
			$".".add_child(dialog)
		4: #Delete Tile
			var order_read = JSON.parse_string(FileAccess.get_file_as_string("user://data/order.json"))
			order_read[current_tile.grid_position.y].remove_at(current_tile.grid_position.x)
			if order_read[current_tile.grid_position.y].is_empty() == true:
				order_read.remove_at(current_tile.grid_position.y)
			
			var order = FileAccess.open("user://data/order.json", FileAccess.WRITE)
			order.store_line(str(order_read))
			order.close()
			
			reload_data()
		5: #Edit order.json
			OS.shell_open(ProjectSettings.globalize_path("user://data/order.json"))
		6: #Open in file manager
			OS.shell_show_in_file_manager(ProjectSettings.globalize_path("user://data/" + current_tile.filename + "/"))
		7: #Move Tile
			edit_mode = current_tile

func btn_add_id_pressed(id):
	match id:
		0:
			$".".add_child(load("res://scenes/dialogs/import/new/importer.tscn").instantiate())
		1:
			$".".add_child(load("res://scenes/dialogs/import/steam/importer.tscn").instantiate())


func _on_line_edit_text_submitted(new_text):
	reload_data()


func _on_btn_settings_pressed():
	$".".add_child(load("res://scenes/settings.tscn").instantiate())


func _on_classic_list_item_selected(index):
	for row in $Split/TilesList/Scroll/Container.get_children():
		for tile in row.get_children():
			if tile.classic_position == index:
				tile_click(tile)
				var noise = $AudioStreamPlayer
				if noise.playing != true:
					noise.stream = load("res://assets/sfx/glass.ogg")
					noise.play()


func _on_btn_filter_pressed():
	$".".add_child(load("res://scenes/dialogs/filters.tscn").instantiate())
