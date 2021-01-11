package systems;

import components.VelocityComponent;
import components.PositionComponent;
import feint.forge.Forge;
import feint.forge.System;

class BulletRecycleSystem extends System {
  public function new() {}

  override function update(elapsed:Float, forge:Forge) {
    var bulletEntities = forge.getEntities([PositionComponent], ['bullet']);
    var bullets = bulletEntities.map(entityId -> {
      id: entityId,
      position: forge.getEntityComponent(entityId, PositionComponent),
    });

    var recyclableBullets = bullets.filter(bullet -> bullet.position.y < -640);
    for (bullet in recyclableBullets) {
      forge.removeEntity(bullet.id);
    }
  }
}
