import RobloxTextbox;

var characters:Array<String> = [];
var textboxes:Array<RobloxTextbox> = [];

function postCreate()
{
    for (i in strumLines)
    {
        for (c in i.characters) {
            characters.push(c);
        }
    }

    for (i in characters) {
        var textbox = new RobloxTextbox(0, 0);
        textboxes.push(textbox);
        add(textbox);
    }
}

function postUpdate(e) for (i in textboxes) i.update(e);

function onEvent(e)
{
    if (e.event.name != 'ROBLOX Lyrics') return;

    var char = characters[e.event.params[1]];

    var box = textboxes[e.event.params[1]];
    box.playText(e.event.params[0], char);

    box.x -= 80;
    box.y -= 275;

    box.x += e.event.params[2];
    box.y += e.event.params[3];
}