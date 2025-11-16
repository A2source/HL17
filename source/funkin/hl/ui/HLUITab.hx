package funkin.hl.ui;

import flixel.util.FlxSpriteUtil;

class HLUITab extends HLUIBox
{
	private var _button:HLUIButton;
	public var content:HLUIBox;

	public var selected:Bool = false;
	public var onSelect:Void->Void;

	public var associatedTabs:Array<HLUITab> = [];

	public function new(text:String, _content:HLUIBox)
	{
		super(VERTICAL);
		name = 'Tab';

		_button = new HLUIButton(text);
		componentWidth = _button.componentWidth;
		componentHeight = _button.componentHeight;

		_button.onClickCallback = () -> {
			selected = true;
			if (onSelect != null) onSelect();

			for (tab in associatedTabs)
			{
				tab.selected = false;
				@:privateAccess tab._button.buildUI({background: true});
			}

			drawBottomLine();
		}

		addComponent(_button);
		content = _content;
	}

	public function drawBottomLine()
	{
		FlxSpriteUtil.drawLine(
			_button, 
			0, 
			_button.componentHeight, 
			_button.componentWidth, 
			_button.componentHeight, 
			{
				thickness: 2,
				color: HLUIComponent.MAIN_COL
			}
		);
	}
}