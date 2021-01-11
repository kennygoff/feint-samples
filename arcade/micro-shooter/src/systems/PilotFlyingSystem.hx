package systems;

import feint.input.device.Keyboard.KeyCode;
import components.PositionComponent;
import components.SpriteComponent;
import feint.input.InputManager;
import feint.forge.Forge;
import feint.forge.System;

class PilotFlyingSystem extends System {
  var inputManager:InputManager;

  public function new(inputManager:InputManager) {
    this.inputManager = inputManager;
  }

  override function update(elapsed:Float, forge:Forge) {
    var shipEntity = forge.getEntities([SpriteComponent, PositionComponent]).shift();
    var shipSprite = forge.getEntityComponent(shipEntity, SpriteComponent);
    var shipPosition = forge.getEntityComponent(shipEntity, PositionComponent);

    if (inputManager.keyboard.keys[KeyCode.Left] == JustPressed) {
      shipPosition.x -= 600 * (elapsed / 1000);
      shipSprite.sprite.animation.play("vertical:left", 10);
    } else if (inputManager.keyboard.keys[KeyCode.Right] == JustPressed) {
      shipPosition.x += 600 * (elapsed / 1000);
      shipSprite.sprite.animation.play("vertical:right", 10);
    } else if (inputManager.keyboard.keys[KeyCode.Left] == Pressed) {
      shipPosition.x -= 400 * (elapsed / 1000);
    } else if (inputManager.keyboard.keys[KeyCode.Right] == Pressed) {
      shipPosition.x += 400 * (elapsed / 1000);
    } else {
      shipSprite.sprite.animation.play("vertical:idle", 100);
    }
  }
}
