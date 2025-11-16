package funkin.hl.ui;

class HLUICheckbox extends HLUIBox
{
	public static var TEXT_SELEC_COL:Int = 0xFFC4B550;

	public static var UNSELEC_IMG:String = "assets/images/check0.png";
	public static var SELEC_IMG:String = "assets/images/check1.png";

	private var _image:HLUIComponent;
	private var _label:HLUILabel;

	public var selected:Bool = false;
	public var onChange:Bool->Void;

	public function new(text:String = "Checkbox", value:Bool = false)
	{
		super(HORIZONTAL);
		name = 'Checkbox';

		selected = value;

		_image = new HLUIComponent();

		if (value ) _image.loadGraphic(SELEC_IMG);
		else _image.loadGraphic(UNSELEC_IMG);

		_image.onClick = () ->
		{
			selected = !selected;

			if (selected) 
			{
				_image.loadGraphic(SELEC_IMG);
				_label.textCol = TEXT_SELEC_COL;
			}
			else 
			{
				_image.loadGraphic(UNSELEC_IMG);
				_label.textCol = HLUILabel.TEXT_COL;
			}

			if (onChange != null) onChange(selected);
		}

		_label = new HLUILabel(text);
		_label.componentOffset.y = 4;
		if (value) _label.textCol = TEXT_SELEC_COL;

		addComponent(_image);
		addComponent(_label);

		componentWidth = Std.int(_image.componentWidth + _label.push.x + _label.componentWidth);
		componentHeight = Std.int(_image.componentHeight + _label.push.y + _label.componentHeight);
	}
}