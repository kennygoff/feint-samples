package scenes;

import feint.audio.AudioFile;
import feint.assets.Assets;
import components.ui.UIPositionComponent;
import components.SpriteComponent;
import components.ui.SimpleMenuComponent;
import feint.forge.Entity;
import feint.forge.Forge;
import feint.graphics.Sprite;
import feint.renderer.Renderer;
import feint.scene.Scene;

class GameOverScene extends Scene {
  var selected:Int;
  var shipSelectSprite:Sprite;
  var menuSelectSound:AudioFile;
  var score:Int;
  var kills:Int;
  var wave:Int;

  public function new(score:Int, kills:Int, wave:Int) {
    super();

    this.score = score;
    this.kills = kills;
    this.wave = wave;
  }

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

    forge.addEntity(Entity.create(), [
      new SpriteComponent(shipSelectSprite),
      new UIPositionComponent(
        Math.floor(game.window.width / 2) - 160,
        Math.floor(game.window.height / 2) - 3
      )
    ]);
    forge.addEntity(Entity.create(), [
      new SimpleMenuComponent('Retry', 0, true, () -> {
        menuSelectSound.play();
        game.changeScene(new PlayScene());
      })
    ]);
    forge.addEntity(Entity.create(), [
      new SimpleMenuComponent('Exit', 1, false, () -> {
        game.changeScene(new MenuScene());
      })
    ]);
    forge.addSystem(new SimpleMenuSystem(game.window.inputManager, game.window));
    forge.addSystem(new SpriteSystem());
    forge.addRenderSystem(new SimpleMenuRenderSystem(game.window));
    forge.addRenderSystem(new UISpriteRenderSystem(game.window));

    menuSelectSound = new AudioFile(Assets.powerUp12__ogg);
  }

  override public function render(renderer:Renderer) {
    // Render background
    renderer.drawRect(0, 0, game.window.width, game.window.height, 0, 0xFF000000);

    renderer.drawText(
      Math.floor(game.window.width / 2),
      128,
      'GAME OVER',
      64,
      '"kenney_mini", sans-serif',
      Center
    );

    renderer.drawText(
      Math.floor(game.window.width / 2),
      128 + 64,
      'Score: ${score}',
      32,
      '"kenney_mini", sans-serif',
      Center
    );
    renderer.drawText(
      Math.floor(game.window.width / 2),
      128 + 96,
      'Kills: ${kills}',
      32,
      '"kenney_mini", sans-serif',
      Center
    );
    renderer.drawText(
      Math.floor(game.window.width / 2),
      128 + 128,
      'Final wave: ${wave}',
      32,
      '"kenney_mini", sans-serif',
      Center
    );

    forge.render(renderer);

    // Render FPS
    renderer.drawText(4, 4, 'FPS: ${game.fps}', 16, '"kenney_mini", sans-serif');
  }
}
