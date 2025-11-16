function onEvent(e)
{
    if (e.event.name == "Camera Follow Pos")
    {
        if (e.event.params[2] == true) {
            curCameraTarget = scripts.get("lastCameraTarget");
            return;
        }

        scripts.set("lastCameraTarget", curCameraTarget);
        curCameraTarget = -1;
        camFollow.x = e.event.params[0];
        camFollow.y = e.event.params[1];
    }

    /*
    if (e.event.name == "Camera Movement")
    {
        scripts.set("lastCameraTarget", e.event.params[0]);
        e.cancel();
    }
    */
}