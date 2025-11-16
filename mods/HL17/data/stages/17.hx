import flx3d.Flx3DView;
import flx3d.Flx3DUtil;
import openfl.system.System;
import away3d.core.base.Geometry;
import flixel.FlxCamera;
import flx3d.Flx3DCamera;
import flixel.FlxCamera;
import away3d.cameras.lenses.PerspectiveLens;
import funkin.options.Options;

public var view:Flx3DView;

function postCreate() 
{
    if (curSong == "linkinteen-parks") return;

    if (gf != null) gf.scrollFactor.set(0.6, 0.6);
    FlxG.camera.followLerp *= 3;
    FlxG.camera.zoom = 0.6;
    defaultCamZoom = 0.6;
    camGame.bgColor = 0xFFFFFFFF;

    if (SONG.meta.displayName == "Gordonteen Bucks") {
        curCameraTarget = -1;
        camFollow.x = 335;
        camFollow.y = -400;
    }

    if (Options.lowMemoryMode) return;
    Flx3DUtil.is3DAvailable();

    view = new Flx3DView(0, 0, FlxG.width * 2, FlxG.height * 2);
    view.screenCenter();
    view.scrollFactor.set();
    view.view.camera.lens.far = 400000000;
    view.antialiasing = true;

    insert(members.indexOf(gf), view);
    insert(members.indexOf(dad), view);
    insert(members.indexOf(boyfriend), view);

	view.addModel(Paths.obj('plane'), (model) ->
    {
		if (Std.string(model.asset.assetType) != 'mesh') 
            return;

        model.asset.scale(2000);
        model.asset.x = 0;
        model.asset.y = -400;
        model.asset.z = 0;
        model.asset.rotationX = 2;

	}, Paths.image('textures/gradient'), false);
}

function postUpdate(e)
{
    if (curSong == "linkinteen-parks" || Options.lowMemoryMode) return;
    view.view.camera.x = FlxG.camera.scroll.x + 200;
    view.view.camera.y = -FlxG.camera.scroll.y - 200;
    view.view.camera.z = -1300 + (FlxG.camera.zoom * 400);
}

function destroy() if (curSong != "linkinteen-parks" || Options.lowMemoryMode) view.destroy();