package scenes;

import systems.BulletRecycleSystem;
import systems.ShipGunSystem;
import components.ShipGunComponent;
import systems.BulletRenderSystem;
import systems.BulletMomentumSystem;
import feint.forge.Entity;
import feint.graphics.Sprite;
import feint.forge.Forge;
import feint.renderer.Renderer;
import feint.scene.Scene;
import components.SpriteComponent;
import components.PositionComponent;
import systems.PilotShootingSystem;
import systems.PilotFlyingSystem;

class PlayScene extends Scene {
  var forge:Forge;
  var shipSprite:Sprite;

  override function init() {
    super.init();

    shipSprite = new Sprite('shooter_sheet__png');
    shipSprite.textureWidth = 160;
    shipSprite.textureHeight = 16;
    shipSprite.setupSpriteSheetAnimation(16, 16, [
      "vertical:idle" => [0],
      "vertical:left" => [1, 2],
      "vertical:right" => [3, 4],
      "vertical:coast" => [0, 1, 2, 1, 0, 3, 4, 3],
      "horizontal:idle" => [5],
      "horizontal:up" => [6, 7],
      "horizontal:down" => [8, 9],
      "horizontal:coast" => [5, 6, 7, 6, 5, 8, 9, 8]
    ]);
    shipSprite.animation.play("vertical:idle", 10);

    forge = new Forge();
    forge.addEntity(Entity.create(), [
      new SpriteComponent(shipSprite),
      new PositionComponent(game.window.width / 2 - 8, game.window.height - 80),
      new ShipGunComponent(10 / 60 * 1000)
    ]);
    forge.addSystem(new SpriteSystem());
    forge.addSystem(new ShipGunSystem());
    forge.addSystem(new PilotFlyingSystem(game.window.inputManager));
    forge.addSystem(new PilotShootingSystem(game.window.inputManager));
    forge.addSystem(new BulletMomentumSystem());
    forge.addSystem(new BulletRecycleSystem());
    forge.addRenderSystem(new SpriteRenderSystem());
    forge.addRenderSystem(new BulletRenderSystem());
  }

  override function update(elapsed:Float) {
    super.update(elapsed);

    forge.update(elapsed);
  }

  override public function render(renderer:Renderer) {
    // Render background
    renderer.drawRect(0, 0, game.window.width, game.window.height, {color: 0xFF000000});

    super.render(renderer);

    forge.render(renderer);

    // Render FPS
    renderer.drawText(4, 4, 'FPS: ${game.fps}', 16, '"kenney_mini", sans-serif');
  }
}
