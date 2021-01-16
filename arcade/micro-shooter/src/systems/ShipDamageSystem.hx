package systems;

import components.ShipHealthComponent;
import components.ShipShieldBashComponent;
import components.VelocityComponent;
import components.SpriteComponent;
import components.SoulComponent;
import utils.Physics;
import components.HitboxComponent;
import components.PositionComponent;
import feint.forge.Forge;
import feint.forge.System;

class ShipDamageSystem extends System {
  public function new() {}

  override function update(elapsed:Float, forge:Forge) {
    var friendlyShipEntities = forge.getEntities([PositionComponent], ['player', 'ship']);
    var friendlyShips = friendlyShipEntities.map(entityId -> {
      id: entityId,
      position: forge.getEntityComponent(entityId, PositionComponent),
      hitbox: forge.getEntityComponent(entityId, HitboxComponent),
      bash: forge.getEntityComponent(entityId, ShipShieldBashComponent),
      velocity: forge.getEntityComponent(entityId, VelocityComponent),
      health: forge.getEntityComponent(entityId, ShipHealthComponent),
      sprite: forge.getEntityComponent(entityId, SpriteComponent)
    });
    var friendlyBulletEntities = forge.getEntities([PositionComponent], ['player', 'bullet']);
    var friendlyBullets = friendlyBulletEntities.map(entityId -> {
      id: entityId,
      position: forge.getEntityComponent(entityId, PositionComponent),
      hitbox: forge.getEntityComponent(entityId, HitboxComponent)
    });
    var enemyShipEntities = forge.getEntities([PositionComponent], ['enemy', 'ship']);
    var enemyShips = enemyShipEntities.map(entityId -> {
      id: entityId,
      position: forge.getEntityComponent(entityId, PositionComponent),
      hitbox: forge.getEntityComponent(entityId, HitboxComponent),
      soul: forge.getEntityComponent(entityId, SoulComponent),
      sprite: forge.getEntityComponent(entityId, SpriteComponent),
      health: forge.getEntityComponent(entityId, ShipHealthComponent),
      velocity: forge.getEntityComponent(entityId, VelocityComponent)
    }).filter(ship -> ship.soul.alive);
    var enemyBulletEntities = forge.getEntities([PositionComponent], ['enemy', 'bullet']);
    var enemyBullets = enemyBulletEntities.map(entityId -> {
      id: entityId,
      position: forge.getEntityComponent(entityId, PositionComponent),
      hitbox: forge.getEntityComponent(entityId, HitboxComponent)
    });
    var asteroidEntities = forge.getEntities([PositionComponent], ['asteroid']);
    var asteroids = asteroidEntities.map(entityId -> {
      id: entityId,
      position: forge.getEntityComponent(entityId, PositionComponent),
      hitbox: forge.getEntityComponent(entityId, HitboxComponent),
      soul: forge.getEntityComponent(entityId, SoulComponent),
      sprite: forge.getEntityComponent(entityId, SpriteComponent),
      velocity: forge.getEntityComponent(entityId, VelocityComponent)
    }).filter(asteroid -> asteroid.soul.alive);

    for (friendlyShip in friendlyShips) {
      if (friendlyShip.bash.isBashing) {
        for (enemyShip in enemyShips) {
          if (Physics.overlaps(friendlyShip, enemyShip)) {
            enemyShip.soul.alive = false;
            if (friendlyShip.velocity.x < 0) {
              enemyShip.sprite.sprite.animation.play("death:bashed:left", 4);
            } else {
              enemyShip.sprite.sprite.animation.play("death:bashed:right", 4);
            }
            enemyShip.hitbox.x = 0;
            enemyShip.hitbox.y = 0;
            enemyShip.hitbox.width = 0;
            enemyShip.hitbox.height = 0;
            enemyShip.velocity.x = 0;
            enemyShip.velocity.y = 0;

            // Health regen
            friendlyShip.health.health = feint.utils.Math.clamp(
              friendlyShip.health.health + 10,
              0,
              100
            );
          }
        }
      }
    }

    for (friendlyBullet in friendlyBullets) {
      for (enemyShip in enemyShips) {
        if (Physics.overlaps(friendlyBullet, enemyShip)) {
          forge.removeEntity(friendlyBullet.id);
          enemyShip.soul.alive = false;
          enemyShip.sprite.sprite.animation.play("death", 4);
          enemyShip.hitbox.x = 0;
          enemyShip.hitbox.y = 0;
          enemyShip.hitbox.width = 0;
          enemyShip.hitbox.height = 0;
          enemyShip.velocity.x = 0;
          enemyShip.velocity.y = 0;
          break;
        }
      }
    }

    for (enemyBullet in enemyBullets) {
      for (friendlyShip in friendlyShips) {
        if (!friendlyShip.bash.isBashing && Physics.overlaps(enemyBullet, friendlyShip)) {
          forge.removeEntity(enemyBullet.id);
          friendlyShip.health.health -= 10;
          friendlyShip.health.hurtFrames = 24;
          break;
        }
      }
    }

    for (asteroid in asteroids) {
      for (friendlyShip in friendlyShips) {
        if (Physics.overlaps(asteroid, friendlyShip)) {
          if (!friendlyShip.bash.isBashing) {
            asteroid.soul.alive = false;
            asteroid.sprite.sprite.animation.play("death", 4);
            asteroid.hitbox.x = 0;
            asteroid.hitbox.y = 0;
            asteroid.hitbox.width = 0;
            asteroid.hitbox.height = 0;
            asteroid.velocity.x = 0;
            asteroid.velocity.y = 0;
            friendlyShip.health.health -= 10;
            friendlyShip.health.hurtFrames = 24;
            break;
          } else {
            asteroid.soul.alive = false;
            asteroid.sprite.sprite.animation.play("death", 4);
            asteroid.hitbox.x = 0;
            asteroid.hitbox.y = 0;
            asteroid.hitbox.width = 0;
            asteroid.hitbox.height = 0;
            asteroid.velocity.x = 0;
            asteroid.velocity.y = 0;

            // Health regen
            friendlyShip.health.health = feint.utils.Math.clamp(
              friendlyShip.health.health + 10,
              0,
              100
            );
            break;
          }
        }
      }
    }

    for (friendlyShip in friendlyShips) {
      if (friendlyShip.health.hurtFrames > 0) {
        if (friendlyShip.health.hurtFrames % 8 < 2) {
          friendlyShip.sprite.sprite.alpha = 0;
        } else {
          friendlyShip.sprite.sprite.alpha = 1;
        }
        friendlyShip.health.hurtFrames--;
      } else {
        friendlyShip.sprite.sprite.alpha = 1;
      }
    }

    for (enemyShip in enemyShips) {
      if (enemyShip.health.hurtFrames > 0) {
        if (enemyShip.health.hurtFrames % 8 < 2) {
          enemyShip.sprite.sprite.alpha = 0;
        } else {
          enemyShip.sprite.sprite.alpha = 1;
        }
        enemyShip.health.hurtFrames--;
      } else {
        enemyShip.sprite.sprite.alpha = 1;
      }
    }
  }
}
