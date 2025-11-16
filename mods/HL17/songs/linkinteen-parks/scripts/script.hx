import funkin.options.Options;
import hxvlc.flixel.FlxVideoSprite;
import flixel.util.FlxTimer;
import Bopper;

var curChar:Int = 1;
var chars:Array<Character> = [];

var kleinerVideo:FlxVideoSprite;
var kleinerBopper:Bopper;
var eliVideo:FlxVideoSprite;
var intro:FlxVideoSprite;

var compression:CustomShader;
var adjustColor:CustomShader;

function create()
{
	FlxG.autoPause = false;

	kleinerBopper = new Bopper(1196, -12).setCharacter('songs/linkinteen-parks/Kleiner BG');
	kleinerBopper.visible = false;
	kleinerBopper.scale.set(0.75, 0.75);
	insert(0, kleinerBopper);

	kleinerVideo = new FlxVideoSprite();
	kleinerVideo.load(Assets.getPath(Paths.video('kleinerBG')));
	kleinerVideo.visible = false;
	insert(0, kleinerVideo);

	eliVideo = new FlxVideoSprite();
	eliVideo.load(Assets.getPath(Paths.video('eliBG')));
	eliVideo.visible = false;
	insert(0, eliVideo);

	intro = new FlxVideoSprite();
	intro.load(Assets.getPath(Paths.video('intro')));

	if (Options.gameplayShaders) {
		adjustColor = new CustomShader('adjustColor');
		adjustColor.saturation = 3;
		adjustColor.contrast = -7;
		kleinerBopper.shader = adjustColor;
	}
}

function postCreate()
{	
	FlxG.autoPause = true;
	defaultCamZoom = 1.35;
	FlxG.camera.zoom = 1.35;
	dad.visible = false;

	curCameraTarget = -1;

	for (i in 1...5) 
	{
		var char = strumLines.members[1].characters[i];
		char.visible = false;

		switch(i)
		{
			case 1:
				char.setPosition(370, -100);

			case 3, 4:
				char.x -= 60;
		}
	}

	for (video in [eliVideo, kleinerVideo])
	{
		video.scale.set(0.75, 0.75);
		video.updateHitbox();
		video.x += 390;
		video.y -= 90;

		video.play(); // This fixes a visual issue where the video doesnt play until a little bit after it should
		new FlxTimer().start(0.0001, function(tmr) {
			video.pause();
		});
	}

	FlxG.camera.visible = false;
	camHUD.alpha = 0.001;

	if (Options.gameplayShaders) {
		compression = new CustomShader('compression');
		for (i in [FlxG.camera, camHUD, camHuggy]) i.addShader(compression);
	}

	remove(comboGroup);
}

function goodNoteHit(e) e.showRating = false;

function pauseShit(pause:Bool = true)
{
	for (i in [intro, eliVideo, kleinerVideo]) if (i != null && i.visible) {
		if (pause) i.pause() else i.resume();
	}
}

function onFocus() if (!paused) pauseShit(false);
function onFocusLost() pauseShit(true);
function onSubstateOpen(e) pauseShit(true);
function onSubstateClose(e) pauseShit(false);

function onSongStart()
{
	intro.play();
	intro.cameras = [camHuggy];
	intro.bitmap.onEndReached.add(() ->
	{
		intro.visible = false;
		intro.destroy();

		if (Options.flashingMenu) camHuggy.flash(0xFFFFFFFF, 2);
		FlxG.camera.visible = true;
	});
	intro.bitmap.rate += 0.005;
	intro.scale.set(1.5, 1.5);

	intro.x += 213;
	intro.y += 120;
	add(intro);
}

function beatHit(beat)
{
	switch(beat)
	{
		case 100, 164, 232, 296: incrementChar();
		case 164: FlxTween.tween(camGame, {zoom: 1.65}, 0.01);
		case 228: FlxTween.tween(camGame, {zoom: 1.35}, 2, {ease: FlxEase.quadOut});
		case 297: FlxTween.tween(camGame, {zoom: 1.7}, 17.5, {ease: FlxEase.quadOut});
	}

	if (beat % 2 == 0) kleinerBopper.animation.play('idle', true);
}

function stepHit(step)
{
	switch (step)
	{
		case 120: FlxTween.tween(camHUD, {alpha: 1}, 0.5);
		case 393, 920: camHuggy.fade(0xFF000000, 0.75, false);
		case 400, 656, 928: camHuggy.fade(Options.flashingMenu ? 0xFFFFFFFF : 0xFF000000, 2, true);
		case 1184: camHuggy.flash(0xFF000000, 2);

		case 1312:
			FlxG.camera.visible = false;
			camHUD.visible = false;
	}
}

function incrementChar()
{
	strumLines.members[1].characters[curChar - 1].visible = false;
	strumLines.members[1].characters[curChar].visible = true;
	strumLines.members[1].characters[curChar].playAnim("idle", true);
	GameOverSubstate.gameOverCharacter = strumLines.members[1].characters[curChar];

	switch(curChar)
	{
		case 1:
			eliVideo.visible = true;
			kleinerBopper.visible = true;
			eliVideo.resume();

		case 2:
			eliVideo.visible = false;
			kleinerBopper.visible = false;
			eliVideo.destroy();

			kleinerVideo.visible = true;
			kleinerVideo.resume();

		case 3:
			kleinerVideo.visible = false;
			kleinerVideo.destroy();
	}

	curChar++;
}