package systems;

import components.ShipGunComponent;
import feint.forge.Entity;
import components.VelocityComponent;
import feint.input.device.Keyboard.KeyCode;
import components.PositionComponent;
import components.SpriteComponent;
import feint.input.InputManager;
import feint.forge.Forge;
import feint.forge.System;

class PilotShootingSystem extends System {
  var inputManager:InputManager;

  public function new(inputManager:InputManager) {
    this.inputManager = inputManager;
  }

  override function update(elapsed:Float, forge:Forge) {
    var shipEntity = forge.getEntities([SpriteComponent, PositionComponent, ShipGunComponent])
      .shift();
    var ship = {
      sprite: forge.getEntityComponent(shipEntity, SpriteComponent),
      position: forge.getEntityComponent(shipEntity, PositionComponent),
      gun: forge.getEntityComponent(shipEntity, ShipGunComponent)
    };

    if (
      ship.gun.ready &&
      (
        inputManager.keyboard.keys[KeyCode.X] == JustPressed ||
        inputManager.keyboard.keys[KeyCode.X] == Pressed
      )
    ) {
      forge.addEntity(Entity.create(), [
        new PositionComponent(ship.position.x + 20, ship.position.y - 16),
        new VelocityComponent(0, -1000)
      ], ["bullet"]);

      ship.gun.cooldown = ship.gun.fireRate;
      ship.gun.ready = false;
    }
  }
}
