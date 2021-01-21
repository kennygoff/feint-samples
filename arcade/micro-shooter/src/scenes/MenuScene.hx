package scenes;

import feint.audio.AudioFile;
import feint.assets.Assets;
import components.ui.UIPositionComponent;
import components.SpriteComponent;
import components.ui.SimpleMenuComponent;
import feint.forge.Entity;
import feint.forge.Forge;
import feint.graphics.Sprite;
import feint.input.device.Keyboard.KeyCode;
import feint.renderer.Renderer;
import feint.scene.Scene;

class MenuScene extends Scene {
  var forge:Forge;
  var selected:Int;
  var shipSelectSprite:Sprite;
  var menuSelectSound:AudioFile;

  override function init() {
    super.init();

    shipSelectSprite = new Sprite(Assets.shooter_sheet__png);
    shipSelectSprite.textureWidth = 320;
    shipSelectSprite.textureHeight = 16;
    shipSelectSprite.setupSpriteSheetAnimation(16, 16, [
      "vertical:idle" => [0],
      "vertical:left" => [1, 2],
      "vertical:right" => [3, 4],
      "vertical:coast" => [0, 1, 2, 1, 0, 3, 4, 3],
      "horizontal:idle" => [5],
      "horizontal:up" => [6, 7],
      "horizontal:down" => [8, 9],
      "horizontal:coast" => [5, 6, 7, 6, 5, 8, 9, 8]
    ]);
    shipSelectSprite.animation.play("horizontal:coast", 10, true);

    forge = new Forge();
    forge.addEntity(Entity.create(), [
      new SpriteComponent(shipSelectSprite),
      new UIPositionComponent(
        Math.floor(game.window.width / 2) - 160,
        Math.floor(game.window.height / 2) - 3
      )
    ]);
    forge.addEntity(Entity.create(), [
      new SimpleMenuComponent('Play', 0, true, () -> {
        menuSelectSound.play();
        game.changeScene(new PlayScene());
      })
    ]);
    forge.addSystem(new SimpleMenuSystem(game.window.inputManager, game.window));
    forge.addSystem(new SpriteSystem());
    forge.addRenderSystem(new SimpleMenuRenderSystem(game.window));
    forge.addRenderSystem(new UISpriteRenderSystem(game.window));

    menuSelectSound = new AudioFile(Assets.powerUp12__ogg);
  }

  override function update(elapsed:Float) {
    super.update(elapsed);

    forge.update(elapsed);
  }

  override public function render(renderer:Renderer) {
    // Render background
    renderer.drawRect(0, 0, game.window.width, game.window.height, {color: 0xFF000000});

    super.render(renderer);

    renderer.drawText(
      Math.floor(game.window.width / 2),
      104,
      'feint micro arcade',
      24,
      '"kenney_mini", sans-serif',
      Center
    );

    renderer.drawText(
      Math.floor(game.window.width / 2),
      128,
      'SHOOTER',
      64,
      '"kenney_mini", sans-serif',
      Center
    );

    renderer.drawText(
      Math.floor(game.window.width / 2),
      game.window.height - 128,
      'CONTROLS',
      16,
      '"kenney_mini", sans-serif',
      Center
    );

    renderer.drawText(
      Math.floor(game.window.width / 2),
      game.window.height - 112,
      'ARROWS to MOVE',
      24,
      '"kenney_mini", sans-serif',
      Center
    );

    renderer.drawText(
      Math.floor(game.window.width / 2),
      game.window.height - 88,
      'X to SHOOT',
      24,
      '"kenney_mini", sans-serif',
      Center
    );

    renderer.drawText(
      Math.floor(game.window.width / 2),
      game.window.height - 64,
      '[LEFT/RIGHT]+Z to SHIELD BASH',
      24,
      '"kenney_mini", sans-serif',
      Center
    );

    forge.render(renderer);

    // Render FPS
    renderer.drawText(4, 4, 'FPS: ${game.fps}', 16, '"kenney_mini", sans-serif');
  }
}
