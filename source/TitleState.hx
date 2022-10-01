package;

#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import flixel.addons.display.FlxBackdrop;
import lime.app.Application;
import openfl.Assets;
import flixel.input.keyboard.FlxKey;

using StringTools;

class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;
	var bgEXTRA:FlxSprite;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	public static var leftState:Bool = false;

	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	override public function create():Void
	{

		PlayerSettings.init();

		curWacky = FlxG.random.getObject(getIntroTextShit());

		// DEBUG BULLSHIT

		super.create();

		//NGio.noLogin(APIStuff.API);

		#if ng
		//var ng:NGio = new NGio(APIStuff.API, APIStuff.EncKey);
		trace('NEWGROUNDS LOL');
		#end

		FlxG.save.bind('SimpleEngine', 'AmsDev');

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
		
		options.KeyBinds.gamepad = gamepad != null;

        FlxG.fullscreen = FlxG.save.data.fullscreen;

		PlayerSettings.player1.controls.loadKeyBinds();
		options.KeyBinds.keyCheck();

		Highscore.load();

		if (FlxG.save.data.weekUnlocked != null)
		{
			// FIX LATER!!!
			// WEEK UNLOCK PROGRESSION!!
			// StoryMenuState.weekUnlocked = FlxG.save.data.weekUnlocked;

			if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			// QUICK PATCH OOPS!
			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;
		}

		#if FREEPLAY
		FlxG.switchState(new FreeplayState());
		#elseif CHARTING
		FlxG.switchState(new ChartingState());
		#else
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			startIntro();
		});
		#end

		#if desktop
		DiscordClient.initialize();
		
		Application.current.onExit.add (function (exitCode) {
			DiscordClient.shutdown();
		 });
		#end
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		if (!initialized)
		{
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('freakyMenu'));
			// FlxG.sound.list.add(music);
			// music.play();
			FlxG.sound.playMusic(Paths.music('introMusic'), 0);

			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}

		Conductor.changeBPM(180);
		persistentUpdate = true;

		bgEXTRA = new FlxSprite().makeGraphic(1280,720,0xff000000);
		add(bgEXTRA);

		logoBl = new FlxSprite(-150, -150);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		// logoBl.screenCenter();
		// logoBl.color = FlxColor.BLACK;

		gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
		gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = true;
		add(gfDance);
		add(logoBl);

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		// titleText.screenCenter(X);
		add(titleText);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		logo.antialiasing = true;
		// add(logo);

		FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		// FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		bgEXTRA = new FlxSprite().makeGraphic(1280,720,0xff000000);
		credGroup.add(bgEXTRA);

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('unknown'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;

		FlxG.mouse.visible = false;

		if (initialized)
			skipIntro();
		else
			initialized = true;
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (pressedEnter && !transitioning && skippedIntro)
		{
			#if !switch
			NGio.unlockMedal(60960);

			// If it's Friday according to da clock
			if (Date.now().getDay() == 5)
				NGio.unlockMedal(61034);
			#end

			titleText.animation.play('press');

			FlxG.sound.music.fadeOut(1,0);

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
			FlxG.sound.play(Paths.sound('titleShoot'), 0.7);

			transitioning = true;
			// FlxG.sound.music.stop();

			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
leftState = true;
//just put this in false
				if (leftState)
				{
					FlxG.switchState(new InfoSubState());
				}
				else
				{
					if (FlxG.sound.music != null)
						FlxG.sound.music.stop();

					FlxG.switchState(new MainMenuState());
				}
			});
		}

		if (pressedEnter && !skippedIntro)
		{
			skipIntro();
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	override function beatHit()
	{
		super.beatHit();

		logoBl.animation.play('bump');
		danceLeft = !danceLeft;

		if (danceLeft)
			gfDance.animation.play('danceRight');
		else
			gfDance.animation.play('danceLeft');

		FlxG.log.add(curBeat);

		switch (curBeat)
		{
			case 8:
				deleteCoolText();
				addMoreText('NINJAMUFFIN99');
				addMoreText('PHANTOMARCADE');
				addMoreText('KAWAISPRITE');
				addMoreText('EVILSK8ER');
			case 9:
				addMoreText('presents!');
			case 10:
				deleteCoolText();
				#if Simple_Engine_WTRMRKS
				createCoolText(['AmsDev and AssmanBruh!']);
				#else
				createCoolText(['In association', 'with']);
				#end
			case 11:
				#if Simple_Engine_WTRMRKS
				addMoreText('Creators');
				ngSpr.visible = true;
				#else
				addMoreText('newgrounds');
				ngSpr.visible = true;
				#end
			case 12:
				deleteCoolText();
				createCoolText(['AndyGamer']);
				ngSpr.visible = false;
			case 13:
				addMoreText('Artist');
			case 14:
				deleteCoolText();
				createCoolText([curWacky[0]]);
			case 15:
				addMoreText(curWacky[1]);
			case 16:
				deleteCoolText();
				curWacky = FlxG.random.getObject(getIntroTextShit());
				createCoolText([curWacky[0]]);
			case 17:
				addMoreText(curWacky[1]);
			case 18:
				deleteCoolText();
				createCoolText(['Plaza']);
			case 19:
				addMoreText('Good');
			case 20:
				deleteCoolText();
				curWacky = FlxG.random.getObject(getIntroTextShit());
				createCoolText([curWacky[0]]);
			case 21:
				addMoreText(curWacky[1]);
			case 22:
				deleteCoolText();
				createCoolText(['HER HAIR']);
			case 23:
				addMoreText('HER EYES');
				addMoreText('HER THIGHS YEAH');
			case 24:
				deleteCoolText();
				curWacky = FlxG.random.getObject(getIntroTextShit());
				createCoolText([curWacky[0]]);
			case 25:
				addMoreText(curWacky[1]);
			case 26:
				deleteCoolText();
				curWacky = FlxG.random.getObject(getIntroTextShit());
				createCoolText([curWacky[0]]);
			case 27:
				addMoreText(curWacky[1]);
			case 28:
				deleteCoolText();
				createCoolText(['kade we']);
			case 29:
				addMoreText('love you');
			case 30:
				deleteCoolText();
				createCoolText(['SIMPLE ENGINE']);
			case 31:
				addMoreText('FOREVER!!');
			case 32:
				deleteCoolText();
				createCoolText(['OMAGAEHHHHH']);
			case 33:
				addMoreText('OMAGAEHHHHH!');
			case 34:
				deleteCoolText();
				curWacky = FlxG.random.getObject(getIntroTextShit());
				createCoolText([curWacky[0]]);
			case 35:
				addMoreText(curWacky[1]);
			case 36:
				deleteCoolText();
				addMoreText("Friday");
			case 37:
				addMoreText('Night');
			case 38:
				addMoreText('Funkin'); 
			case 39:
				addMoreText('Simple Engine'); 
			case 40:
				skipIntro();
		}
	}

	var skippedIntro:Bool = false;

	var increaseVolume:Bool = false;
	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);

			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);
			skippedIntro = true;
		}
	}
}
