import HLCreditsWindow;
import HLOptionsWindow;
import HLSelectWindow;
import funkin.options.OptionsMenu;
import funkin.editors.EditorPicker;
import Sys;

var bg:FlxSprite;

var logo:FlxSprite;
var blur:FlxSprite;

var big:FlxSprite;

var itemsOrder:Array<String> = [
	'load',
	'credits',
	'options',
	'quit'
];

var items:Array<Array<FlxSprite>> = [];
var touching:Array<Bool> = [];

function postCreate()
{
	if (FlxG.sound.music != null)
		FlxG.sound.music.stop();

	bg = new FlxSprite().loadGraphic(Paths.image('main/bg'));
	add(bg);

	logo = new FlxSprite().loadGraphic(Paths.image('main/logo'));
	logo.screenCenter();
	logo.y = 0;
	logo.x -= 20;
	add(logo);

	blur = new FlxSprite().loadGraphic(Paths.image('main/blure'));
	blur.alpha = 0;
	add(blur);

	big = new FlxSprite().loadGraphic(Paths.image('main/blure'));
	big.alpha = 0.5;
	big.scale.x = 1.7;
	big.scale.y = 2.2;
	add(big);

	var i:Int = 0;
	for (item in itemsOrder)
	{
		var cur:Array<FlxSprite> = [];

		var text = new FlxSprite(50, 350 + (58 * i)).loadGraphic(Paths.image('main/' + item));
		var blur = new FlxSprite(text.x, text.y).loadGraphic(Paths.image('main/' + item + '-blur'));
		blur.blend = 1;
		blur.alpha = 0;

		cur.push(text);
		cur.push(blur);
		
		for (t in cur)
			add(t);

		items.push(cur);
		touching.push(false);

		i++;
	}

	tweenLogo();
}

function update(dt:Float)
{
	blur.setPosition(logo.x, logo.y);
	big.setPosition(logo.x * 2.5, logo.y + 60);

	for (i in 0...items.length)
	{
		if (optionsWindowHovering())
		{
			if (touching[i]) fadeBlur(i, false);
			touching[i] = false;

			continue;
		} 
		var overlap:Bool = FlxG.mouse.overlaps(items[i][0]);
		
		if (overlap != touching[i])
			fadeBlur(i, overlap);

		touching[i] = overlap;

		if (overlap && FlxG.mouse.justPressed)
			selectItem(i);
	}

	if (FlxG.random.bool(1))
		flickerLogo();

	if (controls.BACK && !optionsHasFocus())
		FlxG.switchState(new ModState('IntroState'));

	if (FlxG.keys.justPressed.SEVEN) {
		persistentUpdate = false;
		persistentDraw = true;
		openSubState(new EditorPicker());
	}
}

function fadeBlur(index:Int, overlap:Bool)
{
	var cur:Array<FlxSprite> = items[index];
	var blur:FlxSprite = cur[1];

	FlxTween.cancelTweensOf(blur);
	FlxTween.tween(blur, {alpha: overlap ? 1 : 0}, overlap ? 0.1 : 1, {ease: FlxEase.expoOut});
}

var selectWindow:HLSelectWindow;
var creditsWindow:HLCreditsWindow;
var optionsWindow:HLOptionsWindow;
function selectItem(index:Int)
{
	var selec:String = itemsOrder[index];
	
	switch(selec)
	{
		case 'load':
			if (optionsWindow != null) 
			{
				optionsWindow.volume = 0;
				optionsWindow.visible = false;
			}
			if (creditsWindow != null) 
			{
				creditsWindow.volume = 0;
				creditsWindow.visible = false;
			}

			if (selectWindow != null)
			{
				selectWindow.volume = 1;
				selectWindow.center();
				selectWindow.visible = true;

				return;
			}

			selectWindow = new HLSelectWindow();
			selectWindow.initializeAndAddToState(this);

		case 'options':
			if (selectWindow != null) 
			{
				selectWindow.volume = 0;
				selectWindow.visible = false;
			}
			if (creditsWindow != null) 
			{
				creditsWindow.volume = 0;
				creditsWindow.visible = false;
			}

			if (optionsWindow != null)
			{
				optionsWindow.volume = 1;
				optionsWindow.center();
				optionsWindow.visible = true;

				return;
			}

			optionsWindow = new HLOptionsWindow();
			optionsWindow.initializeAndAddToState(this);

		case 'credits':
			if (optionsWindow != null) 
			{
				optionsWindow.volume = 0;
				optionsWindow.visible = false;
			}
			if (selectWindow != null) 
			{
				selectWindow.volume = 0;
				selectWindow.visible = false;
			}

			if (creditsWindow != null)
			{
				creditsWindow.volume = 1;
				creditsWindow.center();
				creditsWindow.visible = true;

				return;
			}

			creditsWindow = new HLCreditsWindow();
			creditsWindow.initializeAndAddToState(this);

		case 'quit':
			Sys.exit(0);

		default:
			// lol
	}
}

function optionsHasFocus():Bool
{
	if (optionsWindow == null) return false;
	if (!optionsWindow.visible) return false;

	@:privateAccess
	return optionsWindow._settingBind;
}

function optionsWindowHovering():Bool
{
	if (optionsWindow == null) return false;
	if (!optionsWindow.visible) return false;

	@:privateAccess
	return optionsWindow._hovered;
}

function flickerLogo()
{
	blur.alpha = 1;
	big.alpha = 0.8;

	new FlxTimer().start(0.05, ()->
	{
		blur.alpha = 0;
		big.alpha = 0.5;
	});
}

function tweenLogo(?tween:FlxTween)
{
	FlxTween.tween(logo, {x: logo.x + 70}, 2, {
		onComplete: (t:FlxTween)->
		{
			FlxTween.tween(logo, {x: logo.x - 30}, 0.3, {
				onComplete: (t:FlxTween)->
				{
					FlxTween.tween(logo, {x: logo.x + 30}, 0.3, {
					onComplete: (t:FlxTween)->
					{
						FlxTween.tween(logo, {x: logo.x - 80}, 3, {onComplete: (t:FlxTween)->
						{
							FlxTween.tween(logo, {x: logo.x + 50}, 0.5, {onComplete: (t:FlxTween) ->
							{
								FlxTween.tween(logo, {x: logo.x - 40}, 2, {onComplete: tweenLogo});
							}});
						}});
					}});
				}});
		}});
}