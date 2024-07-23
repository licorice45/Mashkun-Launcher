extends Window

@onready var panel_on_left = $Margin/Container/Scroll/Container/General/Margin/Container/BtnPanelLeft
@onready var color_fade = $Margin/Container/Scroll/Container/General/Margin/Container/BtnColorFade
@onready var classic_list = $Margin/Container/Scroll/Container/General/Margin/Container/BtnClassicList
@onready var launch_label = $Margin/Container/Scroll/Container/Customization/Margin/Container/LaunchLabel/Input
@onready var sound_on = $Margin/Container/Scroll/Container/Sounds/Margin/Container/BtnSoundOn
@onready var windows_steam_directory = $Margin/Container/Scroll/Container/Command/Margin/Container/SteamDirectory/Input
@onready var web_directory = $Margin/Container/Scroll/Container/Command/Margin/Container/WebDirectory/Input

func _ready():
	panel_on_left.button_pressed = UserSettings.settings["panel_on_left"]
	color_fade.button_pressed = UserSettings.settings["color_fade"]
	classic_list.button_pressed = UserSettings.settings["classic_list"]
	launch_label.text = UserSettings.settings["launch_label"]
	sound_on.button_pressed = UserSettings.settings["sound_on"]
	windows_steam_directory.text = UserSettings.settings["windows_steam_directory"]
	web_directory.text = UserSettings.settings["web_directory"]


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
	"classic_list": classic_list.button_pressed,
	"launch_label": launch_label.text,
	"sound_on": sound_on.button_pressed,
	"windows_steam_directory": windows_steam_directory.text,
	"web_directory": web_directory.text
	}
	
	await UserSettings.save_settings(results)
	get_tree().get_root().get_node("Launcher").reload_settings()


func _on_btn_save_pressed():
	await _on_btn_apply_pressed()
	_on_close_requested()


