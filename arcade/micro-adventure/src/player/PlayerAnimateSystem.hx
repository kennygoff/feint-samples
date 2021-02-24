package player;

import feint.forge.Entity.EntityId;
import feint.library.VelocityComponent;
import feint.library.SpriteComponent;
import feint.forge.Forge;
import feint.forge.System;

private typedef Shape = {
  id:EntityId,
  velocity:VelocityComponent,
  sprite:SpriteComponent
}

class PlayerAnimateSystem extends System {
  public function new() {}

  override function update(elapsed:Float, forge:Forge) {
    var player:Shape = forge.getShapes([VelocityComponent, SpriteComponent], ['player']).pop();

    if (player.velocity.x > 0) {
      if (player.sprite.sprite.animation.currentAnimation != "move:right") {
        player.sprite.sprite.animation.play("move:right", 8, true);
      }
    } else if (player.velocity.x < 0) {
      if (player.sprite.sprite.animation.currentAnimation != "move:left") {
        player.sprite.sprite.animation.play("move:left", 8, true);
      }
    } else if (player.velocity.y != 0) {
      if (player.sprite.sprite.animation.currentAnimation != "move:right") {
        player.sprite.sprite.animation.play("move:right", 8, true);
      }
    } else {
      if (player.sprite.sprite.animation.currentAnimation != "idle") {
        player.sprite.sprite.animation.play("idle", 8, true);
      }
    }
  }
}
