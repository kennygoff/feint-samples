package systems;

import feint.audio.AudioFile;
import feint.assets.Assets;
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
  var pickupHealSound:AudioFile;
  var pickupShieldSound:AudioFile;

  public function new() {
    this.pickupHealSound = new AudioFile(Assets.powerUp2__ogg);
    this.pickupShieldSound = new AudioFile(Assets.powerUp7__ogg);
  }

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
      if (Physics.overlaps(shieldDrop, cast ship)) {
        ship.shields.shields = feint.utils.Math.clamp(
          ship.shields.shields + shieldDrop.shieldDrop.shields,
          0,
          100
        );
        forge.removeEntity(shieldDrop.id);
        pickupShieldSound.play();
      }
    }

    for (healDrop in healDrops) {
      if (healDrop.position.y > 640) {
        forge.removeEntity(healDrop.id);
        break;
      }
      if (Physics.overlaps(healDrop, cast ship)) {
        ship.health.health = feint.utils.Math.clamp(
          ship.health.health + healDrop.healDrop.heal,
          0,
          100
        );
        forge.removeEntity(healDrop.id);
        pickupHealSound.play();
      }
    }
  }
}
