import flixel.FlxG;
import flixel.FlxState;

class HLSelectWindow extends HLUIWindow
{
	private static var WINDOW_WIDTH:Int = 600;
	private static var WINDOW_HEIGHT:Int = 422;

	private var _x:Float;
	private var _y:Float;

	private var _portrait:HLUIComponent;

	private var _songs:Array<Dynamic> = [
		{
			pointer: 'gordonteen-bucks',
			label: 'Gordonteen Bucks'
		},
		{
			pointer: 'huggyteen-dollars',
			label: 'Huggyteen Dollars'
		},
		{
			pointer: 'linkinteen-parks',
			label: 'Linkinteen Parks'
		}
	];

	public var selectedSong:Dynamic;
	private var _selected:Int = 0;

	public function new(__x:Float, __y:Float)
	{
		_x = __x;
		_y = __y;

		center();

		super(x, y, WINDOW_WIDTH, WINDOW_HEIGHT);
		componentWidth = WINDOW_WIDTH;
		componentHeight = WINDOW_HEIGHT;

		_titlebar.componentWidth = WINDOW_WIDTH;
		_titlebar.componentHeight = 35;
		_titlebarLabel.text = 'Chapter Select';
		_titlebarClose.componentOffset.x = WINDOW_WIDTH - 132;
		_titlebarClose.componentOffset.y = 4;
	}

	private var _portrait:HLUIComponent;
	private var _boxes:HLUIBox;
	private var _songLabel:HLUIButton;

	public function initializeAndAddToState(state:FlxState)
	{
		var content:HLUIBox = new HLUIBox(Layout.VERTICAL);
		content.componentOffset.x = 6;
		
		var carousel:HLUIBox = new HLUIBox(Layout.HORIZONTAL);
		carousel.componentOffset.set(0, 2);

		_boxes = new HLUIBox(Layout.HORIZONTAL);
		_boxes.componentOffset.set(275, 10);

		var leftButton:HLUIButton = new HLUIButton("<");

		_portrait = new HLUIComponent();
		_portrait.scale.set(0.5, 0.5);

		var rightButton:HLUIButton = new HLUIButton(">");

		_songLabel = new HLUIButton("Song");
		_songLabel.onClick = null;
		_songLabel.onRelease = null;

		for (i in 0..._songs.length) _boxes.addComponent(new HLUIComponent());

		changeSelection(0);

		leftButton.componentWidth += 12;
		leftButton.componentHeight = _portrait.componentHeight;
		rightButton.componentWidth += 12;
		rightButton.componentHeight = _portrait.componentHeight;

		leftButton.onClickCallback = () -> {
			changeSelection(-1);
		}
		leftButton.buildUI({background: true});
		leftButton._label.componentOffset.x = 6;
		leftButton._label.componentOffset.y = 115;

		rightButton.onClickCallback = () -> {
			changeSelection(1);
		}
		rightButton.buildUI({background: true});
		rightButton._label.componentOffset.x = 6;
		rightButton._label.componentOffset.y = 115;

		carousel.addComponent(leftButton);
		carousel.addComponent(_portrait);
		carousel.addComponent(rightButton);

		carousel.componentHeight = _portrait.componentHeight;

		content.addComponent(_songLabel);
		content.addComponent(carousel);
		content.addComponent(_boxes);

		var buttons = new HLUIBox(Layout.HORIZONTAL);

		var load = new HLUIButton("Load Game");
		load.onClickCallback = () -> {
			PlayState.loadSong(selectedSong.pointer, 'buck', false, 0);
    		FlxG.switchState(new PlayState());
		}
		load.componentOffset.y = 8;

		var cancel = new HLUIButton("Cancel");
		cancel.onClickCallback = () -> {
			visible = false;
		}
		cancel.componentOffset.set((
			WINDOW_WIDTH - 
			buttons.componentWidth - 
			load.componentOffset.x - 
			cancel.componentOffset.x - 
			load.componentWidth - 
			cancel.componentWidth - 
			24
		), 8);

		buttons.addComponent(load);
		buttons.addComponent(cancel);

		var line = new HLUIComponent();
		line.componentWidth = WINDOW_WIDTH - 20;
		line.componentHeight = 2;
		line.componentOffset.y = 16;
		line.buildUI({background: true});

		content.addComponent(line);
		content.addComponent(buttons);

		addComponent(content);
		buildUI({background: true});
		addThisAndChildComponentsToState(state);
	}

	private var _boxSize:Int = 8;
	private function changeSelection(amt:Int):Void
	{
		_selected += amt;
		if (_selected < 0) _selected = 0;
		else if (_selected > _songs.length - 1) _selected = _songs.length - 1;

		selectedSong = _songs[_selected];

		var graphic = Paths.image("songSelect/" + selectedSong.pointer);
		if (graphic == null) graphic = Paths.image("songSelect/placeholder");
		_portrait.loadGraphic(graphic);

		_songLabel.setText(selectedSong.label);
		_songLabel.buildUI({altCol: true});
		_songLabel.componentOffset.x = Std.int(WINDOW_WIDTH / 2 - _songLabel.componentWidth / 2);

		var prevComponent:HLUIComponent;
		_boxes.forEachComponent((component) ->
		{
			var i:Int = _boxes._components.indexOf(component);
			var isSelected:Bool = i == _selected;

			if (isSelected) 
			{
				component.makeGraphic(_boxSize * 2, _boxSize * 2, HLUILabel.TEXT_COL);
				component.alpha = 1;
			}
			else 
			{
				component.makeGraphic(_boxSize, _boxSize, HLUILabel.TEXT_COL);
				component.alpha = 0.5;			
			}

			component.offset.set(0, 0);
			component.componentOffset.set(0, 0);

			if (prevComponent != null) 
			{
				component.componentOffset.x = (
					prevComponent.componentWidth + 
					prevComponent.push.x + 
					prevComponent.componentOffset.x +
					8
				);
			}
			else 
			{
				if (isSelected) component.offset.x = 8; 
			}

			if (isSelected) 
			{
				component.componentOffset.x -= _boxSize / 2;
				component.componentOffset.y -= _boxSize / 2;
			}

			prevComponent = component;
		});
	}

	public function center():Void
	{
		if (_x == null) x = Std.int((FlxG.width / 2)  - (WINDOW_WIDTH / 2));
		else x = _x;
		if (_y == null) y = Std.int((FlxG.height / 2)  - (WINDOW_HEIGHT / 2));
		else y = _y;
	}
}