import HLTextbox;

var textbox:HLTextbox;

function postCreate()
{
    textbox = new HLTextbox("", false);
    for (i in [textbox, textbox.linesGrp]) {
        i.cameras = [camOther];
        add(i);
    }
}

function onEvent(e)
{
    if (e.event.name == "HL Lyrics")
    {
        textbox.addText(e.event.params[0]);
    }
}