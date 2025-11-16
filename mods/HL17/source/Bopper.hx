class Bopper extends FlxSprite
{
    public function new(x:Float, y:Float) super(x, y);

    public function setCharacter(char:String, ?animProperties:Array<Dynamic>) 
    {
        var spriteProperties:Array = animProperties;
        if (animProperties == null) spriteProperties = ["idle", 24, false];

        frames = Paths.getSparrowAtlas(char);
        animation.addByPrefix("idle", spriteProperties[0], spriteProperties[1], spriteProperties[2]);

        return this;
    }
}