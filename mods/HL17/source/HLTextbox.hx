import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;

class HLTextbox extends FlxSprite
{
    public var lyric:FlxSprite;
    public var lines:Array<Dynamic> = [];
    public var linesGrp:FlxGroup;
    public var lyricTimer:FlxTimer;

    public function new(?text:String = "", ?playNow:Bool = false)
    {
        super(x, y);

        makeGraphic(FlxG.width / 2, 60, FlxColor.TRANSPARENT);
        screenCenter(1);
        alpha = 0.5;

        linesGrp = new FlxSpriteGroup();

        lyricTimer = new FlxTimer();

        if (playNow) addText(text);
    }

    public function addText(text:String = "")
    {
        if (alpha == 0) FlxTween.tween(this, {alpha: 0.5}, 0.3, {ease: FlxEase.expoOut});
    
        var lyric = new FlxText(x + 10, 570, width - 10, text, 28);
        lyric.font = Paths.font("trebuc.ttf");

        if (lyric.textField.numLines > 1) lyric.y -= 15 * lyric.textField.numLines;

        FlxTween.tween(lyric, {alpha: 1}, 0.4, {ease: FlxEase.expoOut});

        lines.push(lyric);
        linesGrp.add(lyric);
    
        var totalHeight = lyric.height;
    
        // stupid fucking solution but IDK ANYTHING ELSE THAT IS WORKIN RIGHT :upside_down:
        while (lines.length > 4)
        {
            remove(lines[0]);
            lines.remove(lines[0]);
        }
        
        for (i in 0...lines.length - 1)
        {
            var curLine = lines[i];
            FlxTween.cancelTweensOf(curLine);
    
            FlxTween.tween(curLine, {y: curLine.y - lyric.height}, 0.4, {ease: FlxEase.expoOut});
            totalHeight += curLine.height;
        }
    
        FlxTween.completeTweensOf(this);
    
        var scaling = height;
    
        y = lines[0].y;
    
        if (lines.length > 1) y -= lyric.height;
    
        makeGraphic(width, totalHeight, FlxColor.TRANSPARENT);
        origin.set(0, height);
    
        scaling /= height;
        FlxTween.tween(scale, {y: 1}, 0.4, {ease: FlxEase.expoOut});
    
        scale.set(1, scaling);
    
        if (lyricTimer.active) lyricTimer.cancel();
    
        lyricTimer.start(2.2, ()->
        {
            FlxTween.tween(scale, {y: 0}, 0.4, {ease: FlxEase.backIn});
    
            var i = 0;
            for (line in lines)
            {
                FlxTween.tween(line, {alpha: 0}, 0.4, {ease: FlxEase.expoOut, startDelay: 0.08 * i,
                    onComplete: ()->
                    {
                        state.remove(line);
                        lines.remove(line);
                    }});
            }
            i++;
        });
    }

    public function update(elapsed:Float)
    {
        super.update(elapsed);
        if (lines.length == 0) alpha = 0;
            
        FlxSpriteUtil.drawRoundRect(this, 0, 0, this.width, this.height, 20, 20, 0xFF000000);
    }
}