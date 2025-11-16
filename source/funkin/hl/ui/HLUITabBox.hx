package funkin.hl.ui;

import flixel.FlxState;

class HLUITabBox extends HLUIBox
{
	private var _tabs:Array<HLUITab> = [];
	private var _tabbar:HLUIBox;
	private var _content:HLUIBox;

	public var tabContent:HLUIComponent;

	public function new(tabs:Array<HLUITab>, contentWidth:Int, contentHeight:Int, state:FlxState)
	{
		super(VERTICAL);
		name = 'Tab Box';

		PADDING = 0;

		_tabbar = new HLUIBox(HORIZONTAL);
		_tabbar.PADDING = 0;
		_tabs = tabs;

		@:privateAccess 
		_tabbar.componentHeight = tabs[0]._button.componentHeight;

		for (tab in _tabs)
		{
			tab.associatedTabs = _tabs.copy();
			tab.associatedTabs.remove(tab);
			tab.onSelect = () -> {
				if (tabContent != null)
				{
					_content._components.remove(tabContent);
					tabContent.removeThisAndChildComponentsFromState(state);
				}

				_content.addComponent(tab.content);

				tab.content.addThisAndChildComponentsToState(state);
				tabContent = tab.content;
			}

			_tabbar.addComponent(tab);
		}

		_content = new HLUIBox(VERTICAL);

		addComponent(_content);
		addComponent(_tabbar);

		_content.componentWidth = contentWidth;
		_content.componentHeight = contentHeight;
		_content.componentOffset.y = _tabbar.componentHeight;
		_content.PADDING = 8;
		_content.buildUI({background: true});
	}
}