package;

import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class InfoSubState extends MusicBeatState
{
	override function create()
	{
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"HEY! This is the continuation of Stylus Engine"
			+ "\n i choose another name cuz u know im a dumb xD"
			+ "\n NVM"
			+ "\n I hope u enjoy the alternate version of Stylus Engine See you :)"
			+ "\n\n\n\n\n Press ANY key to leave",
			32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ANY)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'), 1, false, null, true);
			
			new FlxTimer().start(0.5, function(tmr:FlxTimer)
				{
					FlxG.switchState(new MainMenuState());
				});
		}
		super.update(elapsed);
	}
}
