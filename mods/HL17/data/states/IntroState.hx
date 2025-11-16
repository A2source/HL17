var bf:FlxSprite;
var text:FlxSprite;

function postCreate()
{
	FlxG.camera.bgColor = 0xFF000000;

	bf = new FlxSprite();
	bf.frames = Paths.getFrames('intro/bf');
	bf.animation.addByPrefix('idle', 'bf', 8, true);
	bf.animation.play('idle');
	bf.screenCenter();
	add(bf);

	bf.alpha = 0;

	text = new FlxSprite();
	text.frames = Paths.getFrames('intro/funkin');
	text.animation.addByPrefix('idle', 'funkin', 8, true);
	text.animation.play('idle');
	text.screenCenter();
	text.y += 50;
	add(text);

	text.alpha = 0;

	new FlxTimer().start(1.25, ()-> 
	{
		FlxG.sound.play(Paths.sound('intro/soundFull'), 1);

		FlxTween.tween(bf, {alpha: 1}, 2, {ease: FlxEase.expoOut, startDelay: 1, 
			onComplete: (t:FlxTween)->
			{
				FlxTween.tween(bf, {y: bf.y - 100}, 2, {ease: FlxEase.expoOut});
				FlxTween.tween(text, {alpha: 1, y: text.y + 100}, 2, {ease: FlxEase.expoOut});

				new FlxTimer().start(2.5, ()->
				{
					new FlxTimer().start(1.5, ()->
					{
						FlxG.sound.play(Paths.sound('intro/' + FlxG.random.int(0, 12)), 0.25);
					});

					FlxTween.tween(bf, {alpha: 0}, 3);
					FlxTween.tween(text, {alpha: 0}, 3.01, 
						{onComplete: (t:FlxTween)->
						{
							complete();
						}});
				});
			}});
	});
}

var ending:Bool = false;
function update(dt:Float)
{
	if (controls.ACCEPT && !ending) complete();
}

function complete()
{
	ending = true;
	
	FlxTween.cancelTweensOf(bf);
	FlxTween.cancelTweensOf(text);

	bf.destroy();
	text.destroy();

	new FlxTimer().start(1.2, ()->
	{
		FlxG.switchState(new ModState('HL17MainMenu'));
	});
}