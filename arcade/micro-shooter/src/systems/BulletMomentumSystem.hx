package systems;

import components.VelocityComponent;
import components.PositionComponent;
import feint.forge.Forge;
import feint.forge.System;

class BulletMomentumSystem extends System {
  public function new() {}

  override function update(elapsed:Float, forge:Forge) {
    var bulletEntities = forge.getEntities([VelocityComponent, PositionComponent], ['bullet']);
    var bullets = bulletEntities.map(entityId -> {
      position: forge.getEntityComponent(entityId, PositionComponent),
      velocity: forge.getEntityComponent(entityId, VelocityComponent)
    });

    for (bullet in bullets) {
      bullet.position.y += bullet.velocity.y * (elapsed / 1000);
    }
  }
}
