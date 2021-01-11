package systems;

import components.ShipGunComponent;
import feint.forge.Forge;
import feint.forge.System;

class ShipGunSystem extends System {
  public function new() {}

  override function update(elapsed:Float, forge:Forge) {
    var gunEntities = forge.getEntities([ShipGunComponent]);
    var guns = gunEntities.map(entityId -> forge.getEntityComponent(entityId, ShipGunComponent));

    for (gun in guns) {
      if (!gun.ready) {
        gun.cooldown -= elapsed;
        if (gun.cooldown < 0) {
          gun.cooldown = 0;
          gun.ready = true;
        }
      }
    }
  }
}
