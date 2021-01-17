package systems.ships;

import components.HitboxComponent;
import feint.graphics.Sprite;
import components.SpriteComponent;
import feint.forge.Entity;
import components.ShipGunComponent;
import components.SoulComponent;
import components.VelocityComponent;
import components.PositionComponent;
import feint.forge.Forge;
import feint.forge.System;

class BeastShipSystem extends System {
  public function new() {}

  override function update(elapsed:Float, forge:Forge) {
    var shipEntities = forge.getEntities([PositionComponent], ['enemy', 'ship', 'beast']);
    var ships = shipEntities.map(entityId -> {
      position: forge.getEntityComponent(entityId, PositionComponent),
      velocity: forge.getEntityComponent(entityId, VelocityComponent),
      soul: forge.getEntityComponent(entityId, SoulComponent),
      gun: forge.getEntityComponent(entityId, ShipGunComponent)
    }).filter(ship -> ship.soul.alive);

    for (ship in ships) {
      // Movement
      if (ship.position.y < 24) {
        ship.velocity.y = 40;
      } else {
        ship.velocity.y = 35;
      }

      // Shooting
      if (ship.gun.ready && ship.position.y >= 24) {
        var bulletWidth = 10 * 4;
        var bulletSpriteWidth = 16 * 4;
        forge.addEntity(Entity.create(), [
          new SpriteComponent(createBulletSprite()),
          new PositionComponent(ship.position.x, // + ((bulletSpriteWidth - bulletWidth) / 2),
            ship.position.y),
          new VelocityComponent(0, 150),
          new HitboxComponent(3 * 4, 3 * 4, 10 * 4, 10 * 4)
        ], ["bullet", "enemy"]);

        ship.gun.cooldown = ship.gun.fireRate;
        ship.gun.ready = false;
      }
    }
  }

  function createBulletSprite() {
    var bulletSprite = new Sprite('bullets_sheet__png');
    bulletSprite.textureWidth = 320;
    bulletSprite.textureHeight = 16;
    bulletSprite.setupSpriteSheetAnimation(16, 16, ["shoot" => [6], "hit" => [7, 8]]);
    bulletSprite.animation.play("shoot", 10);
    return bulletSprite;
  }
}
