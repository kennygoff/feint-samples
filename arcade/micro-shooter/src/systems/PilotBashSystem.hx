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

class PilotBashSystem extends System {
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

    // TODO: Move to BashSystem
    if (ship.shieldBash.isBashing) {
      ship.shieldBash.cooldown -= elapsed;
      if (ship.shieldBash.cooldown < 0) {
        ship.shieldBash.cooldown = 0;
        ship.shieldBash.isBashing = false;
        ship.acceleration.x = 0;
        ship.velocity.x *= 0.25;
      }
    }

    // TODO: Move to BashSystem
    final canShieldBash = ship.shields.shields >= 25 && !ship.shieldBash.isBashing;
    if (canShieldBash && inputManager.keyboard.keys[KeyCode.Z] == JustPressed) {
      if (inputManager.keyboard.keys[KeyCode.Left] == Pressed) {
        ship.acceleration.x = 0;
        ship.velocity.x = -600;
        ship.sprite.sprite.animation.play("vertical:feint:left", 5);
      } else if (inputManager.keyboard.keys[KeyCode.Right] == Pressed) {
        ship.acceleration.x = 0;
        ship.velocity.x = 600;
        ship.sprite.sprite.animation.play("vertical:feint:right", 5);
      } else if (ship.velocity.x < 0) {
        ship.acceleration.x = 0;
        ship.velocity.x = -600;
        ship.sprite.sprite.animation.play("vertical:feint:left", 5);
      } else if (ship.velocity.x > 0) {
        ship.acceleration.x = 0;
        ship.velocity.x = 600;
        ship.sprite.sprite.animation.play("vertical:feint:right", 5);
      } else {
        ship.acceleration.x = 0;
        ship.velocity.x = 600;
        ship.sprite.sprite.animation.play("vertical:feint:right", 5);
      }
      ship.shields.shields = ship.shields.shields - 25;
      ship.shieldBash.isBashing = true;
      ship.shieldBash.cooldown = ship.shieldBash.bashRate;
    }
  }
}
