extends Window


func _on_close_requested():
	$".".queue_free()


func _on_list_item_selected(index):
	match index:
		0:
			$Margin/Container/Text/Margin/ScrollContainer/Label.text = "[font_size=24]Importing Custom Metadata[/font_size]\n\n[color=RED][b]Warning: make sure that data obtained from internet doesn't have command.json as it might contain malicious code !![/b][/color]\n\nNavigate to your data folder, make a new folder and inside it put your files such as metadata.json and the images.\nOpen the Launcher and add a new blank tile and for folder name use the one you used during the previous step.\nNow add launch command and enjoy your game."
		1:
			$Margin/Container/Text/Margin/ScrollContainer/Label.text = "[font_size=24]Credits[/font_size]\nApp created by licorice45\n\nBanner, Logo and Icon created by IronB\nSound assets obtained from Kenney\n\nMade in Godot\n\n[b]Special Thanks:[/b]\n[ul]Spico\n[/ul]"
