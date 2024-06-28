extends Window

@onready var panel_on_left = $Margin/Container/Scroll/Container/General/Margin/Container/BtnPanelLeft
@onready var color_fade = $Margin/Container/Scroll/Container/General/Margin/Container/BtnColorFade
@onready var windows_steam_directory = $Margin/Container/Scroll/Container/Command/Margin/Container/SteamDirectory/Input

func _ready():
	panel_on_left.button_pressed = UserSettings.panel_on_left
	color_fade.button_pressed = UserSettings.color_fade
	windows_steam_directory.text = UserSettings.windows_steam_directory


func _on_close_requested():
	$".".queue_free()

func _on_btn_dialog_pressed():
	$Margin/Container/Scroll/Container/Command/Margin/Container/SteamDirectory/BtnDialog/FileDialog.popup()


func _on_file_dialog_file_selected(path):
	windows_steam_directory.text = path


func _on_btn_apply_pressed():
	var results = {
	"panel_on_left": panel_on_left.button_pressed,
	"color_fade": color_fade.button_pressed,
	"windows_steam_directory": windows_steam_directory.text
	}
	
	await UserSettings.save_settings(results)
	get_tree().get_root().get_node("Launcher").reload_settings()


func _on_btn_save_pressed():
	await _on_btn_apply_pressed()
	_on_close_requested()
