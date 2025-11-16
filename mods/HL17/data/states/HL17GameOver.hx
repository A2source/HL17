import funkin.options.Options;
import funkin.backend.MusicBeatState;
import funkin.menus.StoryMenuState;
import funkin.menus.FreeplayState;
import funkin.editors.charter.Charter;
import HLTypeText;

var fall:FlxSound;
var flatline:FlxSound;
var death:FlxSound;

var minLines:Int = 0;
var maxLines:Int = 4;

var lineTimer:FlxTimer;
var deathTimer:FlxTimer;

var sounds = [];
var character = GameOverSubstate.gameOverCharacter;

var deathTexts:Array<HLTypeText> = [];
var deathInfos:Array<String> = ['SUBJECT: ' + character.extra["gameOverName"], 'STATUS: EVALUATION TERMINATED', 'POSTMORTEM:', 'Subject failed to spit bars.'];

function create(e)
{
    e.cancel();
    FlxG.camera.alpha = 0;
    if (Options.flashingMenu) camHuggy.flash(0xFFF10000, 2.5, null, true);

    fall = FlxG.sound.play(Paths.sound('death/fall'), 1.5);
    if (character.extra["gameOverName"] == "FREEMAN") death = FlxG.sound.play(Paths.sound('death/flatline'));

    if (PlayState.instance.curSong == "huggyteen-dollars") {
        minLines = 5;
        maxLines = 5;
    }

    if (character.extra["gameOverName"] == "FREEMAN") {
        lineTimer = new FlxTimer().start(1.8, ()->
        {
            flatline = FlxG.sound.play(Paths.sound('death/' + FlxG.random.int(minLines, maxLines)));
            sounds.push(flatline);
        });
    }

    sounds = [fall, death];

    for (i in 0...5) {
        var deathText = new HLTypeText(0, 0, "");
        deathText.fadeLetters = false;
        for (i in [deathText, deathText.lettersGroup]) {
            i.cameras = [camHuggy];
            i.screenCenter();
		    add(i);
	    }

        deathTexts.push(deathText);
    }

    deathTimer = new FlxTimer().start(0.5, ()->
    {
        playDeathText(0);
    });
}

function playDeathText(i)
{
    deathTexts[i].playText(0, 0, deathInfos[i], character.iconColor);
    deathTexts[i].lettersGroup.screenCenter();
    deathTexts[i].lettersGroup.y = 230 + 100 * (i == 3 ? i * 0.8 : i);
    if (i != deathInfos.length - 1) deathTexts[i].onComplete = function () {
        playDeathText(i + 1);
    }
}

function update(e)
{
    if (controls.ACCEPT || controls.BACK) {
        for (sound in sounds) if (sound != null && sound.playing) sound.stop();
        for (i in [lineTimer, deathTimer]) if (i != null && i.active) i.cancel();
        for (i in deathTexts) i.onComplete = null;

        if (controls.ACCEPT) {
            for (i in deathTexts) i.lettersGroup.visible = false;
            FlxG.sound.play(Paths.sound('death/hiss'), 1.5);
            if (character.extra["gameOverName"] == "FREEMAN") FlxG.sound.play(Paths.sound('death/restart'), 1.5);
            if (Options.flashingMenu) camHuggy.flash(0xFF865A00, 2.5, null, true);

			new FlxTimer().start(3.2, function(tmr:FlxTimer)
			{
				MusicBeatState.skipTransOut = true;
				FlxG.switchState(new PlayState());
			});
        } else if (controls.BACK) {
            if (PlayState.chartingMode && Charter.undos.unsaved)
				game.saveWarn(false);
			else {
				PlayState.resetSongInfos();
				if (Charter.instance != null) Charter.instance.__clearStatics();

				if (FlxG.sound.music != null)
					FlxG.sound.music.stop();
				FlxG.sound.music = null;

				if (PlayState.isStoryMode)
					FlxG.switchState(new StoryMenuState());
				else
					FlxG.switchState(new FreeplayState());
			}
        }
    }
}