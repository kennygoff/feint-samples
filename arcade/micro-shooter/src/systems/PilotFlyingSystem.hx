package systems;

import components.ShipShieldBashComponent;
import components.ShipShieldComponent;
import components.AccelerationComponent;
import components.VelocityComponent;
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
    var shipEntity = forge.getEntities(
      [SpriteComponent, PositionComponent, VelocityComponent, AccelerationComponent]
    )
      .shift();
    var ship = {
      sprite: forge.getEntityComponent(shipEntity, SpriteComponent),
      position: forge.getEntityComponent(shipEntity, PositionComponent),
      velocity: forge.getEntityComponent(shipEntity, VelocityComponent),
      acceleration: forge.getEntityComponent(shipEntity, AccelerationComponent),
      shields: forge.getEntityComponent(shipEntity, ShipShieldComponent),
      shieldBash: forge.getEntityComponent(shipEntity, ShipShieldBashComponent)
    };

    if (!ship.shieldBash.isBashing) {
      if (inputManager.keyboard.keys[KeyCode.Left] == JustPressed) {
        ship.acceleration.x = -100;
        if (ship.velocity.x > 0) {
          ship.velocity.x *= 0.25;
        }
      } else if (inputManager.keyboard.keys[KeyCode.Right] == JustPressed) {
        ship.acceleration.x = 100;
        if (ship.velocity.x < 0) {
          ship.velocity.x *= 0.25;
        }
      } else if (inputManager.keyboard.keys[KeyCode.Left] == Pressed) {
        ship.acceleration.x = -15;
      } else if (inputManager.keyboard.keys[KeyCode.Right] == Pressed) {
        ship.acceleration.x = 15;
      } else {
        ship.acceleration.x = -(ship.velocity.x * 0.2);
        if (Math.abs(ship.velocity.x) < 2) {
          ship.acceleration.x = 0;
          ship.velocity.x = 0;
        }
      }
    }

    ship.velocity.x += ship.acceleration.x;
    ship.velocity.y += ship.acceleration.y;

    if (!ship.shieldBash.isBashing) {
      ship.velocity.x = feint.utils.Math.clamp(ship.velocity.x, -450, 450);
    }

    // ship.position.x += ship.velocity.x * (elapsed / 1000);
    // ship.position.y += ship.velocity.y * (elapsed / 1000);

    ship.position.x = feint.utils.Math.clamp(ship.position.x, 0, 640 - (16 * 4));

    // Animate
    if (!ship.shieldBash.isBashing) {
      if (
        ship.velocity.x < 0 &&
        ship.sprite.sprite.animation.currentAnimation != "vertical:left"
      ) {
        ship.sprite.sprite.animation.play("vertical:left", 10);
      } else if (
        ship.velocity.x > 0 &&
        ship.sprite.sprite.animation.currentAnimation != "vertical:right"
      ) {
        ship.sprite.sprite.animation.play("vertical:right", 10);
      } else if (ship.velocity.x == 0 && ship.acceleration.x == 0) {
        ship.sprite.sprite.animation.play("vertical:idle", 100);
      }
    }
  }
}
