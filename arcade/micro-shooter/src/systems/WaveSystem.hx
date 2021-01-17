package systems;

import feint.assets.Assets;
import components.DropHealComponent;
import feint.renderer.Renderer;
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

    if (!wave.active) {
      if (wave.ready) {
        wave.cooldown = wave.waitTime;
        wave.active = true;
      } else {
        wave.cooldown -= elapsed;
        if (wave.cooldown <= 0) {
          wave.ready = true;
        }
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
          new PositionComponent(20 + Math.random() * (600 - (16 * 4)), 0),
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
          new PositionComponent(20 + Math.random() * (600 - (16 * 4)), 0),
          new VelocityComponent(0, 80 + Math.random() * 20),
          new SpriteComponent(asteroidSprite),
          new HitboxComponent(2 * 4, 2 * 4, 12 * 4, 12 * 4),
          new SoulComponent()
        ], ['asteroid']);
      }
    }

    if (wave.active && wave.waveKills >= wave.waveShips) {
      clearWave(wave, forge);
    }
  }

  function createAsteroidSprite() {
    var asteroidSprite = new Sprite(Assets.asteroids_sheet__png);
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
    var shipSprite = new Sprite(Assets.enemies_sheet__png);
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

  function clearWave(wave:WaveComponent, forge:Forge) {
    // Cleanup entities
    var bullets = forge.getEntities([PositionComponent], ['bullet']);
    for (bullet in bullets) {
      forge.removeEntity(bullet);
    }
    var enemyShips = forge.getEntities([PositionComponent], ['enemy', 'ship']);
    for (enemyShip in enemyShips) {
      forge.removeEntity(enemyShip);
    }
    var asteroids = forge.getEntities([PositionComponent], ['asteroid']);
    for (asteroid in asteroids) {
      forge.removeEntity(asteroid);
    }

    // Setup next wave
    wave.currentWave++;
    wave.active = false;
    wave.ready = false;
    wave.cooldown = wave.waitTime;
    wave.waveKills = 0;
    wave.waveShips += 2; // +2 ship every wave
    wave.maxConcurrentShips = Math.floor((wave.currentWave - 1) / 3) + 2; // +1 ship every 3th wave
    wave.maxConcurrentAsteroids = Math.floor((wave.currentWave - 1) / 5); // +1 ship every 5th wave
  }
}

class WaveRenderSystem extends RenderSystem {
  public function new() {}

  override function render(renderer:Renderer, forge:Forge) {
    final waveEntity = forge.getEntities([WaveComponent]).shift();
    final wave = forge.getEntityComponent(waveEntity, WaveComponent);

    if (!wave.active) {
      renderer.drawText(
        Math.floor(640 / 2),
        Math.floor(640 / 2 - 32),
        'Wave ${wave.currentWave}',
        64,
        '"kenney_mini", sans-serif',
        Center
      );
    }

    #if (debug && false)
    renderer.drawText(
      0,
      64,
      'Wave ${wave.currentWave}, ${wave.active}, ${wave.ready}; ${wave.maxConcurrentShips}, ${wave.maxConcurrentAsteroids}',
      16,
      '"kenney_mini", sans-serif'
    );
    #end
  }
}
