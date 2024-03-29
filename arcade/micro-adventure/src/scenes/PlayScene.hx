package scenes;

import worlds.WorldRigidBodySystem;
import feint.utils.Point;
import feint.physics.AABB;
import feint.physics.RigidBodyComponent;
import feint.library.HitboxComponent;
import player.PlayerFollowCameraSystem;
import worlds.MainWorldComponent;
import tiles.TileComponent;
import tiles.TileRenderSystem;
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

    var world = new worlds.MainWorld();
    var level = world.all_levels.Level;
    var layer = level.l_Tiles;

    var tileSprite = new Sprite(Assets.adventure_tiles__png);
    tileSprite.textureWidth = 160;
    tileSprite.textureHeight = 160;
    tileSprite.alpha = 0;

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
      new RigidBodyComponent(new AABB(new Point(8, 8), new Point(8, 8)), true, false)
    ], ['player']);
    for (y in 0...layer.cHei) {
      for (x in 0...layer.cWid) {
        if (layer.hasAnyTileAt(x, y)) {
          var tileId = layer.getTileStackAt(x, y)[0].tileId;
          forge.addEntity(Entity.create(), [
            new SpriteComponent(tileSprite),
            new PositionComponent(x * 16, y * 16),
            new TileComponent(tileId),
            new MainWorldComponent(world),
            new RigidBodyComponent(
              new AABB(new Point(x * 16 + 8, y * 16 + 8), new Point(8, 8)),
              [40, 41, 42, 43, 44, 45, 50, 52, 53, 55, 60, 62, 63, 65, 70, 72, 73, 75].indexOf(
                tileId
              ) != -1,
              true
            )
          ]);
        }
      }
    }
    forge.addSystems([
      new PlayerActionsSystem(game.window.inputManager),
      new PlayerMovementSystem(),
      new PlayerCombatSystem(),
      new PlayerAnimateSystem(),
      new SpriteAnimationSystem(),
      new WorldRigidBodySystem(),
      new PlayerFollowCameraSystem(camera, level.pxWid, level.pxHei),
    ]);
    forge.addRenderSystems([new SpriteRenderSystem(), new TileRenderSystem()]);
  }
}
