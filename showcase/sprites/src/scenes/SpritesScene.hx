package scenes;

import feint.assets.Assets;

using Lambda;

import feint.input.device.Keyboard.KeyCode;
import feint.renderer.Renderer;
import feint.scene.Scene;
import feint.graphics.Sprite;

class SpritesScene extends Scene {
  final backgroundColor:Int = 0xFF000000;
  var sprite:Sprite;

  override public function init() {
    sprite = new Sprite(Assets.platformerPack_character__png);
    // TODO: Automate this!
    sprite.textureWidth = 384;
    sprite.textureHeight = 192;
    sprite.setupSpriteSheetAnimation(96, 96, ['idle' => [0], 'jump' => [1], 'run' => [2, 3]]);
    sprite.animation.play('run', 30, true);
  }

  override public function update(elapsed:Float) {
    super.update(elapsed);

    sprite.animation.update();
  }

  override public function render(renderer:Renderer) {
    // Render background
    renderer.drawRect(0, 0, game.window.width, game.window.height, {color: backgroundColor});

    super.render(renderer);

    renderer.drawImage(0, 0, Assets.platformChar_happy__png, {
      x: 0,
      y: 0,
      width: 96,
      height: 96
    }, 1, 96, 96);
    renderer.drawImage(150, 0, Assets.platformerPack_character__png, {
      x: 0,
      y: 0,
      width: 96,
      height: 96
    }, 1, 384, 192);
    renderer.drawImage(300, 0, Assets.platformerPack_character__png, {
      x: 192,
      y: 0,
      width: 96,
      height: 96
    }, 1.5, 384, 192);

    sprite.drawAt(200, 200, renderer);
  }
}
