package scenes;

import player.PlayerStateComponent;
import player.PlayerCombatSystem;
import feint.library.SpriteAnimationSystem;
import player.PlayerAnimateSystem;
import feint.library.MomentumSystem;
import feint.library.VelocityComponent;
import feint.library.SpriteRenderSystem;
import feint.assets.Assets;
import feint.graphics.Sprite;
import feint.library.SpriteComponent;
import feint.library.BitmapTextRenderSystem;
import feint.library.BitmapTextComponent;
import feint.library.PositionComponent;
import feint.forge.Entity;
import feint.scene.Scene;
import player.PlayerMovementSystem;
import player.PlayerActionsSystem;
import player.PlayerActionsComponent;

class PlayScene extends Scene {
  override function init() {
    super.init();

    camera.scale = 4;

    var playerSprite = new Sprite(Assets.adventure_player__png);
    playerSprite.textureWidth = 384;
    playerSprite.textureHeight = 16;
    playerSprite.setupSpriteSheetAnimation(16, 16, [
      "idle" => [0],
      "move:right" => [0, 1, 2, 3],
      "move:left" => [4, 5, 6, 7],
      "attack:right" => [8, 9, 10, 11],
      "attack:left" => [12, 13, 14, 15],
      "attack:down" => [16, 17, 18, 19],
      "attack:up" => [20, 21, 22, 23]
    ]);
    playerSprite.animation.play('idle', 1, true);

    forge.addEntity(Entity.create(), [
      new PositionComponent(0, 0),
      new VelocityComponent(0, 0),
      new SpriteComponent(playerSprite),
      new PlayerActionsComponent(),
      new PlayerStateComponent(),
    ], ['player']);
    forge.addSystems([
      new PlayerActionsSystem(game.window.inputManager),
      new PlayerMovementSystem(),
      new PlayerCombatSystem(),
      new PlayerAnimateSystem(),
      new SpriteAnimationSystem(),
      new MomentumSystem()
    ]);
    forge.addRenderSystems([new SpriteRenderSystem()]);
  }
}
