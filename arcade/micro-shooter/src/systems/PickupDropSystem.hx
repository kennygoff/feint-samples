package systems;

import utils.Physics;
import components.ShipShieldComponent;
import components.ShipHealthComponent;
import components.HitboxComponent;
import components.PositionComponent;
import components.DropShieldsComponent;
import components.DropHealComponent;
import feint.forge.Forge;
import feint.forge.System;

class PickupDropSystem extends System {
  public function new() {}

  override function update(elapsed:Float, forge:Forge) {
    var healDropEntities = forge.getEntities([DropHealComponent]);
    var healDrops = healDropEntities.map(entityId -> {
      id: entityId,
      position: forge.getEntityComponent(entityId, PositionComponent),
      hitbox: forge.getEntityComponent(entityId, HitboxComponent),
      healDrop: forge.getEntityComponent(entityId, DropHealComponent)
    });
    var shieldDropEntities = forge.getEntities([DropShieldsComponent]);
    var shieldDrops = shieldDropEntities.map(entityId -> {
      id: entityId,
      position: forge.getEntityComponent(entityId, PositionComponent),
      hitbox: forge.getEntityComponent(entityId, HitboxComponent),
      shieldDrop: forge.getEntityComponent(entityId, DropShieldsComponent)
    });

    var shipEntity = forge.getEntities([ShipHealthComponent, ShipShieldComponent], ['player'])
      .shift();
    var ship = {
      id: shipEntity,
      health: forge.getEntityComponent(shipEntity, ShipHealthComponent),
      shields: forge.getEntityComponent(shipEntity, ShipShieldComponent),
      position: forge.getEntityComponent(shipEntity, PositionComponent),
      hitbox: forge.getEntityComponent(shipEntity, HitboxComponent)
    };

    for (shieldDrop in shieldDrops) {
      if (shieldDrop.position.y > 640) {
        forge.removeEntity(shieldDrop.id);
        break;
      }
      trace(shieldDrop);
      if (Physics.overlaps(shieldDrop, cast ship)) {
        trace(shieldDrop);
        ship.shields.shields = feint.utils.Math.clamp(
          ship.shields.shields + shieldDrop.shieldDrop.shields,
          0,
          100
        );
        forge.removeEntity(shieldDrop.id);
      }
    }

    for (healDrop in healDrops) {
      if (healDrop.position.y > 640) {
        forge.removeEntity(healDrop.id);
        break;
      }
      trace(healDrop);
      if (Physics.overlaps(healDrop, cast ship)) {
        trace(healDrop);
        ship.health.health = feint.utils.Math.clamp(
          ship.health.health + healDrop.healDrop.heal,
          0,
          100
        );
        forge.removeEntity(healDrop.id);
      }
    }
  }
}
