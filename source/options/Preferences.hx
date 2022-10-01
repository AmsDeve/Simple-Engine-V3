package options;

#if desktop
import Discord.DiscordClient;
#end
import Controls.KeyboardScheme;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.ui.FlxButton;

class Preferences extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var buttonToggle:FlxButton;

	var controlsStrings:Array<String> = [];

	var descBox:FlxSprite;

	var desc:FlxText;
	var menuBG:FlxSprite;
	public static var isPauseSubState:Bool = false;

	var grpControls:FlxTypedGroup<Alphabet>;
	override function create()
	{
FlxG.mouse.visible = true;

#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Options Menu(Preferences)", null);
		#end
		
		var tex = 'menuDesat';
		menuBG = new FlxSprite().loadGraphic(Paths.image(tex));
		controlsStrings = CoolUtil.coolStringFile(
			"GhostTapping " + (!FlxG.save.data.ghostTapping ? "off" : "on") + 
			"\nMiddleScroll " + (!FlxG.save.data.middleScroll ? 'off' : 'on') + 
			"\nDownScroll " + (!FlxG.save.data.downscroll ? "off" : "on") +
			"\nAuto Play " + (!FlxG.save.data.autoplay ? "off" : "on") +
			"\nHitSound " + (!FlxG.save.data.hitSound ? "off" : "on") +
			"\nHide Hud " + (!FlxG.save.data.hud ? "off" : "on") +
			"\nAntialiasing " + (!FlxG.save.data.antialiasing ? "off" : "on") +
			"\nFullscreen " + (!FlxG.save.data.fullscreen ? "off" : "on") +
			"\nGameOver Music " + (!FlxG.save.data.songGameOver ? "Funkin" : "S E")
		);
		
		trace(controlsStrings);

		menuBG.color = 0xff4f005b;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		buttonToggle = new FlxButton(1050, 30, "RESET SCORE", function resetScore(){
			reset();
		});
	    buttonToggle.setGraphicSize(170, 35);
		buttonToggle.updateHitbox();
		buttonToggle.label.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.BLACK);
		buttonToggle.label.fieldWidth = 170;
		buttonToggle.label.y = 100;

		if (!isPauseSubState)
		add(buttonToggle);
		else
		buttonToggle.kill();

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...controlsStrings.length)
		{
				var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i], true, false);
				controlLabel.isMenuItem = true;
				controlLabel.targetY = i;
				grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}
		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 53).makeGraphic(FlxG.width, 40, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);

		desc = new FlxText(0, FlxG.height - 50, 0, "", 24);
		desc.scrollFactor.set();
		desc.text = "you won't get misses from pressing keys";
		desc.setFormat(null, 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		desc.borderSize = 2.6;
		add(desc);

		FlxG.camera.zoom = 3;
		FlxTween.tween(FlxG.camera, {zoom: 1}, 1.1, {ease: FlxEase.expoInOut});

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		desc.screenCenter(X);

			if (controls.BACK){
				FlxTween.tween(FlxG.camera, {zoom: 5}, 0.8, {ease: FlxEase.expoIn});
				if (!isPauseSubState)
					{
				FlxG.switchState(new OptionsMenu());
			}
			else
			{
				PlayState.SONG;
				FlxG.switchState(new PlayState());
			}
		}

			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);

			if (controls.ACCEPT)
			{
				if (curSelected != 10)
					grpControls.remove(grpControls.members[curSelected]);
				switch(curSelected)
				{
					case 0:
						FlxG.save.data.ghostTapping = !FlxG.save.data.ghostTapping;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "GhostTapping " + (!FlxG.save.data.ghostTapping ? "off" : "on"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 0;
						grpControls.add(ctrl);
					case 1:
						FlxG.save.data.middleScroll = !FlxG.save.data.middleScroll;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "MiddleScroll " + (!FlxG.save.data.middleScroll ? 'off' : 'on'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 1;
						grpControls.add(ctrl);
					case 2:
						FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "DownScroll " + (!FlxG.save.data.downscroll ? "off" : "on"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 2;
						grpControls.add(ctrl);
					case 3:
						FlxG.save.data.autoplay = !FlxG.save.data.autoplay;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "Auto Play " + (!FlxG.save.data.autoplay ? "off" : "on"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 3;
						grpControls.add(ctrl);
						case 4:
							FlxG.save.data.hitSound = !FlxG.save.data.hitSound;
							var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "HitSound " + (!FlxG.save.data.hitSound ? "off" : "on"), true, false);
							ctrl.isMenuItem = true;
							ctrl.targetY = curSelected - 4;
							grpControls.add(ctrl);
					case 5:
						FlxG.save.data.hud = !FlxG.save.data.hud;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "Hide Hud " + (!FlxG.save.data.hud ? "off" : "on"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 5;
						grpControls.add(ctrl);
						case 6:
							FlxG.save.data.antialiasing = !FlxG.save.data.antialiasing;
							var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "Antialiasing " + (!FlxG.save.data.antialiasing ? "off" : "on"), true, false);
							ctrl.isMenuItem = true;
							ctrl.targetY = curSelected - 6;
							grpControls.add(ctrl);
						case 7:
							FlxG.save.data.fullscreen = !FlxG.save.data.fullscreen;
							var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "Fullscreen " + (!FlxG.save.data.fullscreen ? "off" : "on"), true, false);
							ctrl.isMenuItem = true;
							ctrl.targetY = curSelected - 7;
							grpControls.add(ctrl);
							FlxG.fullscreen = FlxG.save.data.fullscreen;
						case 8:
						    FlxG.save.data.songGameOver = !FlxG.save.data.songGameOver;
						    var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "GameOver Music " + (!FlxG.save.data.songGameOver ? "Funkin" : "S E"), true, false);
						    ctrl.isMenuItem = true;
						    ctrl.targetY = curSelected - 8;
						    grpControls.add(ctrl);
				}
			}
		FlxG.save.flush();
	}

	function reset(){
		for (key in Highscore.songScores.keys())
			{
				Highscore.songScores[key] = 0;
			}
			for (key in Highscore.songGoodHits.keys())
				{
			Highscore.songGoodHits[key] = 0;
				}
			for (key in Highscore.songMisses.keys())
				{
			Highscore.songMisses[key] = 0;
				}
				for (key in Highscore.songRating.keys())
					{
				Highscore.songRating[key] = 0;
					}
	}

	var isSettingControl:Bool = false;

	function changeSelection(change:Int = 0)
	{

		#if !switch
		// NGio.logEvent('Fresh');
		#end
		
		FlxG.sound.play(Paths.sound('scrollMenu'));

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.color = FlxColor.WHITE;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (curSelected == 0)
				{desc.text = "you won't get misses from pressing keys";}

			if (curSelected == 1)
				{desc.text = "your notes get centered";}

			if (curSelected == 2)
				{desc.text = "notes go Down instead of Up";}

			if (curSelected == 3)
				{desc.text = "{BOTPLAY}";}

			if (curSelected == 4)
				{desc.text = "If u hit the notes does Osu sound";}

			if (curSelected == 5)
				{desc.text = "Hide hud";}

			if (curSelected == 6)
				{desc.text = "Sprites Quality";}

			if (curSelected == 7)
				{desc.text = "Activate Full Screen";}

			if (curSelected == 8)
				{desc.text = "Change GameOver Ost";}

			desc.screenCenter(X);

			if (item.targetY == 0)
			{
				item.color = FlxColor.YELLOW;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}