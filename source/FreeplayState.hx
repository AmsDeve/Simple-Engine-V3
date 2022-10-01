package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.util.FlxTimer;

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;
	
	var scoreText:FlxText;
	var missesText:FlxText;
	var gdhtsText:FlxText;
	var comboText:FlxText;
	var diffText:FlxText;
	public static var lerpScore:Int = 0;
	var lerpMisses:Int = 0;
	var lerpCombo:Int = 0;
	var lerpGD:Int = 0;
	var intendedScore:Int = 0;
	var intendedMisses:Int = 0;
	var intendedCombo:Int = 0;
	var intendedGD:Int = 0;

	var bg:FlxSprite;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	override function create()
	{
		var initSonglist = CoolUtil.coolTextFile(Paths.mods('freeplaySonglist'));

		for (i in 0...initSonglist.length)
			{
				var data:Array<String> = initSonglist[i].split('|');
				songs.push(new SongMetadata(data[0], Std.parseInt(data[2]), data[1]));
			}

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		 */

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Freeplay", null);
		#end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end
		// LOAD MUSIC

		// LOAD CHARACTERS

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFFA5004D;
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 170, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		missesText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		missesText.font = scoreText.font;
		add(missesText);

		gdhtsText = new FlxText(scoreText.x, scoreText.y + 65, 0, "", 24);
		gdhtsText.font = scoreText.font;
		add(gdhtsText);

		comboText = new FlxText(scoreText.x, scoreText.y + 95, 0, "", 24);
		comboText.font = scoreText.font;
		add(comboText);

		diffText = new FlxText(scoreText.x + 135, scoreText.y + 135, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */
		 FlxG.camera.zoom = 3;
		FlxTween.tween(FlxG.camera, {zoom: 1}, 1.1, {ease: FlxEase.expoInOut});
		
		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));
		lerpMisses = Math.floor(FlxMath.lerp(lerpMisses, intendedMisses, 0.4));
		lerpCombo = Math.floor(FlxMath.lerp(lerpCombo, intendedCombo, 0.4));
		lerpGD = Math.floor(FlxMath.lerp(lerpGD, intendedGD, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		if (Math.abs(lerpMisses - intendedMisses) <= 10)
			lerpMisses = intendedMisses;

		if (Math.abs(lerpCombo - intendedCombo) <= 10)
			lerpCombo = intendedCombo;

		if (Math.abs(lerpGD - intendedGD) <= 10)
			lerpGD = intendedGD;

		scoreText.text = "PERSONAL BEST:" + lerpScore;
		missesText.text = "Misses: " + lerpMisses;
		gdhtsText.text = "GoodHits: " + lerpGD;
		comboText.text = "Combo: " + lerpCombo + '%';

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.LEFT_P)
			changeDiff(-1);
		if (controls.RIGHT_P)
			changeDiff(1);

		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());

			FlxTween.tween(FlxG.camera, {zoom: 5}, 0.8, {ease: FlxEase.expoIn});
		}

		if (accepted)
		{
			FlxTween.tween(FlxG.camera, {zoom: 5}, 0.8, {ease: FlxEase.expoIn});

			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

			trace(poop);
			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK' + PlayState.storyWeek);
			LoadingState.loadAndSwitchState(new PlayState());
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedMisses = Highscore.getMisses(songs[curSelected].songName, curDifficulty);
		intendedCombo = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		intendedGD = Highscore.getHits(songs[curSelected].songName, curDifficulty);
		#end

		switch (curDifficulty)
		{
			case 0:
				diffText.text = " <EASY> ";
			case 1:
				diffText.text = '<NORMAL>';
			case 2:
				diffText.text = " <HARD> ";
		}
	}

	function changeSelection(change:Int = 0)
	{
		#if !switch
		//NGio.logEvent('Fresh');
		#end

		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		//tutorial
		if (curSelected == 0)
			{
				bg.color = 0xFFA5004D;
			}

			//week 1
		if (curSelected == 1)
			{
				bg.color = 0xFFBD7BD3;
			}
			if (curSelected == 2)
				{
					bg.color = 0xFFBD7BD3;
				}
				if (curSelected == 3)
					{
						bg.color = 0xFFBD7BD3;
					}

		//week 2
		if (curSelected == 4)
			{
				bg.color = 0xFFdd947f;
			}
			if (curSelected == 5)
				{
					bg.color = 0xFFdd947f;
				}
				if (curSelected == 6)
					{
						bg.color = 0xFFF2FF6D;
					}
		
		//week 3
		if (curSelected == 7)
			{
				bg.color = 0xFFB7D855;
			}
			if (curSelected == 8)
				{
					bg.color = 0xFFB7D855;
				}
				if (curSelected == 9)
					{
						bg.color = 0xFFB7D855;
					}

		//week 4
		if (curSelected == 10)
			{
				bg.color = 0xFFD8558E;
			}
			if (curSelected == 11)
				{
					bg.color = 0xFFD8558E;
				}
				if (curSelected == 12)
					{
						bg.color = 0xFFD8558E;
					}

		//week 5
		if (curSelected == 13)
			{
				bg.color = 0xFFcb6ab4;
			}
			if (curSelected == 14)
				{
					bg.color = 0xFFcb6ab4;
				}
				if (curSelected == 15)
					{
						bg.color = 0xFFF2FF6D;
					}

		//week 6
		if (curSelected == 16)
			{
				bg.color = 0xFFFFAA6F;
			}
			if (curSelected == 17)
				{
					bg.color = 0xFFFFAA6F;
				}
				if (curSelected == 18)
					{
						bg.color = 0xFFFF3C6E;
					}

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedMisses = Highscore.getMisses(songs[curSelected].songName, curDifficulty);
		intendedCombo = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		intendedGD = Highscore.getHits(songs[curSelected].songName, curDifficulty);
		// lerpScore = 0;
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
