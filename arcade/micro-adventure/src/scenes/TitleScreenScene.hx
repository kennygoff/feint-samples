package scenes;

import feint.Game;
import feint.input.device.Keyboard.KeyCode;
import feint.input.InputManager;
import feint.forge.Forge;
import feint.forge.System;
import feint.library.BitmapTextRenderSystem;
import feint.library.BitmapTextComponent;
import feint.library.PositionComponent;
import feint.forge.Entity;
import feint.scene.Scene;

class TitleScreenScene extends Scene {
  override function init() {
    super.init();

    forge.addEntity(
      Entity.create(),
      [new PositionComponent(0, 0), new BitmapTextComponent("micro adventure", 32)]
    );
    forge.addEntity(Entity.create(), [
      new PositionComponent(0, 320),
      new BitmapTextComponent("press ENTER to start", 32)
    ]);
    forge.addSystem(new ChangeSceneSystem(game.window.inputManager, game));
    forge.addRenderSystem(new BitmapTextRenderSystem());
  }
}

class ChangeSceneSystem extends System {
  var inputManager:InputManager;
  var game:Game;

  public function new(inputManager:InputManager, game:Game) {
    this.inputManager = inputManager;
    this.game = game;
  }

  override function update(elapsed:Float, forge:Forge) {
    if (inputManager.keyboard.keys[KeyCode.Enter] == JustPressed) {
      game.changeScene(new PlayScene());
    }
  }
}
