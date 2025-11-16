import funkin.backend.FunkinText;
import funkin.editors.charter.Charter;

var buttons:Array<String> = [
	'RESUME GAME',
	'NEW GAME',
	'QUIT'
];
var texts:Array<FunkinText> = [];
var hitboxes:Array<FlxSprite> = [];

function create(event) 
{
    event.cancel();

	var screen = new FlxSprite().makeGraphic(1, 1, 0x82000000);
	screen.scale.set(100, 100);
	screen.setGraphicSize(FlxG.width, FlxG.height);
	screen.screenCenter();
	screen.cameras = [camOther];
	add(screen);

    camera = pauseCam = new FlxCamera();
    pauseCam.bgColor = 0x00000000;
    FlxG.cameras.add(pauseCam, false);

    var title = new FunkinText(150, 275, -1, "HALF-LIFE 17", 36);
	title.font = Paths.font("halflife2.ttf");
	title.borderSize = 0;
	add(title);

	for (i in 0...buttons.length)
	{
		var option =  new FunkinText(title.x, title.y + 50 + (i * 35), -1, buttons[i], 24);
		option.font = Paths.font('verdana.ttf');
		option.borderSize = 0;
		texts.push(option);

		var hitbox = new FlxSprite();
		hitbox.setPosition(option.x, option.y);
		hitbox.makeGraphic(option.width, option.height, 0x00000000);
		hitbox.ID = i;
		hitboxes.push(hitbox);
		
		add(option);
		add(hitbox);
	}
}

function postCreate(event)
{
	pauseMusic.stop();
}

function update(dt)
{
	if ((controls.BACK || controls.ACCEPT)) close();

	pauseMusic.volume = 0;
	var mpos = FlxG.mouse.getWorldPosition(camera);
	var overlaps:Int = -1;

	for (box in hitboxes) 
	{
		if (mpos.x < box.x || mpos.x > box.x + box.width ||
			mpos.y < box.y || mpos.y > box.y + box.height) continue;

		overlaps = box.ID;

		if (!FlxG.mouse.justPressed) continue;

		chooseOption(box.ID);
	}

	if (overlaps > -1) for (i in 0...texts.length) texts[i].alpha = i != overlaps ? 0.6 : 1;
	else for (t in texts) t.alpha = 1;
}

function chooseOption(i:Int)
{
	switch(i)
	{
		// resume
		case 0: close();
		// restart
		case 1: 
			parentDisabler.reset();
			game.registerSmoothTransition();
			FlxG.resetState();

		// quit
		case 2:	
			if (PlayState.chartingMode && Charter.undos.unsaved)
				game.saveWarn(false);
			else 
			{
				PlayState.resetSongInfos();
				if (Charter.instance != null) Charter.instance.__clearStatics();

				CoolUtil.playMenuSong();
				FlxG.switchState(PlayState.isStoryMode ? new StoryMenuState() : new FreeplayState());
			}
	}
}