function onEvent(e)
{
    if (e.event.name == "Fade Strums")
    {
        for (i in playerStrums)
        {
            i.visible = true;
            i.alpha = 0.001;
            FlxTween.tween(i, {alpha: e.event.params[0]}, e.event.params[1]);
        }
    }
}