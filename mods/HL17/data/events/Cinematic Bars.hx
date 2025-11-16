import flixel.FlxG;
import flixel.FlxMath;

var bars:Array = [];
var positions:Array = [[-250, FlxG.height], [-175, FlxG.height - 75]];

var status:Bool = false;
var decayTime:Float = 1.0;

function postCreate()
{
    var bar1 = new FlxSprite().makeGraphic(FlxG.width, 250, 0xFF000000);
    bar1.y -= bar1.height;

    var bar2 = new FlxSprite().makeGraphic(FlxG.width, 250, 0xFF000000);
    bar2.y = FlxG.height;

    bars.push(bar1);
    bars.push(bar2);

    for (bar in bars)
    {
        bar.cameras = [camBars];
        add(bar);
    }

    if (SONG.meta.name == "gordonteen-bucks" || SONG.meta.name == "huggyteen-dollars") {
        status = true;
        decay = 3.5;
    }
}

function onEvent(e)
{
    if (e.event.name == 'Cinematic Bars') {
        status = e.event.params[0];
        decayTime = e.event.params[1] + 3;
    }
}

function postUpdate(dt)
{
    var lerpVal:Float = 1 - Math.exp(-decayTime * dt);
    //trace(lerpVal);

    for (i in 0...2)
    {
        var bar = bars[i];
        var desiredY = positions[status ? 1 : 0][i];

        bar.y = FlxMath.lerp(bar.y, desiredY, lerpVal);
    }
}