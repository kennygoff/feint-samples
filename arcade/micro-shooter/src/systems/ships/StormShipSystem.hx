package systems.ships;

import feint.audio.AudioFile;
import feint.assets.Assets;
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

class StormShipSystem extends System {
  var shootSound:AudioFile;

  public function new() {
    this.shootSound = new AudioFile(Assets.laserRetro_002__ogg);
  }

  override function update(elapsed:Float, forge:Forge) {
    var shipEntities = forge.getEntities([PositionComponent], ['enemy', 'ship', 'storm']);
    var ships = shipEntities.map(entityId -> {
      position: forge.getEntityComponent(entityId, PositionComponent),
      velocity: forge.getEntityComponent(entityId, VelocityComponent),
      soul: forge.getEntityComponent(entityId, SoulComponent),
      gun: forge.getEntityComponent(entityId, ShipGunComponent)
    }).filter(ship -> ship.soul.alive);

    for (ship in ships) {
      // Movement
      if (ship.position.y < 24) {
        ship.velocity.x = 0;
        ship.velocity.y = 40;
      } else {
        if (ship.position.x <= 10) {
          ship.velocity.x = 200;
        } else if (ship.position.x >= 640 - 10 - (16 * 4)) {
          ship.velocity.x = -200;
        } else if (ship.velocity.x == 0) {
          ship.velocity.x = ship.position.x < 320 - (8 * 4) ? 200 : -200;
        }
        ship.velocity.y = 35;
      }

      // Shooting
      if (ship.gun.ready && ship.position.y >= 24) {
        var bulletWidth = 2 * 4;
        var bulletSpriteWidth = 16 * 4;
        forge.addEntity(Entity.create(), [
          new SpriteComponent(createBulletSprite()),
          new PositionComponent(ship.position.x, // + ((bulletSpriteWidth - bulletWidth) / 2),
            ship.position.y),
          new VelocityComponent(0, 600),
          new HitboxComponent(7 * 4, 3 * 4, 2 * 4, 10 * 4)
        ], ["bullet", "enemy"]);

        ship.gun.cooldown = ship.gun.fireRate;
        ship.gun.ready = false;

        shootSound.play();
      }
    }
  }

  function createBulletSprite() {
    var bulletSprite = new Sprite(Assets.bullets_sheet__png);
    bulletSprite.textureWidth = 320;
    bulletSprite.textureHeight = 16;
    bulletSprite.setupSpriteSheetAnimation(16, 16, ["shoot" => [9], "hit" => [10, 11]]);
    bulletSprite.animation.play("shoot", 10);
    return bulletSprite;
  }
}
