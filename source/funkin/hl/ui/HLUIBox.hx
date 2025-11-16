package funkin.hl.ui;

import flixel.math.FlxPoint;
import funkin.hl.ui.HLUIComponent.HLUIComponentDrawStyle;

enum Layout
{
	HORIZONTAL;
	VERTICAL;
}

class HLUIBox extends HLUIComponent
{
	private var _layout:Layout;

	public function new(layout:Layout)
	{
		super();

		_layout = layout;
		name = 'Box';
	}

	public var PADDING:Int = 4;
	public var globalPush:FlxPoint = FlxPoint.weak();

	override function addComponent(component:HLUIComponent, ?drawStyle:HLUIComponentDrawStyle):Void
	{
		super.addComponent(component, drawStyle);

		if (_components.indexOf(component) == 0)
		{
			switch(_layout)
			{
				case HORIZONTAL: component.push.x = PADDING;
				case VERTICAL: component.push.y = PADDING;
			}
		}

		if (_components.length > 1)
		{
			var prevComponent:HLUIComponent = _components[_components.length - 2];
			
			// trace('We are adding component $component to parent $this');

			// @:privateAccess
			// trace(prevComponent, prevComponent.componentWidth, prevComponent.componentHeight, prevComponent._components);

			switch(_layout)
			{
				case HORIZONTAL: 
					component.push.x = (
						globalPush.x + 
						prevComponent.push.x + 
						prevComponent.componentOffset.x + 
						prevComponent.componentWidth + 
						PADDING
					);

				case VERTICAL: 
					component.push.y = (
						globalPush.y + 
						prevComponent.push.y + 
						prevComponent.componentOffset.y + 
						prevComponent.componentHeight + 
						PADDING
					);
			}
		}
	}
}