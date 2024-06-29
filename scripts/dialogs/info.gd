extends Window


func _on_close_requested():
	$".".queue_free()


func _on_list_item_selected(index):
	match index:
		0:
			$Margin/Container/Text/Margin/ScrollContainer/Label.text = "[font_size=24]Basic Overview[/font_size]

[img=442]res://assets/textures/basic_overview.png[/img]

1. Launches the selected game
2. Options for selected game such as edit metadata and launch command
3. Search for games
4. Add a new game
5. Open settings
6. Games list


[b]Adding Games[/b]

Press the [4] button from screenshot above and type a unique name for the folder that will store the game metadata.

Now click on new button and press [2] button and then [Edit Launch Command], select directory and point to the path to your game.

You can also edit displayed name and other metadata for styling purposed by clicking [Edit Metadata] instead."
		1:
			$Margin/Container/Text/Margin/ScrollContainer/Label.text = "[font_size=24]Importing Custom Metadata[/font_size]\n\n[color=RED][b]Warning: make sure that data obtained from internet doesn't have command.json as it might contain malicious code !![/b][/color]\n\nNavigate to your data folder, make a new folder and inside it put your files such as metadata.json and the images.\nOpen the Launcher and add a new blank tile and for folder name use the one you used during the previous step.\nNow add launch command and enjoy your game."
		2:
			$Margin/Container/Text/Margin/ScrollContainer/Label.text = "[font_size=24]Credits[/font_size]\nApp created by licorice45\n\nBanner, Logo and Icon created by IronB\nSound assets obtained from Kenney\n\nMade in Godot\n\n[b]Special Thanks:[/b]\n[ul]Spico\n[/ul]"
