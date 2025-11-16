package funkin.hl.ui;

typedef HLUITableSet =
{
	var columns:Array<String>;
	var rows:Array<Array<String>>;
}

typedef HLUITableRow =
{
	var labels:Array<HLUIComponent>;
	var box:HLUIBox;
	var index:Int;
}

class HLUITable extends HLUIBox
{
	public static var HIGHLIGHT_COL:Int = 0xFF958831;

	private var _rows:Array<HLUIBox> = [];
	public var selectedRow:HLUITableRow = null;

	public function new(sets:Array<HLUITableSet>, columnWidths:Array<Int>)
	{
		super(VERTICAL);
		PADDING = 0;

		var maxWidth:Int = 0;
		for (i in columnWidths) maxWidth += i;
		componentWidth = maxWidth;

		var maxHeight:Int = 0;
		for (set in sets)
		{
			var thisSet = new HLUIBox(VERTICAL);
			thisSet.PADDING = 0;

			var thisTitleBox = new HLUIBox(HORIZONTAL);
			thisTitleBox.componentWidth = maxWidth;

			for (i in 0...set.columns.length)
			{
				var thisTitle = new HLUILabel(set.columns[i]);
				thisTitle.textCol = HLUICheckbox.TEXT_SELEC_COL;
				thisTitle.size = 10;

				thisTitle.componentWidth = columnWidths[i];
				thisTitleBox.addComponent(thisTitle);
				if (thisTitleBox.componentHeight == 1) thisTitleBox.componentHeight = thisTitle.componentHeight;

			}
			thisTitleBox.buildUI({altCol: true});

			thisSet.addComponent(thisTitleBox);

			var theseRows = new HLUIBox(VERTICAL);
			theseRows.componentWidth = maxWidth;
			for (row in set.rows)
			{
				var thisRow = new HLUIBox(HORIZONTAL);
				for (i in 0...row.length)
				{
					var thisText = new HLUILabel(row[i]);
					thisText.componentWidth = columnWidths[i];
					if (thisRow.componentHeight == 1) thisRow.componentHeight = thisText.componentHeight;
					thisRow.addComponent(thisText);
				}
				thisRow.componentWidth = maxWidth;

				theseRows.addComponent(thisRow);
				theseRows.componentHeight = Std.int(thisRow.push.y + thisRow.componentHeight + 4);

				thisRow.onClick = () -> {
					selectRow(thisRow);
				}
				_rows.push(thisRow);
			}

			thisSet.componentHeight = Std.int(thisTitleBox.componentHeight + thisTitleBox.push.y + theseRows.componentHeight + theseRows.push.y);
			theseRows.buildUI({table: true});

			thisSet.addComponent(theseRows);

			maxHeight += thisSet.componentHeight;

			addComponent(thisSet);
		}

		componentHeight = maxHeight;
	}

	private function selectRow(rowToSelect:HLUIBox)
	{
		@:privateAccess
		selectedRow = {
			labels: rowToSelect._components,
			box: rowToSelect,
			index: _rows.indexOf(rowToSelect)
		};

		for (row in _rows)
		{
			if (row == selectedRow.box) row.buildUI({tableSelected: true});
			else row.buildUI({altCol: true});
		}
	}
}