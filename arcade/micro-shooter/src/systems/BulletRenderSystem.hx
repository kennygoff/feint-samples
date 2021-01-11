package systems;

import components.PositionComponent;
import feint.renderer.Renderer;
import feint.forge.Forge;
import feint.forge.System.RenderSystem;

class BulletRenderSystem extends RenderSystem {
  public function new() {}

  override function render(renderer:Renderer, forge:Forge) {
    var bulletEntities = forge.getEntities([PositionComponent], ['bullet']);
    var bullets = bulletEntities.map(entityId -> {
      position: forge.getEntityComponent(entityId, PositionComponent)
    });

    for (bullet in bullets) {
      renderer.drawRect(Math.floor(bullet.position.x), Math.floor(bullet.position.y), 8, 8, {
        color: 0xFFFFFFFF
      });
    }
  }
}
