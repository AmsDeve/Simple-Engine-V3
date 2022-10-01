package;

import flixel.*;
import flixel.util.FlxColor;

class FlxDiscSprite extends FlxSprite
{
    public static var colorCenter:Int = 0;
    
    public function new(x:Float, y:Float)
        {
            super(x, y);

            loadGraphic(Paths.image('assDisc'));
            angularVelocity = 6;
        }
    
    override function update(discColor:Float)
        {
            super.update(discColor);

            if (colorCenter == 0)
                {
                    replaceColor(0xFFCCCC00, FlxColor.WHITE);
                    replaceColor(0xFF835022, FlxColor.WHITE);
                }

                if (colorCenter == 1)
                    {
                        replaceColor(FlxColor.YELLOW, FlxColor.BLACK);
                        replaceColor(FlxColor.ORANGE, FlxColor.BLACK);
                    }
        }
}