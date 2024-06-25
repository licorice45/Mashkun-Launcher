extends TextureRect
var aspect_ratio_x : float
var hover = false

var filename
var grid_position

var command
var arguments
var metadata
var texture_bg
var texture_title

# Called when the node enters the scene tree for the first time.
func _ready():
	aspect_ratio_x = $".".texture.get_size().x / $".".texture.get_size().y
	if metadata != null:
		$Button.tooltip_text = metadata["name"]

func _on_mouse_entered():
	hover = true
	$AnimationPlayer.play("Hover")
	
	if Edit() != null:
		if Edit().get_parent() != $".".get_parent() && $Timer.is_stopped() == true:
			$Timer.start()
			Edit().reparent($".".get_parent())
		$".".get_parent().move_child(Edit(), $".".get_index())


func _on_mouse_exited():
	hover = false
	$AnimationPlayer.play("Unhover")


func _on_button_pressed():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("Click")
	get_tree().get_root().get_node("Launcher").tile_click($".")
	var noise = get_tree().get_root().get_node("Launcher").get_child(get_tree().get_root().get_node("Launcher").find_child("AudioStreamPlayer").get_index())
	if noise.playing != true:
		noise.stream = load("res://assets/sfx/glass.ogg")
		noise.play()


func _on_timer_2_timeout():
	get_tree().get_root().get_node("Launcher").edit_mode = $"."

func _input(event):
	if Input.is_action_just_released("click"):
		$Timer2.stop()
		if Edit() == $".":
			get_tree().get_root().get_node("Launcher").tile_click($".")
	elif Input.is_action_just_pressed("click") && $Timer2.is_stopped() == true && hover == true:
			$Timer2.start()

func Edit():
	return get_tree().get_root().get_node("Launcher").edit_mode
