package;

import polymod.format.ParseRules.PlainTextParseFormat;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.graphics.FlxGraphic;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUITabMenu;
import flixel.system.debug.interaction.tools.Pointer.GraphicCursorCross;
import flixel.util.FlxColor;

/**
	*DEBUG MODE
 */
class AnimationDebug extends FlxState
{
	var bf:Boyfriend;
	var dad:Character;
	var shade:Character;
	var char:Character;
	var textAnim:FlxText;
	var dumbTexts:FlxTypedGroup<FlxText>;
	var animList:Array<String> = [];
	var curAnim:Int = 0;
	var isDad:Bool = true;
	var daAnim:String = 'spooky';
	var camFollow:FlxObject;
	var flipText:FlxText;
	var helpTxt:FlxText;
	var cameraFollowPointer:FlxSprite;

	public function new(daAnim:String = 'spooky')
	{
		super();
		this.daAnim = daAnim;
	}

	override function create()
	{
		FlxG.sound.music.stop();

		var gridBG:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('menuDesat'));
		gridBG.scrollFactor.set(0.5, 0.5);
		add(gridBG);

		if (daAnim == 'bf')
			isDad = false;

		if (isDad)
		{
			dad = new Character(0, 0, daAnim);
			dad.screenCenter();
			dad.debugMode = true;

			shade = new Character(0, 0, daAnim);
            shade.screenCenter();
            shade.playAnim('idle');

            shade.alpha = 0.8;
            shade.color = 0xFF140C1f;
            shade.debugMode = true;
			
            add(shade);
            add(dad);

			char = dad;
			shade.flipX = false;
			dad.flipX = false;
		}
		else
		{
			bf = new Boyfriend(0, 0);
			bf.screenCenter();
			bf.debugMode = true;
			add(bf);

			char = bf;
			bf.flipX = false;
		}

		if (PlayState.SONG.player2 == 'senpai')
			{
				dad.y += 150;
				dad.screenCenter(X);
			}

		dumbTexts = new FlxTypedGroup<FlxText>();
		add(dumbTexts);

		textAnim = new FlxText(300, 16);
		textAnim.size = 26;
		textAnim.color = FlxColor.BLACK;
		textAnim.scrollFactor.set();
		add(textAnim);
		flipText = new FlxText(10, 650, 0, '', 32);
		add(flipText);

		helpTxt = new FlxText(800, 16, 0, "You cant save the offsets!\nThis is nothing more to guide you\nsince it will help you to see how it is positioned\nand write down the offsets in the character.hx", 16);
	helpTxt.scrollFactor.set();
	helpTxt.color = FlxColor.RED;
		add(helpTxt);

		helpTxt = new FlxText(10, 700, 0, "Press X to flip", 16);
	helpTxt.scrollFactor.set();
	helpTxt.color = FlxColor.BLACK;
		add(helpTxt);

		genBoyOffsets();

		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);

		FlxG.camera.follow(camFollow);

		super.create();
	}

	function genBoyOffsets(pushList:Bool = true):Void
	{
		var daLoop:Int = 0;

		for (anim => offsets in char.animOffsets)
		{
			var text:FlxText = new FlxText(10, 20 + (18 * daLoop), 0, anim + ": " + offsets, 15);
			text.scrollFactor.set();
			text.color = FlxColor.BLACK;
			dumbTexts.add(text);

			if (pushList)
				animList.push(anim);

			daLoop++;
		}
	}

	function updateTexts():Void
	{
		dumbTexts.forEach(function(text:FlxText)
		{
			text.kill();
			dumbTexts.remove(text, true);
		});
	}

	override function update(elapsed:Float)
	{
		textAnim.text = char.animation.curAnim.name;

		if (FlxG.keys.justPressed.W)
		{
			curAnim -= 1;
		}

		if (FlxG.keys.justPressed.S)
		{
			curAnim += 1;
		}

		if (FlxG.keys.justPressed.X){
			char.flipX = !char.flipX;
		shade.flipX = !shade.flipX;
		}

		FlxG.save.data.flipX = char.flipX;
		FlxG.save.data.flipX = shade.flipX;

		if (FlxG.keys.justPressed.Z)
			FlxG.save.data.flipX = !FlxG.save.data.flipX;

		flipText.color = (FlxG.save.data.flipX ? FlxColor.LIME :FlxColor.RED);
		flipText.text = (FlxG.save.data.flipX ? 'FLIP' : 'NO FLIP');

		if (curAnim < 0)
			curAnim = animList.length - 1;

		if (curAnim >= animList.length)
			curAnim = 0;

		if (FlxG.keys.justPressed.ENTER)
			{
				PlayState.SONG;
				FlxG.switchState(new PlayState());
			}

		if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.W || FlxG.keys.justPressed.SPACE)
		{
			char.playAnim(animList[curAnim]);

			updateTexts();
			genBoyOffsets(false);
		}

		var upP = FlxG.keys.anyJustPressed([UP]);
		var rightP = FlxG.keys.anyJustPressed([RIGHT]);
		var downP = FlxG.keys.anyJustPressed([DOWN]);
		var leftP = FlxG.keys.anyJustPressed([LEFT]);

		var holdShift = FlxG.keys.pressed.SHIFT;
		var multiplier = 1;
		if (holdShift)
			multiplier = 10;

		if (upP || rightP || downP || leftP)
		{
			updateTexts();
			if (upP)
				char.animOffsets.get(animList[curAnim])[1] += 1 * multiplier;
			if (downP)
				char.animOffsets.get(animList[curAnim])[1] -= 1 * multiplier;
			if (leftP)
				char.animOffsets.get(animList[curAnim])[0] += 1 * multiplier;
			if (rightP)
				char.animOffsets.get(animList[curAnim])[0] -= 1 * multiplier;

			updateTexts();
			genBoyOffsets(false);
			char.playAnim(animList[curAnim]);
		}

		var upK = FlxG.keys.justPressed.I;
		var downK = FlxG.keys.justPressed.K;
		var leftK = FlxG.keys.justPressed.J;
		var rightK = FlxG.keys.justPressed.L;

		if (upK || rightK || downK || leftK)
			{
				if (upK)
					cameraFollowPointer.y - 10;
				if (downK)
					cameraFollowPointer.y + 10;
				if (leftK)
					cameraFollowPointer.x - 10;
				if (rightK)
					cameraFollowPointer.x + 10;
			}

		super.update(elapsed);
	}
}
