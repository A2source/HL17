import funkin.options.Options;

function onEvent(e)
{
    if (e.event.name == "Screen Alpha" && Options.flashingMenu) {
        if (e.event.params[0] == "camGame") FlxG.camera.alpha = e.event.params[1];
        if (e.event.params[0] == "camHUD") camHUD.alpha = e.event.params[1];
        if (e.event.params[0] == "camOther") camOther.alpha = e.event.params[1];
        if (e.event.params[0] == "camBars") camBars.alpha = e.event.params[1];
    }
}