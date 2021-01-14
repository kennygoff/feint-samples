package systems;

import components.HitboxComponent;
import components.PositionComponent;
import feint.renderer.Renderer;
import feint.forge.Forge;
import feint.forge.System.RenderSystem;

class BulletRenderSystem extends RenderSystem {
  public function new() {}

  override function render(renderer:Renderer, forge:Forge) {
    var bulletEntities = forge.getEntities([PositionComponent, HitboxComponent], ['bullet']);
    var bullets = bulletEntities.map(entityId -> {
      position: forge.getEntityComponent(entityId, PositionComponent),
      hitbox: forge.getEntityComponent(entityId, HitboxComponent),
    });

    for (bullet in bullets) {
      renderer.drawRect(
        Math.floor(bullet.position.x),
        Math.floor(bullet.position.y),
        Math.floor(bullet.hitbox.width),
        Math.floor(bullet.hitbox.height),
        {
          color: 0xFFFFFFFF
        }
      );
    }
  }
}
