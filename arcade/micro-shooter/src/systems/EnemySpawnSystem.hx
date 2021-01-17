package systems;

import feint.assets.Assets;
import components.HitboxComponent;
import components.ShipGunComponent;
import components.SpriteComponent;
import feint.graphics.Sprite;
import components.VelocityComponent;
import feint.forge.Entity;
import components.PositionComponent;
import feint.forge.Forge;
import feint.forge.System;

/**
 * @deprecated
 */
class EnemySpawnSystem extends System {
  public function new() {}

  override function update(elapsed:Float, forge:Forge) {
    var shipEntities = forge.getEntities([PositionComponent], ['enemy', 'ship']);
    var ships = shipEntities.map(entityId -> {
      id: entityId,
      position: forge.getEntityComponent(entityId, PositionComponent)
    });

    for (ship in ships) {
      if (ship.position.y > 640) {
        forge.removeEntity(ship.id);
      }
    }

    if (shipEntities.length < 4) {
      var shipType = ["gambit", "storm", "beast"][Math.floor(Math.random() * 3)];
      var shipSprite = new Sprite(Assets.enemies_sheet__png);
      shipSprite.textureWidth = 192;
      shipSprite.textureHeight = 16;
      shipSprite.setupSpriteSheetAnimation(
        16,
        16,
        ["gambit" => [0, 1, 2, 3], "storm" => [4, 5, 6, 7], "beast" => [8, 9, 10, 11]]
      );
      shipSprite.animation.play(shipType, 10, true);

      forge.addEntity(Entity.create(), [
        new PositionComponent(Math.random() * 640, 0),
        new VelocityComponent(0, 30 + Math.random() * 20),
        new SpriteComponent(shipSprite),
        new ShipGunComponent(120 / 60 * 1000),
        new HitboxComponent(1 * 4, 1 * 4, 14 * 4, 14 * 4)
      ], ['enemy', 'ship']);
    }
  }
}
