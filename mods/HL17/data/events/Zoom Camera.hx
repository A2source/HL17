function onEvent(e) 
{
    if (e.event.name == "Zoom Camera") {
        FlxTween.tween(camGame, {zoom: e.event.params[0]}, e.event.params[1], {ease: FlxEase.quadOut, onComplete: function(twn) {
            defaultCamZoom = camGame.zoom;
        }});
    }
} 