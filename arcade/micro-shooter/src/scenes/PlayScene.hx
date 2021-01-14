package scenes;

import components.ShipShieldBashComponent;
import systems.ShipHUDRenderSystem;
import components.ui.UIPositionComponent;
import components.ShipShieldComponent;
import components.ShipHealthComponent;
import components.AccelerationComponent;
import components.VelocityComponent;
import systems.ShipDamageSystem;
import components.HitboxComponent;
import systems.ShipAutoShootingSystem;
import systems.EnemySpawnSystem;
import systems.BulletRecycleSystem;
import systems.ShipGunSystem;
import components.ShipGunComponent;
import systems.BulletRenderSystem;
import systems.MomentumSystem;
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
    shipSprite.textureWidth = 320;
    shipSprite.textureHeight = 16;
    shipSprite.setupSpriteSheetAnimation(16, 16, [
      "vertical:idle" => [0], "vertical:left" => [1, 2], "vertical:right" => [3, 4],
      "vertical:coast" => [0, 1, 2, 1, 0, 3, 4, 3],
      "vertical:feint:left" => [10, 11, 12, 13, 14, 2],
      "vertical:feint:right" => [15, 16, 17, 18, 19, 4], "horizontal:idle" => [5],
      "horizontal:up" => [6, 7], "horizontal:down" => [8, 9],
      "horizontal:coast" => [5, 6, 7, 6, 5, 8, 9, 8]]);
    shipSprite.animation.play("vertical:idle", 10);

    var uiHealthSprite = new Sprite('ui_health_sheet__png');
    uiHealthSprite.textureWidth = 704;
    uiHealthSprite.textureHeight = 16;
    uiHealthSprite.setupSpriteSheetAnimation(64, 16, [
      "0%" => [0], "10%" => [1], "20%" => [2], "30%" => [3], "40%" => [4], "50%" => [5],
      "60%" => [6], "70%" => [7], "80%" => [8], "90%" => [9], "100%" => [10]]);
    uiHealthSprite.animation.play("0%", 0);

    var uiShieldSprite = new Sprite('ui_shield_sheet__png');
    uiShieldSprite.textureWidth = 320;
    uiShieldSprite.textureHeight = 16;
    uiShieldSprite.setupSpriteSheetAnimation(
      64,
      16,
      ["0%" => [0], "25%" => [1], "50%" => [2], "75%" => [3], "100%" => [4]]
    );
    uiShieldSprite.animation.play("0%", 0);

    forge = new Forge();
    forge.addEntity(Entity.create(), [
      new SpriteComponent(shipSprite),
      new VelocityComponent(0, 0),
      new AccelerationComponent(0, 0),
      new PositionComponent(game.window.width / 2 - 8, game.window.height - 80),
      new ShipGunComponent(20 / 60 * 1000),
      new ShipShieldBashComponent((1 / 60) * (5 * 5) * 1000),
      new HitboxComponent(3 * 4, 4 * 4, 10 * 4, 10 * 4),
      new ShipHealthComponent(100),
      new ShipShieldComponent(100),
    ], ["player"]);
    forge.addEntity(Entity.create(), [
      new SpriteComponent(uiHealthSprite),
      new UIPositionComponent(game.window.width - (64 * 2), (16 * 2) + (2 * 2))
    ], ["player", "ui", "health"]);
    forge.addEntity(Entity.create(), [
      new SpriteComponent(uiShieldSprite),
      new UIPositionComponent(game.window.width - (64 * 2), (4 * 2))
    ], ["player", "ui", "shield"]);
    forge.addSystem(new SpriteSystem());
    forge.addSystem(new ShipGunSystem());
    forge.addSystem(new PilotFlyingSystem(game.window.inputManager));
    forge.addSystem(new PilotShootingSystem(game.window.inputManager));
    // forge.addSystem(new ShipAutoShootingSystem());
    forge.addSystem(new MomentumSystem());
    forge.addSystem(new BulletRecycleSystem());
    forge.addSystem(new EnemySpawnSystem());
    forge.addSystem(new ShipDamageSystem());
    forge.addRenderSystem(new SpriteRenderSystem());
    forge.addRenderSystem(new BulletRenderSystem());
    forge.addRenderSystem(new ShipHUDRenderSystem());
    #if (debug && false)
    forge.addRenderSystem(
      new HitboxDebugRenderSystem(0xFF00FFFF, ['player' => 0xFF00FF00, 'enemy' => 0xFFFF0000])
    );
    #end
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
