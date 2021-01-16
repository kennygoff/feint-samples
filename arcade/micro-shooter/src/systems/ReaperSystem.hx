package systems;

import components.SpriteComponent;
import components.SoulComponent;
import feint.forge.Forge;
import feint.forge.System;

class ReaperSystem extends System {
  public function new() {}

  override function update(elapsed:Float, forge:Forge) {
    var soulEntities = forge.getEntities([SoulComponent]);
    var souls = soulEntities.map(entityId -> {
      id: entityId,
      soul: forge.getEntityComponent(entityId, SoulComponent),
      // Sprite is sometimes null here
      sprite: forge.getEntityComponent(entityId, SpriteComponent)
    }).filter(soul -> soul.soul.alive == false);

    for (soul in souls) {
      if (soul.sprite != null) {
        if (soul.sprite.sprite.animation.finished) {
          forge.removeEntity(soul.id);
        }
      } else {
        forge.removeEntity(soul.id);
      }
    }
  }
}
