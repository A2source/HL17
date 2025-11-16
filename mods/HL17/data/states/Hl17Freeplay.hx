import flixel.FlxSprite;

var bg:FlxSprite;

var songs:Array<{song:String, col:Int, offsetX:Int, scale:Float, unlocked:Bool}> = [
	{
		song: 'gordonteen-bucks',
		col: 0xFFEC4100,
		offsetX: -220,
		scale: 1.35,
		unlocked: true
	},
	{
		song: 'linkinteen-parks',
		col: 0xFF665C2B,
		offsetX: 0,
		scale: 0.95,
		unlocked: true
	},
	{
		song: 'huggyteen-dollars',
		col: 0xFF0077CD,
		offsetX: 100,
		scale: 0.75,
		unlocked: true
	}
];

var portrait:FlxSprite;
var title:FlxSprite;

var selec:Int = 0;

function postCreate()
{
	bg = new FlxSprite().loadGraphic(Paths.image('selec/bg'));
	add(bg);

	portrait = new FlxSprite().loadGraphic(Paths.image('selec/portrait/placeholder'));
	add(portrait);

	title = new FlxSprite().loadGraphic(Paths.image('selec/title/placeholder'));
	add(title);

	select(0);
}

function select(amt:Int)
{
	selec += amt;

	if (selec < 0)
		selec = songs.length - 1;
	if (selec > songs.length - 1)
		selec = 0;

	var cur = songs[selec];

	var portraitToLoad:String = Paths.image('selec/portrait/' + cur.song);
	if (portraitToLoad == null)
		portraitToLoad = Paths.image('selec/portrait/placeholder');

	var titleToLoad:String = Paths.image('selec/title/' + cur.song);
	if (titleToLoad == null)
		titleToLoad = Paths.image('selec/title/placeholder');

	FlxTween.cancelTweensOf(bg);
	FlxTween.cancelTweensOf(portrait);
	FlxTween.cancelTweensOf(title.scale);

	portrait.loadGraphic(portraitToLoad);
	title.loadGraphic(titleToLoad);

	portrait.scale.set(cur.scale, cur.scale);
	portrait.updateHitbox();

	title.x = 325 - title.width / 2;
	title.y = FlxG.height / 2 - title.height / 2;

	title.antialiasing = true;

	bumpTitle();

	portrait.x = FlxG.width - portrait.width - cur.offsetX;
	portrait.y = FlxG.height;

	FlxTween.tween(portrait, {y: portrait.y - portrait.height}, 1, {ease: FlxEase.expoOut});

	FlxTween.color(bg, 1, bg.color, cur.col, {ease: FlxEase.expoOut});
}

function selectSong()
{
	var cur = songs[selec];

	FlxTween.cancelTweensOf(bg);
	FlxTween.cancelTweensOf(portrait);
	FlxTween.cancelTweensOf(title);
	FlxTween.cancelTweensOf(title.scale);

	bumpTitle();

	FlxTween.tween(portrait, {x: FlxG.width}, 2, {ease: FlxEase.expoIn});
	FlxTween.tween(title, {x: -title.width}, 2, {ease: FlxEase.expoIn});

	FlxTween.tween(FlxG.camera, {zoom: 1.8}, 2, {ease: FlxEase.expoIn, startDelay: 0.2});
	FlxTween.color(bg, 2, bg.color, 0xFF000000, {ease: FlxEase.expoIn, startDelay: 0.2});

	FlxG.sound.play(Paths.sound('intro/impact'), 1);

	new FlxTimer().start(2.2, ()->
	{
		PlayState.loadSong(cur.song, 'buck', false, 0);
    	FlxG.switchState(new PlayState());
	});
}

function bumpTitle()
{
	title.scale.set(0.9, 0.9);
	FlxTween.tween(title.scale, {x: 0.7, y: 0.7}, 1, {ease: FlxEase.expoOut});
}

function update(dt:Float)
{
	if (controls.ACCEPT) selectSong();

	if (controls.LEFT_P) select(-1);
	if (controls.RIGHT_P) select(1);

	if (controls.BACK) FlxG.switchState(new ModState('HL17MainMenu'));
}