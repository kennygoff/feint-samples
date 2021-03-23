package player;

import feint.forge.Entity.EntityId;
import feint.forge.Forge;
import feint.library.PositionComponent;
import feint.forge.System;
import feint.renderer.Camera;

private typedef Shape = {
  id:EntityId,
  position:PositionComponent,
}

class PlayerFollowCameraSystem extends System {
  var camera:Camera;
  var boundsWidth:Float;
  var boundsHeight:Float;

  public function new(camera:Camera, boundsWidth:Float, boundsHeight:Float) {
    this.camera = camera;
    this.boundsWidth = boundsWidth;
    this.boundsHeight = boundsHeight;
  }

  override function update(elapsed:Float, forge:Forge) {
    var player:Shape = forge.getShapes([PositionComponent], ['player']).pop();

    camera.translation = {
      x: feint.utils.Math.clampFloat(player.position.x - 80, 0, boundsWidth) * -4,
      y: feint.utils.Math.clampFloat(player.position.y - 80, 0, boundsHeight) * -4
    };
  }
}
