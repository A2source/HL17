// make sure to play FNF: Huggy Mix https://gamebanana.com/mods/621910

import flixel.input.keyboard.FlxKey;
import funkin.options.Options;
import Bopper;

var awesome:FlxSprite;
var huggyFP:Character;
var gordonFP:Character;
var oldDad:Character;
var oldBF:Character;
var microwaveBug:Character;
var bugExploded:Bool = false;
var favourites:Array<Character> = [];
var pos:Array = [];
var gman:Bopper;

function onSongStart() camGame.fade(0xFF000000, 5, true);

function postCreate()
{
    defaultCamZoom = 2;
    camGame.zoom = 2;
    camGame.fade(0xFF000000, 0.001);

    huggyFP = new Character(100, 100, 'huggy-fp', false);
    huggyFP.alpha = 0.001;
    add(huggyFP);

    gordonFP = new Character(320, -25, 'gordon-fp', false);
    gordonFP.alpha = 0.001;
    add(gordonFP);
    
    awesome = new FlxSprite().loadGraphic(Paths.image("awesome"));
    awesome.cameras = [camHuggy];
    awesome.scale.set(0.65, 0.65);
    awesome.screenCenter();
    awesome.x = -1431;
    add(awesome);

    FlxTween.tween(awesome, {angle: 360}, 2, {type: FlxTween.LOOPING});

    oldDad = dad;
    oldBF = boyfriend;

    // CREATING FAVOURITES
    var stinger = new Bopper(-125, 100).setCharacter('characters/huggyteen/Stinger Flynn');
    var banban = new Bopper(40, -30).setCharacter('characters/huggyteen/Banban');
    var seek = new Bopper(480, 100).setCharacter('characters/huggyteen/Seek');
    var josh = new Bopper(600, 300).setCharacter('characters/huggyteen/Jumbo Josh');

    favourites.push(stinger);
    favourites.push(banban);
    favourites.push(seek);
    favourites.push(josh);

    for (guy in favourites)
    {
        guy.x += 100;
        guy.scrollFactor.set(0.6, 0.6);
        guy.alpha = 0.001;
        insert(members.indexOf(dad), guy);

        pos.push([guy.x, guy.y]);
    }

    gman = new Character(270, -60, 'gman-bopper');
    gman.alpha = 0.001;
    gman.scrollFactor.set(0.5, 0.5);
	gman.scale.set(gf.scale.x - 0.15, gf.scale.y - 0.15);
    insert(members.indexOf(gf), gman);

    microwaveBug = new Character(720, 500, "microwave-bug");
    microwaveBug.scrollFactor.set(gf.scrollFactor.x, 1);
    insert(members.indexOf(boyfriend), microwaveBug);

    for (i in playerStrums) {
        i.alpha = 0.001;
        i.visible = false;
    }
}

function postUpdate(e) {
    if (FlxG.keys.justPressed.SHIFT && !bugExploded) {
        bugExploded = true;
        microwaveBug.playAnim("explosion", true);
        microwaveBug.debugMode = true;

        new FlxTimer().start(0.08, ()->
        {
            FlxG.sound.play(Paths.sound("microwave"), 0.8);
        });
    }
}

function stepHit(step)
{
    switch(step)
    {
        case 64: camZooming = true;
        case 447, 863: brainrot(true);
        case 552, 1095: brainrot(false, curStep == 1095);

        case 472, 888, 1016, 1080:
            awesome.x = -1431;
            FlxTween.tween(awesome, {x: awesome.x + 3000}, 1.84, {ease: FlxEase.quadOut}); 

        case 864: camGameZoomLerp = 0.1;
        case 1142: FlxTween.tween(PlayState.instance, {health: 0.000000000001}, 10.84, {ease: FlxEase.cubeInOut});

        case 1248:
            camZooming = false;
            camGameZoomLerp = 0.05;
            FlxG.camera.followLerp *= 0.9;

        case 1256: FlxTween.tween(PlayState.instance, {health: 0.001}, 0.6, {ease: FlxEase.expoOut});
        case 1268: camGame.alpha = 0;
    }
}

function beatHit(beat)
{
    if (beat % 2 == 0) {
        for (guy in favourites) guy.animation.play('idle', true);

        gman.animation.play('idle', true);
    }
}

function brainrot(on, ?man:Bool = false)
{
    var angle = [-60, -45, 45, 60];
    var offsets = [100, 200, 300, 200];
    var i:Int = 0;

    if (on)
    {
        for (guy in favourites)
        {
            guy.x = dad.x;
            guy.y = dad.y + offsets[i];
            guy.angle = angle[i];

            guy.scale.set(0, 0);

            guy.alpha = 0.01;

            FlxTween.tween(guy, {x: pos[i][0], y: pos[i][1], alpha: 1, angle: 0}, 2, {ease: FlxEase.expoOut, startDelay: i * 0.1});
            FlxTween.tween(guy.scale, {x: 0.83, y: 0.83}, 2, {ease: FlxEase.expoOut, startDelay: i * 0.1});

            i++;
        }
    }
    else
    {
        for (guy in favourites)
        {
            FlxTween.tween(guy, {x: dad.x, y: dad.y + offsets[i], alpha: 0, angle: angle[i]}, 2, {ease: FlxEase.expoIn, startDelay: i * 0.1});
            FlxTween.tween(guy.scale, {x: 0, y: 0}, 2, {ease: FlxEase.expoIn, startDelay: i * 0.1});
            i++;
        }
    }

    new FlxTimer().start(on ? 0 : 2.5, ()->
    {
        var prevLerp = FlxG.camera.followLerp;
        FlxG.camera.followLerp = 1000;
        curCameraTarget = 0;
        new FlxTimer().start(0.001, ()->
        {
            FlxG.camera.followLerp = prevLerp;
        });
        dad = on ? huggyFP : oldDad;
        boyfriend = on ? gordonFP : oldBF;

        for (i in [oldDad, oldBF, gf, microwaveBug]) i.alpha = on ? 0.001 : 1;
        for (i in [huggyFP, gordonFP]) i.alpha = on ? 1 : 0.001;
        gman.alpha = man ? 1 : 0.001;
        if (man && Options.flashingMenu) FlxG.camera.flash(0xFFFFFFFF, 3); 
    });
}