package player;

import player.PlayerStateComponent;
import feint.input.device.Keyboard.KeyCode;
import feint.input.InputManager;
import player.PlayerActionsComponent;
import feint.forge.Entity.EntityId;
import feint.forge.Forge;
import feint.forge.System;

private typedef Shape = {
  id:EntityId,
  actions:PlayerActionsComponent,
  state:PlayerStateComponent
}

class PlayerActionsSystem extends System {
  var inputManager:InputManager;

  public function new(inputManager:InputManager) {
    this.inputManager = inputManager;
  }

  override function update(elapsed:Float, forge:Forge) {
    var player:Shape = forge.getShapes([PlayerActionsComponent, PlayerStateComponent]).pop();
    var actions = player.actions;

    actions.left = (
      inputManager.keyboard.keys[KeyCode.Left] == Pressed ||
      inputManager.keyboard.keys[KeyCode.Left] == JustPressed
    );
    actions.right = (
      inputManager.keyboard.keys[KeyCode.Right] == Pressed ||
      inputManager.keyboard.keys[KeyCode.Right] == JustPressed
    );
    actions.up = (
      inputManager.keyboard.keys[KeyCode.Up] == Pressed ||
      inputManager.keyboard.keys[KeyCode.Up] == JustPressed
    );
    actions.down = (
      inputManager.keyboard.keys[KeyCode.Down] == Pressed ||
      inputManager.keyboard.keys[KeyCode.Down] == JustPressed
    );
    actions.attack = (
      inputManager.keyboard.keys[KeyCode.C] == Pressed ||
      inputManager.keyboard.keys[KeyCode.C] == JustPressed
    );
    actions.shield = (
      inputManager.keyboard.keys[KeyCode.X] == Pressed ||
      inputManager.keyboard.keys[KeyCode.X] == JustPressed
    );

    if (actions.left) {
      player.state.facing = Left;
    } else if (actions.right) {
      player.state.facing = Right;
    } else if (actions.up) {
      player.state.facing = Up;
    } else if (actions.down) {
      player.state.facing = Down;
    }
  }
}
