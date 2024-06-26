extends Window

func _ready():
	$Margin/Container/Settings/PanelContainer/Scroll/Margin/Container/General/Margin/Container/BtnPanelRight.button_pressed = UserSettings.panel_on_left
	$Margin/Container/Settings/PanelContainer/Scroll/Margin/Container/General/Margin/Container/BtnColorFade.button_pressed = UserSettings.color_fade
	$Margin/Container/Settings/PanelContainer/Scroll/Margin/Container/Command/Margin/Container/SteamDirectory/Input.text = UserSettings.windows_steam_directory


func _on_close_requested():
	$".".queue_free()



func _on_button_pressed():
	var results = {
	"panel_on_left": $Margin/Container/Settings/PanelContainer/Scroll/Margin/Container/General/Margin/Container/BtnPanelRight.button_pressed,
	"color_fade": $Margin/Container/Settings/PanelContainer/Scroll/Margin/Container/General/Margin/Container/BtnColorFade.button_pressed,
	"windows_steam_directory": $Margin/Container/Settings/PanelContainer/Scroll/Margin/Container/Command/Margin/Container/SteamDirectory/Input.text
	}
	
	await UserSettings.save_settings(results)
	get_tree().get_root().get_node("Launcher").reload_settings()
