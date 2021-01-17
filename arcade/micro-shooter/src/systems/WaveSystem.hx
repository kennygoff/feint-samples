package systems;

import components.ShipHealthComponent;
import components.SoulComponent;
import components.HitboxComponent;
import components.SpriteComponent;
import components.VelocityComponent;
import components.PositionComponent;
import feint.forge.Entity;
import feint.graphics.Sprite;
import components.ShipGunComponent;
import components.WaveComponent;
import feint.forge.Forge;
import feint.forge.System;

class WaveSystem extends System {
  public function new() {}

  override function update(elapsed:Float, forge:Forge) {
    final waveEntity = forge.getEntities([WaveComponent]).shift();
    final wave = forge.getEntityComponent(waveEntity, WaveComponent);
    final shipEntities = forge.getEntities([ShipGunComponent], ['enemy', 'ship']);
    final ships = shipEntities.map(
      entityId -> {id: entityId, position: forge.getEntityComponent(entityId, PositionComponent)}
    );
    final asteroidEntities = forge.getEntities([PositionComponent], ['asteroid']);
    final asteroids = asteroidEntities.map(entityId -> {
      id: entityId,
      position: forge.getEntityComponent(entityId, PositionComponent)
    });

    if (!wave.active && !wave.ready) {
      if (wave.cooldown <= 0) {
        wave.cooldown = 0;
        wave.ready = true;
      }
    }

    if (!wave.active) {
      if (wave.ready) {
        wave.currentWave++;
        switch (wave.currentWave) {
          case 1:
            wave.maxConcurrentShips = 2;
            wave.shipsRemaining = 2;
            wave.maxConcurrentAsteroids = 2;
            wave.asteroidsRemaining = 2;
          default:
            wave.maxConcurrentShips = 0;
            wave.maxConcurrentAsteroids = 0;
        }
        wave.active = true;
      }
    }

    if (wave.active) {
      for (ship in ships) {
        if (ship.position.y > 640) {
          forge.removeEntity(ship.id);
        }
      }
      if (ships.length < wave.maxConcurrentShips) {
        var shipSprite = createShipSprite();
        var shipType = ["gambit", "storm", "beast", "cyclops"][Math.floor(Math.random() * 4)];
        var fireRate = ["gambit" => 1500, "storm" => 2000, "beast" => 3000, "cyclops" => 4000];
        shipSprite.animation.play(shipType, 10, true);
        forge.addEntity(Entity.create(), [
          new PositionComponent(Math.random() * 640, 0),
          new VelocityComponent(0, 30 + Math.random() * 20),
          new SpriteComponent(shipSprite),
          new ShipGunComponent(fireRate[shipType]),
          new HitboxComponent(1 * 4, 1 * 4, 14 * 4, 14 * 4),
          new SoulComponent(),
          new ShipHealthComponent(0)
        ], ['enemy', 'ship', shipType]);
      }
      for (asteroid in asteroids) {
        if (asteroid.position.y > 640) {
          forge.removeEntity(asteroid.id);
        }
      }
      if (asteroids.length < wave.maxConcurrentAsteroids) {
        var asteroidSprite = createAsteroidSprite();
        var asteroidType = ["0", "1", "2", "3"][Math.floor(Math.random() * 4)];
        asteroidSprite.animation.play(asteroidType, 10, true);
        forge.addEntity(Entity.create(), [
          new PositionComponent(Math.random() * 640, 0),
          new VelocityComponent(0, 80 + Math.random() * 20),
          new SpriteComponent(asteroidSprite),
          new HitboxComponent(2 * 4, 2 * 4, 12 * 4, 12 * 4),
          new SoulComponent()
        ], ['asteroid']);
      }
    }
  }

  function createAsteroidSprite() {
    var asteroidSprite = new Sprite('asteroids_sheet__png');
    asteroidSprite.textureWidth = 336;
    asteroidSprite.textureHeight = 16;
    asteroidSprite.setupSpriteSheetAnimation(
      16,
      16,
      ["0" => [0], "1" => [1], "2" => [2], "3" => [3], "death" => [4, 5, 6, 7]]
    );
    return asteroidSprite;
  }

  function createShipSprite() {
    var shipSprite = new Sprite('enemies_sheet__png');
    shipSprite.textureWidth = 400;
    shipSprite.textureHeight = 16;
    shipSprite.setupSpriteSheetAnimation(16, 16, [
      "gambit" => [0, 1, 2, 3],
      "storm" => [4, 5, 6, 7],
      "beast" => [8, 9, 10, 11],
      "cyclops" => [12, 13, 14, 15],
      "death" => [16, 17, 18],
      "death:bashed:left" => [19, 20, 21],
      "death:bashed:right" => [22, 23, 24]
    ]);
    return shipSprite;
  }
}
