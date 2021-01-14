package systems;

import components.SpriteComponent;
import components.ui.UIPositionComponent;
import components.ShipShieldComponent;
import components.ShipHealthComponent;
import feint.renderer.Renderer;
import feint.forge.Forge;
import feint.forge.System.RenderSystem;

class ShipHUDRenderSystem extends RenderSystem {
  public function new() {}

  override function render(renderer:Renderer, forge:Forge) {
    var healthEntity = forge.getEntities(
      [UIPositionComponent],
      ['player', 'ui', 'health']
    ).shift();
    var shieldEntity = forge.getEntities(
      [UIPositionComponent],
      ['player', 'ui', 'shield']
    ).shift();
    var shipEntity = forge.getEntities([ShipHealthComponent, ShipShieldComponent], ['player'])
      .shift();

    var ship = {
      id: shipEntity,
      health: forge.getEntityComponent(shipEntity, ShipHealthComponent),
      shields: forge.getEntityComponent(shipEntity, ShipShieldComponent),
    };
    var healthUI = {
      id: healthEntity,
      sprite: forge.getEntityComponent(healthEntity, SpriteComponent),
      position: forge.getEntityComponent(healthEntity, UIPositionComponent),
    }
    var shieldUI = {
      id: shieldEntity,
      sprite: forge.getEntityComponent(shieldEntity, SpriteComponent),
      position: forge.getEntityComponent(shieldEntity, UIPositionComponent),
    }

    healthUI.sprite.sprite.animation.play('${Math.floor(ship.health.health / 10) * 10}%', 0);
    shieldUI.sprite.sprite.animation.play('${Math.floor(ship.shields.shields / 25) * 25}%', 0);

    renderer.drawRect(
      healthUI.position.x - (1 * 2),
      healthUI.position.y - (1 * 2),
      64 * 2 + (2 * 2),
      16 * 2 + (2 * 2),
      {
        color: 0xFF000000
      }
    );
    renderer.drawRect(
      shieldUI.position.x - (1 * 2),
      shieldUI.position.y - (1 * 2),
      64 * 2 + (2 * 2),
      16 * 2 + (2 * 2),
      {
        color: 0xFF000000
      }
    );
    healthUI.sprite.sprite.drawAt(healthUI.position.x, healthUI.position.y, renderer, 2);
    shieldUI.sprite.sprite.drawAt(shieldUI.position.x, shieldUI.position.y, renderer, 2);
  }
}
