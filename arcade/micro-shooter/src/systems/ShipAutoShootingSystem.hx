package systems;

import components.HitboxComponent;
import components.ShipGunComponent;
import feint.forge.Entity;
import components.VelocityComponent;
import feint.input.device.Keyboard.KeyCode;
import components.PositionComponent;
import components.SpriteComponent;
import feint.input.InputManager;
import feint.forge.Forge;
import feint.forge.System;

class ShipAutoShootingSystem extends System {
  public function new() {}

  override function update(elapsed:Float, forge:Forge) {
    var shipEntities = forge.getEntities(
      [SpriteComponent, PositionComponent, ShipGunComponent],
      ['enemy', 'ship']
    );
    var ships = shipEntities.map(shipEntity -> {
      sprite: forge.getEntityComponent(shipEntity, SpriteComponent),
      position: forge.getEntityComponent(shipEntity, PositionComponent),
      gun: forge.getEntityComponent(shipEntity, ShipGunComponent)
    });

    for (ship in ships) {
      if (ship.gun.ready) {
        forge.addEntity(Entity.create(), [
          new PositionComponent(ship.position.x + 20, ship.position.y - 16),
          new VelocityComponent(0, 200),
          new HitboxComponent(0, 0, 8, 8)
        ], ["bullet", "enemy"]);

        ship.gun.cooldown = ship.gun.fireRate;
        ship.gun.ready = false;
      }
    }
  }
}
