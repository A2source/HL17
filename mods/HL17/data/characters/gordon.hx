var cantIdle:Bool = false;

function stepHit(step)
{
    switch (PlayState.instance.curSong)
    {
        case "huggyteen-dollars":
            switch (step)
            {
                case 1248:
                    cantIdle = true;
            }
    }
}

var missAnim:Map<String, String> = 
[
    'gordonteen-bucks' => 'family',
    'huggyteen-dollars' => 'pose'
];

function onPlayAnim(event) {
    if (event.context == "MISS" && event.animName != missAnim[PlayState.instance.curSong]) {
        event.cancel();
        this.playAnim(missAnim[PlayState.instance.curSong], true, "MISS", false, 0);
    }
}

function onDance(e) if (cantIdle) e.cancel();