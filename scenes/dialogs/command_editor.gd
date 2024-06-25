extends Window
var command = ""
var args = [""]
var filename = ""

func _on_close_requested():
	$".".queue_free()

func _on_btn_option_item_selected(index):
	$Margin/Container/Directory.visible = false
	$Margin/Container/AdvancedCommand.visible = false
	$Margin/Container/Steam.visible = false
	
	match index:
		1:
			$Margin/Container/Directory.visible = true
			
			$Margin/Container/Directory/Margin/Container/Input/Label.text = command
			$Margin/Container/Directory/Margin/Container/Args.text = parse_args_to_str()
		2:
			$Margin/Container/AdvancedCommand.visible = true
			
			$Margin/Container/AdvancedCommand/Margin/Container/Label.text = command
			$Margin/Container/AdvancedCommand/Margin/Container/Args.text = parse_args_to_str()
		3:
			$Margin/Container/Steam.visible = true
			
			$Margin/Container/Steam/Margin/Container/SteamGame.text = args[1]

func  parse_args_to_str():
	var result = ""
	for arg in args:
		result = result + " " + arg
	result = result.lstrip(" ")
	return result


func _on_command_changed(new_text):
	command = new_text
	print("New Command: " + command)


func _on_args_changed(new_text):
	args = new_text.split(" ")
	print("New Args: " + str(args))


func _on_btn_dialog_pressed():
	$FileDialog.popup()


func _on_file_dialog_file_selected(path):
	$Margin/Container/Directory/Margin/Container/Input/Label.text = path
	_on_command_changed(path)


func _on_btn_save_pressed():
	if $Margin/Container/StyleSelect/Margin/BtnOption.get_selected_id() == 0:
		command = ""
		args = [""]
	
	command.replace("\\", "/")
	for arg in args:
		arg.replace("\\", "/")
	
	var export_launcher = "{
	\"command\": \""+ command +"\",
	\"arguments\": "+ str(args) +"
}"
	var launcher = FileAccess.open("user://data/"+filename+"/command.json", FileAccess.WRITE)
	for line in export_launcher.split("\n"):
		launcher.store_line(line)
	launcher.close()
	get_tree().get_root().get_node("Launcher").reload_data()
	$".".queue_free()

func _on_steam_game_text_changed(new_text):
	command = "steam"
	args = ["-applaunch", str(new_text)]
	print("New Command: " + command)
	print("New Args: " + str(args))
