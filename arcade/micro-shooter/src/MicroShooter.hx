package;

import feint.Application;
import scenes.MenuScene;

class MicroShooter extends Application {
  override function init() {
    game.setInitialScene(new MenuScene());
  }

  static public function main() {
    new MicroShooter({
      title: "Micro Shooter",
      size: {
        width: 640,
        height: 640
      }
    });
  }
}
