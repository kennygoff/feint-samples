package systems;

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
      hitbox: forge.getEntityComponent(entityId, HitboxComponent)
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
      hitbox: forge.getEntityComponent(entityId, HitboxComponent)
    });
    var enemyBulletEntities = forge.getEntities([PositionComponent], ['enemy', 'bullet']);
    var enemyBullets = enemyBulletEntities.map(entityId -> {
      id: entityId,
      position: forge.getEntityComponent(entityId, PositionComponent),
      hitbox: forge.getEntityComponent(entityId, HitboxComponent)
    });

    for (friendlyBullet in friendlyBullets) {
      for (enemyShip in enemyShips) {
        if (Physics.overlaps(friendlyBullet, enemyShip)) {
          forge.removeEntity(friendlyBullet.id);
          forge.removeEntity(enemyShip.id);
          break;
        }
      }
    }

    for (enemyBullet in enemyBullets) {
      for (friendlyShip in friendlyShips) {
        if (Physics.overlaps(enemyBullet, friendlyShip)) {
          forge.removeEntity(enemyBullet.id);
          trace('SPACE DEATH');
          break;
        }
      }
    }
  }
}
