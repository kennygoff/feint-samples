package scenes;

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

    var playerSprite = new Sprite(Assets.adventure_tiles__png);
    playerSprite.textureHeight = 160;
    playerSprite.textureWidth = 160;
    playerSprite.setupSpriteSheetAnimation(16, 16, ["idle" => [0]]);
    playerSprite.animation.play('idle', 1, true);

    forge.addEntity(Entity.create(), [
      new PositionComponent(0, 0),
      new VelocityComponent(0, 0),
      new SpriteComponent(playerSprite),
      new PlayerActionsComponent()
    ]);
    forge.addSystems([
      new PlayerActionsSystem(game.window.inputManager),
      new PlayerMovementSystem(),
      new MomentumSystem()
    ]);
    forge.addRenderSystems([new SpriteRenderSystem()]);
  }
}
