import funkin.options.Options;

// CAN YOU STOP FUCKING WITH THE MICROWAVE??

var scientists:Array<String> = ['nerd', 'einstein', 'luther', 'slick'];

var theScienceTeam:Array = [];
var singingStatus:Array = [];
var withTheScienceTeam:Bool = false;

var gman:Character;
var gmanCanBop:Bool = false;

/*
function create() {
    for (i in scientists) {
        if (SONG.strumLines[0].characters[0] == i) {
            SONG.strumLines[0].characters[0] = scientists[FlxG.random.int(0, scientists.length - 1)];
            break;
        }
    }
}
*/

function postCreate()
{
    for (i in playerStrums) {
        i.alpha = 0.001;
        i.visible = false;
    }

    camGame.fade(0xFF000000, 0.001, false);

    gman = new Character(270, -60, "gman-bopper");
    gman.alpha = 0.001;
    gman.scrollFactor.set(0.5, 0.5);
	gman.scale.set(gf.scale.x - 0.15, gf.scale.y - 0.15);
    insert(members.indexOf(gf), gman);

	for (i in 0...15)
	{
		var guy:String = scientists[FlxG.random.int(0, scientists.length - 1)];

		var member:Character = new Character(FlxG.random.float(dad.x - 400, dad.x - 50), dad.y - (FlxG.random.int(1, 6)), guy);
		member.alpha = 0.001;
		member.origin.set(member.width / 2, member.height);
		member.scale.set(1.3, 0.7);

		member.ID = i;

		insert(members.indexOf(dad), member);
		theScienceTeam.push(member);

		singingStatus.push(false);
	}

	camFollow.y -= 400;
}

function onSongStart()
{
    defaultCamZoom = 0.87;
    FlxTween.tween(camFollow, {x: 335, y: 350}, 5, {ease: FlxEase.expoInOut});

    FlxG.camera.zoom = 0.5;
    FlxTween.tween(camGame, {zoom: 0.9}, 5, {ease: FlxEase.quadOut, startDelay: 0.8});

    camGameZoomLerp = 0.1;
    camHUDZoomLerp = 0.1;
    FlxG.camera.fade(0xFF000000, 3, true);
}

function stepHit(step)
{
    switch (curStep)
    {
        case 0: curCameraTarget = -1;

        case 60:
            FlxTween.cancelTweensOf(camGame);
            FlxTween.cancelTweensOf(camFollow);

        case 64: camZooming = Options.camZoomOnBeat;

		case 568:
			var i = 0;
			for (member in theScienceTeam)
			{
				new FlxTimer().start(0.08 * i, () ->
				{
					FlxTween.tween(member.scale, {x: 1, y: 1}, 1, {ease: FlxEase.backOut});
					FlxTween.tween(member, {alpha: 1}, 1, {ease: FlxEase.expoOut});
				});

				i++;
			}

            executeEvent({name: "Camera Follow Pos", time: 0, params: [dad.x - 80, 350]});

		case 576: withTheScienceTeam = true;

        case 624:
			gman.alpha = 1;
			gman.playAnim("intro", true);
			gman.animation.finishCallback = function (bop)
			{
				gmanCanBop = true;
				gman.animation.finishCallback = null;
			}

		case 960:
			withTheScienceTeam = false;

            executeEvent({name: "Camera Follow Pos", time: 0, params: [dad.x - 80, 500]});

			var i = 0;
			for (member in theScienceTeam)
			{
				new FlxTimer().start(0.08 * i, () ->
				{
					FlxTween.tween(member.scale, {x: 1.3, y: 0.7}, 1, {ease: FlxEase.backIn});
					FlxTween.tween(member, {alpha: 0}, 1, {ease: FlxEase.expoIn});
				});

				i++;
			}

		case 1216: camGame.alpha = 0;

        case 1280: camHUD.shake(0.01125, 0.62);
    }
}

function beatHit(beat)
{
	if (withTheScienceTeam)
	{
		for (member in theScienceTeam)
		{
			if (!singingStatus[member.ID])
				member.dance();

			singingStatus[member.ID] = false;
		}
	}

    if (gmanCanBop && curBeat % 2 == 0) gman.playAnim("idle", false);
}

function onDadHit(e)
{
	if (withTheScienceTeam && !e.note.isSustainNote && e.noteType == 'No Anim Note')
	{
		var ourGuy = FlxG.random.int(0, theScienceTeam.length - 1);

		theScienceTeam[ourGuy].playSingAnim(e.direction, e.animSuffix);
		singingStatus[ourGuy] = true;
	}
}