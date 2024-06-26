extends Window
@onready var input = $Margin/Container/Input

func _on_button_pressed():
	input.editable = false
	$Margin/Container/BtnAdd.disabled = true
	DirAccess.make_dir_absolute("user://data/"+input.text+"/")
	
	var order_read = JSON.parse_string(FileAccess.get_file_as_string("user://data/order.json"))
	order_read.append([input.text])
	
	var order = FileAccess.open("user://data/order.json", FileAccess.WRITE)
	order.store_line(str(order_read))
	order.close()
	
	get_tree().get_root().get_node("Launcher").reload_data()
	
	$".".queue_free()

func _input_changed(new_text):
	if new_text != "":
		$Margin/Container/BtnAdd.disabled = false
	else:
		$Margin/Container/BtnAdd.disabled = true




func _on_close_requested():
	$".".queue_free()

func _on_input_text_submitted(new_text):
	if $Margin/Container/BtnAdd.disabled != true:
		_on_button_pressed()
