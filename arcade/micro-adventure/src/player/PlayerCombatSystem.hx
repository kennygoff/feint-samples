package player;

import feint.forge.Entity.EntityId;
import player.PlayerStateComponent;
import feint.forge.Forge;
import feint.forge.System;

private typedef Shape = {
  id:EntityId,
  actions:PlayerActionsComponent,
  state:PlayerStateComponent,
}

class PlayerCombatSystem extends System {
  public function new() {}

  override function update(elapsed:Float, forge:Forge) {
    var player:Shape = forge.getShapes([PlayerActionsComponent, PlayerStateComponent], ['player'])
      .pop();

    if (player.state.attacking) {
      player.state.attackFrame++;
      if (player.state.attackFrame >= 24) {
        player.state.attacking = false;
        player.state.attackFrame = 0;
      }
    } else {
      if (player.actions.attack) {
        player.state.attacking = true;
        player.state.attackFrame = 0;
      }
    }
  }
}
