package;

import flixel.*;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import Section.SwagSection;

class Events
{

    public static var instance:Events;

    public function cameraAngleEvent(camera:FlxCamera)
		{
			new FlxTimer().start(0, function(tmr:FlxTimer)
				{
					if(camera.angle == -7) FlxTween.tween(camera, {angle: 7}, 1, {ease: FlxEase.quartInOut});
					else FlxTween.tween(camera, {angle: -7}, 1, {ease: FlxEase.quartInOut});
				}, 0);
		}

		public function heyEvent(bf:FlxSprite, gf:FlxSprite)
			{
				bf.animation.play('hey');
				gf.animation.play('cheer');
			}

			@:inProgress
			/*public function flashEvent()
				{
					var flash:FlxSprite;

					flash = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);

					new FlxTimer().start(1, function(tmr:FlxTimer)
						{
FlxTween.tween(flash, {alpha: 0}, 1, {ease: FlxEase.sineInOut});
						}, 0);
				}*/
}