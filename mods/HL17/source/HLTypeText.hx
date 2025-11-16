import flixel.text.FlxText;
import flixel.text.FlxTextBorderStyle;
import flixel.group.FlxGroup;

class HLTypeText extends FlxText
{
    public var smallCharacters = 'PSortfslij1:';
    public var lettersGroup:FlxGroup;
    public var fadeLetters:Bool = true;
    public var onComplete:() -> Void;

    public function new(?x:Float = 0, ?y:Float = 0, ?text:String = "", ?color:Dynamic = 0xFFFFAA00, ?playNow:Bool = false) 
    {
        lettersGroup = new FlxSpriteGroup();

        if (playNow) playText(x, y, text, color);
    }

    public function playText(?x:Float = 0, ?y:Float = 0, ?text:String = "", ?color:Dynamic = 0xFFFFAA00)
    {
        var texts = [];
        var i = 0;
        var prevChar = '';
        var col = color;
        if (color == null) col = 0xFFFFAA00;
        for (char in text.split(''))
        {
            var tempText = new FlxText(x, y, -1, char, 32);
            tempText.font = Paths.font("trebuc.ttf");
            tempText.color = color;
            tempText.alpha = 0.001;
            tempText.borderColor = 0xFF000000;
            tempText.borderSize = 1;
            tempText.borderStyle = FlxTextBorderStyle.OUTLINE;
            tempText.ID = i;
            lettersGroup.add(tempText);
    
            if (i > 0)
            {
                tempText.x = (texts[i - 1].x + tempText.width);
                if (smallCharacters.indexOf(char) >= 0)
                    tempText.x += 4;
    
                if (smallCharacters.indexOf(prevChar) >= 0)
                    tempText.x -= 6;

                if (char == "I") tempText.offset.x = -10;
                if (char == "M") tempText.offset.x = 5;
            }
    
            texts.push(tempText);
    
            new FlxTimer().start(0.07 * i, ()->
            {
                FlxTween.color(tempText, 0.19, col, 0xFFADADAD);
                FlxTween.tween(tempText, {alpha: 0.85}, 0.2);
            });
    
            i++;
    
            prevChar = char;
        }
    
        new FlxTimer().start(0.07 * text.length, ()-> 
        {
            if (onComplete != null) onComplete();

            if (!fadeLetters) return;
            new FlxTimer().start(2.8, ()-> 
            {
                for (text in texts) FlxTween.tween(text, {alpha: 0}, 0.5);
            });
        });
    }
}