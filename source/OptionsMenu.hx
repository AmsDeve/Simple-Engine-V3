package;

#if desktop
import Discord.DiscordClient;
#end
import options.Preferences;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class OptionsMenu extends MusicBeatState
{
var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = [
	'KeyBinds', 
	'Preferences', 
	'Offsets'
];
	var curSelected:Int = 0;
	var bg:FlxSprite;

	override function create()
	{
		super.create();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Options Menu", null);
		#end

		Preferences.isPauseSubState = false;
		bg = new FlxSprite(-80).loadGraphic(Paths.image('menuBGBlue'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		var bf:FlxSprite = new FlxSprite(0, 100).loadGraphic(Paths.image('bfOptions'));
		bf.setGraphicSize(Std.int(bf.width * 0.8));
		bf.screenCenter();
		bf.antialiasing = true;
		bf.y += 700;
		add(bf);

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = false;
			songText.targetY = i;

			songText.forceX = songText.x;
			songText.screenCenter(X);
			grpMenuShit.add(songText);

		}

		FlxTween.tween(bf, {y: bf.y - 550}, 0.7, {startDelay: 0.3, ease: FlxEase.smoothStepOut});

		FlxG.camera.zoom = 3;
		FlxTween.tween(FlxG.camera, {zoom: 1}, 1.1, {ease: FlxEase.expoInOut});

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxTween.tween(FlxG.camera, {zoom: 5}, 0.8, {ease: FlxEase.expoIn});

			FlxG.switchState(new MainMenuState());
		}
		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (accepted)
		{
			switch (curSelected)
			{
case 0:
	openSubState(new options.KeyBindMenu());
case 1:
	FlxTween.tween(FlxG.camera, {zoom: 5}, 0.8, {ease: FlxEase.expoIn});
	Preferences.isPauseSubState = false;
	FlxG.switchState(new options.Preferences());
case 2:
	FlxTween.tween(FlxG.camera, {zoom: 5}, 0.8, {ease: FlxEase.expoIn});
    FlxG.switchState(new options.OffsetsState());
			}
		}
	}

	function changeSelection(change:Int = 0):Void
	{

		FlxG.sound.play(Paths.sound('scrollMenu'));
		
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.color = FlxColor.WHITE;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.color = FlxColor.YELLOW;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}