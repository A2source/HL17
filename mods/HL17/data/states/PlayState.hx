import funkin.backend.FunkinText;
import funkin.options.Options;
import funkin.backend.system.Main;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import Math;
import HLTypeText;
import flixel.math.FlxRect;

var botplayTxt:FunkinText;
var cpuControlled:Bool = false;

var flashlight:FlxSprite;
var hp:FlxSprite;
var divider:FlxSprite;

var hevEmpty:FlxSprite;
var hevFull:FlxSprite;

var damage:FlxSprite;

var hpNums = [];
var hevNums = [];
var damage = [];

var songTitle:HLTypeText;

static var camHuggy:FlxCamera;
static var camOther:FlxCamera;
static var camBars:FlxCamera;

function create()
{
	PauseSubState.script = 'data/states/HL17Pause';
	GameOverSubstate.script = 'data/states/HL17GameOver';

	camHuggy = new FlxCamera();
    camOther = new FlxCamera();
    camBars = new FlxCamera();
	scripts.set("camHuggy", camHuggy);
    scripts.set("camOther", camOther);
    scripts.set("camBars", camBars);

    for (cam in [camGame, camHUD]) FlxG.cameras.remove(cam, false);
    for (cam in [camGame, camBars, camHuggy, camHUD, camOther]) {cam.bgColor = 0x00000000; FlxG.cameras.add(cam, cam == camGame);}
}

function postCreate()
{
    botplayTxt = new FunkinText(0, 0, FlxG.width, "BOTPLAY", 36);
    botplayTxt.alignment = "center";
    botplayTxt.cameras = [camHUD];
    botplayTxt.font = Paths.font("trebuc.ttf");
    botplayTxt.screenCenter();
    botplayTxt.y -= 300;
    botplayTxt.visible = cpuControlled;
    add(botplayTxt);

    flashlight = new FlxSprite().loadGraphic(Paths.image('hud/flashlight'));
    flashlight.antialiasing = false;
    flashlight.scale.set(1.5, 1.5);
    flashlight.updateHitbox();
    flashlight.x = FlxG.width - flashlight.width * 1.5;
    flashlight.y = camHUD.downscroll ? FlxG.height * 0.9 : FlxG.height * 0.0111111;
    flashlight.cameras = [camHUD];
    flashlight.color = boyfriend.iconColor;

    var flashlightBox = new FlxSprite(flashlight.x - 5, flashlight.y).makeGraphic(flashlight.width + 15, flashlight.height, 0xFF000000);
    flashlightBox.alpha = 0.5;
    flashlightBox.cameras = [camHUD];

    add(flashlightBox);
    add(flashlight);

    var hpBox = new FlxSprite(20, camHUD.downscroll ? FlxG.height * 0.0111111 : FlxG.height * 0.9).makeGraphic(275, 60, 0xFF000000);
    hpBox.alpha = 0.5;
    hpBox.cameras = [camHUD];
    add(hpBox);

	for (i in -3...0)
	{
		var num:FlxSprite = new FlxSprite((Math.abs(i) * 20) + 50, 0);
		num.y = hpBox.y + 18;
		num.frames = Paths.getSparrowAtlas('hud/nums');

		num.scale.set(1.1, 1.1);

		for (j in 0...10)
			num.animation.addByPrefix('' + j, '' + j, 1, false);

		num.cameras = [camHUD];
		add(num);
		hpNums.push(num);
	}

	hp = new FlxSprite().loadGraphic(Paths.image('hud/health'));
	hp.antialiasing = false;
	hp.scale.set(1.5, 1.5);
	hp.updateHitbox();
	hp.x = hp.width / 2;
	hp.y = hpBox.y + 5;
	hp.cameras = [camHUD];
	hp.color = boyfriend.iconColor;
	add(hp);

	divider = new FlxSprite(hp.x + 120, hp.y + 5).loadGraphic(Paths.image('hud/divider'));
	divider.cameras = [camHUD];
	divider.color = boyfriend.iconColor;
	divider.alpha = 0.75;
	add(divider);

	hevEmpty = new FlxSprite().loadGraphic(Paths.image('hud/hevEmpty'));
	hevFull = new FlxSprite().loadGraphic(Paths.image('hud/hevFull'));

	for (i in [hevEmpty, hevFull]) {
		i.antialiasing = false;
		i.scale.set(1.3, 1.3);
		i.updateHitbox();
		i.x = divider.x + 25;
		i.y = hp.y;
		i.cameras = [camHUD];
		i.color = boyfriend.iconColor;
		add(i);
	}

	hevFull.clipRect = new FlxRect(0, Std.int(hevFull.height), 100, 100);
	hevFull.clipRect = hevFull.clipRect;

	for (i in -3...0)
	{
		var num:FlxSprite = new FlxSprite((Math.abs(i) * 20) + 210, 0);
		num.y = hpBox.y + 18;
		num.frames = Paths.getSparrowAtlas('hud/nums');

		num.scale.set(1.1, 1.1);

		for (j in 0...10)
			num.animation.addByPrefix('' + j, '' + j, 1, false);

		num.cameras = [camHUD];
		add(num);
		hevNums.push(num);
	}

	for (i in 0...4)
	{
		var d = new FlxSprite().loadGraphic(Paths.image('hud/damage/' + i));
		d.cameras = [camHUD];
		d.alpha = 0;
		add(d);
		damage.push(d);
	}

	updateHealth();

	songTitle = new HLTypeText(0, 80, "");
	for (i in [songTitle, songTitle.lettersGroup]) {
		i.cameras = [camHUD];
		add(i);
	}

    for (i in [healthBarBG, healthBar, iconP2, iconP1, scoreTxt, accuracyTxt, missesTxt]) i.visible = false;

    scripts.set("botplayTxt", botplayTxt);
    scripts.set("cpuControlled", cpuControlled);
    scripts.set("flashlight", flashlight);
    scripts.set("flashlightBox", flashlightBox);
    scripts.set("hpBox", hpBox);
    scripts.set("hpNums", hpNums);
	scripts.set("hevNums", hevNums);
    scripts.set("hp", hp);
    scripts.set("divider", divider);
    scripts.set("hevEmpty", hevEmpty);
	scripts.set("hevFull", hevFull);
    scripts.set("damage", damage);
	scripts.set("songPath", "songs/" + PlayState.SONG.meta.name + "/");
	GameOverSubstate.gameOverCharacter = PlayState.instance.boyfriend;

    playerStrums.onMiss.add(hlMiss);

	updateAccuracy();
	activateBotplay(cpuControlled);

	maxCamZoom = 5;
}

function stepHit(step)
{
	if (step == 0) {
		songTitle.playText(0, 80, PlayState.SONG.meta.displayName.toUpperCase());
		songTitle.lettersGroup.screenCenter(1);
	}
}

var lastHealth = health;
var lastAccuracy = accuracy;
function postUpdate(e) 
{
    if (FlxG.keys.justPressed.PAGEDOWN) activateBotplay(cpuControlled = !cpuControlled);

    if (lastHealth != health) updateHealth();
    lastHealth = health;

	if (lastAccuracy != accuracy) updateAccuracy();
    lastAccuracy = accuracy;
}

function onInputUpdate(event) if (cpuControlled) event.cancel();

function updateHealth()
{
	var percentage = Math.round((health / 2) * 100);

	var values = ('' + percentage).split();
	values.reverse();

	var colToSet = boyfriend.iconColor;

	if (percentage <= 10)
		colToSet = 0xFFEE4545;

	hp.color = colToSet;

	var i = 0;
	for (string in values)
	{
		var num = hpNums[i];
		num.alpha = 1;
		num.animation.play(string);

		num.color = colToSet;

		i++;
	}

	if (i <= 2)
		hpNums[2].alpha = 0;

	if (i == 1)
		hpNums[1].alpha = 0;
}

function updateAccuracy()
{
	if (accuracy == -1) 
	{
		hevNums[2].alpha = 0;
		hevNums[1].alpha = 0;
		hevNums[0].color = boyfriend.iconColor;
		return;
	}

	var percentage = Std.int(CoolUtil.quantize(accuracy * 100, 100));

	var values = ('' + percentage).split();
	values.reverse();

	var i = 0;
	for (string in values)
	{
		var num = hevNums[i];
		num.alpha = 1;
		num.animation.play(string);

		num.color = boyfriend.iconColor;

		i++;
	}

	if (i <= 2)
		hevNums[2].alpha = 0;

	if (i == 1)
		hevNums[1].alpha = 0;

	hevFull.clipRect.y = FlxMath.remapToRange(accuracy, 0, 1, Std.int(hevFull.height), 0);
	hevFull.clipRect = hevFull.clipRect;
}
    
function hlMiss(event)
{
	FlxG.sound.play(Paths.sound('damage'));

	for (i in 0...4)
	{
		if (i == event.direction)
		{
			var d = damage[i];
			d.alpha = 1;
			FlxTween.cancelTweensOf(d);
			FlxTween.tween(d, {alpha: 0}, 0.6);
		}
	}
}

function destroy() FlxG.camera.bgColor = 0xFF000000;

function activateBotplay(on)
{
    botplayTxt.visible = on;
	playerStrums.cpu = on;
    botplayTxt.scale.set(1.15, 1.15);

    FlxTween.cancelTweensOf(botplayTxt.scale);
    FlxTween.tween(botplayTxt.scale, {x: 1, y: 1}, 0.35, {ease: FlxEase.cubeOut});
}