function onEvent(e) 
{
    if (e.event.name == "Set Default Cam Zoom") {
        defaultCamZoom = e.event.params[0];
        if (e.event.params[1] == true) camGame.zoom = defaultCamZoom;
        camZooming = true;
    }
} 