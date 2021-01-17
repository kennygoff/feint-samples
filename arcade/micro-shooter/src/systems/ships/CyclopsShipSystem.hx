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

class CyclopsShipSystem extends System {
  var shootSound:AudioFile;

  public function new() {
    this.shootSound = new AudioFile(Assets.laserRetro_004__ogg);
  }

  override function update(elapsed:Float, forge:Forge) {
    var shipEntities = forge.getEntities([PositionComponent], ['enemy', 'ship', 'cyclops']);
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
      } else if (ship.position.y < 80) {
        ship.velocity.y = 80;
      } else {
        ship.velocity.y = 0;
        if (ship.position.x <= 10) {
          ship.velocity.x = 50;
        } else if (ship.position.x >= 640 - 10 - (16 * 4)) {
          ship.velocity.x = -50;
        } else if (ship.velocity.x == 0) {
          ship.velocity.x = ship.position.x < 320 - (8 * 4) ? 50 : -50;
        }
      }

      // Shooting
      if (ship.gun.ready && ship.position.y >= 80) {
        var bulletWidth = 8 * 4;
        var bulletSpriteWidth = 16 * 4;
        forge.addEntity(Entity.create(), [
          new SpriteComponent(createBulletSprite()),
          new PositionComponent(ship.position.x, // + ((bulletSpriteWidth - bulletWidth) / 2),
            ship.position.y + 16 * 4),
          new VelocityComponent(0, 1000),
          new HitboxComponent(4 * 4, 4 * 4, 8 * 4, 16 * 4)
        ], ["bullet", "enemy"]);
        forge.addEntity(Entity.create(), [
          new SpriteComponent(createBulletSprite()),
          new PositionComponent(ship.position.x, // + ((bulletSpriteWidth - bulletWidth) / 2),
            ship.position.y + 16 * 4 + 16 * 4),
          new VelocityComponent(0, 1000),
          new HitboxComponent(4 * 4, 4 * 4, 8 * 4, 16 * 4)
        ], ["bullet", "enemy"]);
        forge.addEntity(Entity.create(), [
          new SpriteComponent(createBulletSprite()),
          new PositionComponent(ship.position.x, // + ((bulletSpriteWidth - bulletWidth) / 2),
            ship.position.y + 16 * 4 + 16 * 4 + 16 * 4),
          new VelocityComponent(0, 1000),
          new HitboxComponent(4 * 4, 4 * 4, 8 * 4, 16 * 4)
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
    bulletSprite.setupSpriteSheetAnimation(16, 16, ["shoot" => [17], "hit" => [13, 12]]);
    bulletSprite.animation.play("shoot", 10);
    return bulletSprite;
  }
}
