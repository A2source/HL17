var replace:Map<FlxState, String> = 
[
    TitleState => 'IntroState',
	MainMenuState => 'HL17MainMenu',
	FreeplayState => 'HL17MainMenu'
];

function preStateSwitch() 
{
	for (state in replace.keys()) 
		if (Std.isOfType(FlxG.game._requestedState, state)) 
			FlxG.game._requestedState = new ModState(replace.get(state));
}

var volumeTicks:Array<HLUIComponent> = [];
var volumeTray:HLUIBox;

var TRAY_WIDTH:Int = 125;
var TRAY_HEIGHT:Int = 30;

var PADDING:Int = 4;

function postStateSwitch() 
{
	volumeTicks = [];

	trayCamera = new FlxCamera();
	trayCamera.bgColor = 0;
	FlxG.cameras.add(trayCamera, false);

	volumeTray = new HLUIBox(Layout.VERTICAL);
	volumeTray.componentWidth = TRAY_WIDTH;
	volumeTray.componentHeight = TRAY_HEIGHT;

	var volumeMeter = new HLUIBox(Layout.HORIZONTAL);
	volumeMeter.componentWidth = TRAY_WIDTH - PADDING;
	volumeMeter.componentHeight = TRAY_HEIGHT - PADDING * 2;
	volumeMeter.componentOffset.set(
		TRAY_WIDTH / 2 -
		volumeMeter.componentWidth / 2
	,
		TRAY_HEIGHT / 2 -
		volumeMeter.componentHeight / 2 -
		PADDING / 1.5
	);

	for (i in 0...10)
	{
		var volumeTick = new HLUIComponent();
		volumeTick.componentWidth = volumeMeter.componentWidth / 10 - PADDING / 2;
		volumeTick.componentHeight = volumeMeter.componentHeight - PADDING;
		volumeTick.componentOffset.x = -PADDING / 2;
		volumeTick.componentOffset.y = PADDING / 2;
		volumeTick.makeGraphic(volumeTick.componentWidth, volumeTick.componentHeight, HLUILabel.TEXT_COL);
		volumeMeter.addComponent(volumeTick);

		volumeTicks.push(volumeTick);
	}

	volumeTray.buildUI({background: true});
	volumeMeter.buildUI({altCol: true});
	volumeTray.addComponent(volumeMeter);

	volumeTray.addThisAndChildComponentsToState(FlxG.state);
	volumeTray.screenCenter();
	volumeTray.y = 8;

	FlxG.sound.soundTrayEnabled = false;
	volumeTray.visible = false;
	volumeTray.cameras = [trayCamera];
}

var lastVolume:Int = 1;
var globalVolume:Int = 1;
var lastMuted:Bool = false;
var trayTimer:FlxTimer;

var LOW_ALPHA:Float = 0.25;
var FULL_ALPHA:Float = 1;

function update(dt:Float) 
{
	if ((lastVolume != globalVolume) || (lastMuted != FlxG.sound.muted))
	{
		volumeTray.visible = true;
		if (trayTimer != null) trayTimer.cancel();

		trayTimer = new FlxTimer().start(1, (t) -> {
			volumeTray.visible = false;
		});
	}

	lastVolume = globalVolume;
	globalVolume = Std.int(FlxG.sound.volume * 10);
	
	lastMuted = FlxG.sound.muted;
	for (i in 0...10)
	{
		if (lastMuted) volumeTicks[i].alpha = LOW_ALPHA;
		else volumeTicks[i].alpha = i < globalVolume ? FULL_ALPHA : LOW_ALPHA;
	} 
}

function getVolume():Int
{
	return ;
}