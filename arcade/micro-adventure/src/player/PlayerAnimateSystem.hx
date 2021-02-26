package player;

import player.PlayerStateComponent;
import feint.forge.Entity.EntityId;
import feint.library.VelocityComponent;
import feint.library.SpriteComponent;
import feint.forge.Forge;
import feint.forge.System;

private typedef Shape = {
  id:EntityId,
  velocity:VelocityComponent,
  sprite:SpriteComponent,
  state:PlayerStateComponent
}

class PlayerAnimateSystem extends System {
  public function new() {}

  override function update(elapsed:Float, forge:Forge) {
    var player:Shape = forge.getShapes(
      [VelocityComponent, SpriteComponent, PlayerStateComponent],
      ['player']
    )
      .pop();

    if (player.state.attacking) {
      if (
        player.state.facing == Down &&
        player.sprite.sprite.animation.currentAnimation != "attack:down"
      ) {
        player.sprite.sprite.animation.play("attack:down", 6, true);
      } else if (
        player.state.facing == Up &&
        player.sprite.sprite.animation.currentAnimation != "attack:up"
      ) {
        player.sprite.sprite.animation.play("attack:up", 6, true);
      } else if (
        player.state.facing == Left &&
        player.sprite.sprite.animation.currentAnimation != "attack:left"
      ) {
        player.sprite.sprite.animation.play("attack:left", 6, true);
      } else if (
        player.state.facing == Right &&
        player.sprite.sprite.animation.currentAnimation != "attack:right"
      ) {
        player.sprite.sprite.animation.play("attack:right", 6, true);
      }
    } else if (player.velocity.x > 0) {
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
