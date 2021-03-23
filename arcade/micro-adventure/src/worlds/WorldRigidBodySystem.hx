package worlds;

import feint.utils.Point;
import feint.forge.Entity.EntityId;
import feint.library.PositionComponent;
import feint.forge.Forge;
import feint.library.VelocityComponent;
import feint.physics.RigidBodyComponent;
import feint.forge.System;

private typedef Shape = {
  id:EntityId,
  position:PositionComponent,
  velocity:VelocityComponent,
  rigidBody:RigidBodyComponent
}

class WorldRigidBodySystem extends System {
  public function new() {}

  override function update(elapsed:Float, forge:Forge) {
    var player:Shape = cast forge.getShapes(
      [PositionComponent, VelocityComponent, RigidBodyComponent],
      ['player']
    )
      .pop();
    var rigidBodies:Array<Shape> = cast forge.getShapes([PositionComponent, RigidBodyComponent]);
    var tiles = rigidBodies.filter(rb -> rb.id != player.id);
    var solidTiles = tiles.filter(rb -> rb.rigidBody.solid);

    var sweep = player.rigidBody.collider.sweepInto(
      solidTiles.map(tile -> tile.rigidBody.collider),
      new Point(player.velocity.x * (elapsed / 1000), player.velocity.y * (elapsed / 1000))
    );

    if (sweep.hit != null) {
      // trace(new Point(player.velocity.x * (elapsed / 1000), player.velocity.y * (elapsed / 1000)));
      // trace(sweep);
      // trace(player.rigidBody.collider);
      // trace(sweep.hit.collider);
      // TODO: Sliding correction based on sweep.time
      player.position.x = sweep.pos.x - 8;
      player.position.y = sweep.pos.y - 8;
    } else {
      player.position.x = sweep.pos.x - 8;
      player.position.y = sweep.pos.y - 8;
      // player.position.x += player.velocity.x * (elapsed / 1000);
      // player.position.y += player.velocity.y * (elapsed / 1000);
    }

    // Update rigid bodies
    player.rigidBody.collider.pos.x = player.position.x + 8;
    player.rigidBody.collider.pos.y = player.position.y + 8;

    // Sliding correction based on sweep.time
    // Second sweep if there's a hit to see if we can slide on the walls
    if (sweep.hit != null) {
      var hitRight = Math.abs(
        (player.rigidBody.collider.pos.x
          +
          player.rigidBody.collider.half.x) - (sweep.hit.collider.pos.x - sweep.hit.collider.half.x)
      ) < 0.01;
      var hitLeft = Math.abs(
        (player.rigidBody.collider.pos.x
          - player.rigidBody.collider.half.x) - (sweep.hit.collider.pos.x +
          sweep.hit.collider.half.x)
      ) < 0.01;
      var hitBottom = Math.abs(
        (player.rigidBody.collider.pos.y
          +
          player.rigidBody.collider.half.y) - (sweep.hit.collider.pos.y - sweep.hit.collider.half.y)
      ) < 0.01;
      var hitTop = Math.abs(
        (player.rigidBody.collider.pos.y
          - player.rigidBody.collider.half.x) - (sweep.hit.collider.pos.y +
          sweep.hit.collider.half.y)
      ) < 0.01;
      if (hitRight || hitLeft) {
        player.velocity.x = 0;
      }
      if (hitBottom || hitTop) {
        player.velocity.y = 0;
      }

      WorldRigidBodySystem.sweep(player, solidTiles, elapsed * (1 - sweep.time));
    }
  }

  static function sweep(player:Shape, tiles:Array<Shape>, elapsed:Float) {
    var sweep = player.rigidBody.collider.sweepInto(
      tiles.map(tile -> tile.rigidBody.collider),
      new Point(player.velocity.x * (elapsed / 1000), player.velocity.y * (elapsed / 1000))
    );

    if (sweep.hit != null) {
      // trace(new Point(player.velocity.x * (elapsed / 1000), player.velocity.y * (elapsed / 1000)));
      // trace(sweep);
      // trace(player.rigidBody.collider);
      // trace(sweep.hit.collider);
      player.position.x = sweep.pos.x - 8;
      player.position.y = sweep.pos.y - 8;
    } else {
      player.position.x = sweep.pos.x - 8;
      player.position.y = sweep.pos.y - 8;
      // player.position.x += player.velocity.x * (elapsed / 1000);
      // player.position.y += player.velocity.y * (elapsed / 1000);
    }

    // Update rigid bodies
    player.rigidBody.collider.pos.x = player.position.x + 8;
    player.rigidBody.collider.pos.y = player.position.y + 8;
  }
}
