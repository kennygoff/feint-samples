package systems;

import components.VelocityComponent;
import components.PositionComponent;
import feint.forge.Forge;
import feint.forge.System;

class MomentumSystem extends System {
  public function new() {}

  override function update(elapsed:Float, forge:Forge) {
    var movingObjectEntities = forge.getEntities([VelocityComponent, PositionComponent]);
    var movingObjects = movingObjectEntities.map(entityId -> {
      position: forge.getEntityComponent(entityId, PositionComponent),
      velocity: forge.getEntityComponent(entityId, VelocityComponent)
    });

    for (object in movingObjects) {
      object.position.y += object.velocity.y * (elapsed / 1000);
    }
  }
}
