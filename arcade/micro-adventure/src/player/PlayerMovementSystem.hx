package player;

import feint.library.VelocityComponent;
import feint.forge.Forge;
import player.PlayerActionsComponent;
import feint.forge.Entity.EntityId;
import feint.forge.System;

private typedef Shape = {
  id:EntityId,
  velocity:VelocityComponent,
  actions:PlayerActionsComponent
}

class PlayerMovementSystem extends System {
  static final movementSpeed = 48;

  public function new() {}

  override function update(elapsed:Float, forge:Forge) {
    var player = forge.getShapes([VelocityComponent, PlayerActionsComponent]).pop();

    var x = 0;
    var y = 0;

    if (player.actions.left) {
      x = -1;
    } else if (player.actions.right) {
      x = 1;
    }

    if (player.actions.up) {
      y = -1;
    } else if (player.actions.down) {
      y = 1;
    }

    var movementVectorLength = Math.sqrt((x * x) + (y * y));
    if (movementVectorLength > 0) {
      player.velocity.x = movementSpeed * (x / movementVectorLength);
      player.velocity.y = movementSpeed * (y / movementVectorLength);
    } else {
      player.velocity.x = 0;
      player.velocity.y = 0;
    }
  }
}
