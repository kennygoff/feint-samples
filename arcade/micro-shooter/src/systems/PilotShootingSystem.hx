package systems;

import feint.audio.AudioFile;
import feint.assets.Assets;
import feint.graphics.Sprite;
import components.HitboxComponent;
import components.ShipGunComponent;
import feint.forge.Entity;
import components.VelocityComponent;
import feint.input.device.Keyboard.KeyCode;
import components.PositionComponent;
import components.SpriteComponent;
import feint.input.InputManager;
import feint.forge.Forge;
import feint.forge.System;

class PilotShootingSystem extends System {
  var inputManager:InputManager;
  var shootSound:AudioFile;

  public function new(inputManager:InputManager) {
    this.inputManager = inputManager;
    this.shootSound = new AudioFile(Assets.laserRetro_000__ogg, 0.1);
  }

  override function update(elapsed:Float, forge:Forge) {
    var shipEntity = forge.getEntities([SpriteComponent, PositionComponent, ShipGunComponent])
      .shift();
    var ship = {
      sprite: forge.getEntityComponent(shipEntity, SpriteComponent),
      position: forge.getEntityComponent(shipEntity, PositionComponent),
      gun: forge.getEntityComponent(shipEntity, ShipGunComponent)
    };

    if (
      ship.gun.ready &&
      (
        inputManager.keyboard.keys[KeyCode.X] == JustPressed ||
        inputManager.keyboard.keys[KeyCode.X] == Pressed
      )
    ) {
      var width = 16 * 4;
      forge.addEntity(Entity.create(), [
        new SpriteComponent(createBulletSprite()),
        new PositionComponent(
          ship.position.x + (width / 2) - ((16 * 4) / 2),
          ship.position.y - (16 * 4) + (8 * 4)
        ),
        new VelocityComponent(0, -800),
        new HitboxComponent(6 * 4, 4 * 4, 4 * 4, 8 * 4)
      ], ["bullet", "player"]);

      ship.gun.cooldown = ship.gun.fireRate;
      ship.gun.ready = false;

      shootSound.play();
    }
  }

  function createBulletSprite() {
    var bulletSprite = new Sprite(Assets.bullets_sheet__png);
    bulletSprite.textureWidth = 320;
    bulletSprite.textureHeight = 16;
    bulletSprite.setupSpriteSheetAnimation(16, 16, ["shoot" => [0], "hit" => [1, 2]]);
    bulletSprite.animation.play("shoot", 10);
    return bulletSprite;
  }
}
