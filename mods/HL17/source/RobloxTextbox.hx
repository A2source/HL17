import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import funkin.backend.MusicBeatGroup;

class RobloxTextbox extends MusicBeatGroup
{
    public var box:FlxSprite;
    public var triangle:FlxSprite;
    public var text:FlxSprite;
    public var timer:FlxTimer;
    public var padding:Int = 8;
    public var boxTime:Float = 0.1;
    public var bubbleCol = 0xFFE4E4E4;

    public function new(x:Float, y:Float)
    {
        super(x, y);

        box = new FlxSprite();
        triangle = new FlxSprite();

        for (i in [box, triangle]) i.makeGraphic(1, 1, 0xFFFFFFFF);

        text = new FlxText(0, 0, 0, '', 20);
        text.font = Paths.font('roblox.otf');
        text.alignment = "center";
        text.color = 0xFF2E2E2E;

        timer = new FlxTimer();

        add(triangle);
        add(box);
        add(text);
    }

    public function playText(string:String, char:Character)
    {
        timer.cancel();

        text.text = string;
        text.updateHitbox();
        text.x = char.getGraphicMidpoint().x - (text.width / 2);
        text.y = char.y - 50;
        text.alpha = 1;

        box.makeGraphic(text.width + padding, text.height + padding, 0x00000000);
        triangle.makeGraphic(box.width < 20 ? box.width : 20, 20, 0x00000000);
        for (i in [box, triangle]) {
            i.updateHitbox();
            i.alpha = 1;
        }

        box.x = text.x - padding / 2;
        box.y = text.y - padding / 2;

        triangle.x = (box.x + (box.width / 2)) - triangle.width / 2;
        triangle.y = box.y + box.height - triangle.height / 2;
        triangle.flipY = true;
    
        box.origin.set(0, box.height);
        text.origin.set(0, text.height);
    
        box.scale.set(1, 0);
        triangle.scale.set(1, 0);
        text.scale.set(1, 0);

        FlxTween.tween(box.scale, {y: 1}, boxTime, {ease: FlxEase.expoOut});
        FlxTween.tween(triangle.scale, {y: 1}, boxTime, {ease: FlxEase.expoOut});
        FlxTween.tween(text.scale, {y: 1}, boxTime, {ease: FlxEase.expoOut, startDelay: 0.025});
    
        timer.start(2.75, ()->
        {
            FlxTween.tween(box, {alpha: 0}, 1);
            FlxTween.tween(triangle, {alpha: 0}, 1);
            FlxTween.tween(text, {alpha: 0}, 1);
        });
    }

	public function update(dt:Float)
	{
        FlxSpriteUtil.drawRoundRect(box, 0, 0, box.width, box.height, 20, 20, bubbleCol);
        FlxSpriteUtil.drawTriangle(triangle, 0, 0, triangle.height / 2, bubbleCol);
	}
}