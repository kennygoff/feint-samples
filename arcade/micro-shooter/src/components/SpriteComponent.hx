package components;

import feint.Window;
import components.ui.UIPositionComponent;
import feint.renderer.Renderer;
import feint.forge.Forge;
import feint.forge.System;
import feint.forge.Component;
import feint.graphics.Sprite;

class SpriteComponent extends Component {
  public var sprite:Sprite;

  public function new(sprite:Sprite) {
    this.sprite = sprite;
  }
}

class SpriteSystem extends System {
  public function new() {}

  override function update(elapsed:Float, forge:Forge) {
    var spriteEntities = forge.getEntities([SpriteComponent]);
    var sprites = spriteEntities.map(
      entityId -> forge.getEntityComponent(entityId, SpriteComponent)
    );

    var animatedSprites = sprites.filter(sprite -> sprite.sprite.animation != null);
    for (animatedSprite in animatedSprites) {
      animatedSprite.sprite.animation.update();
    }
  }
}

class UISpriteRenderSystem extends RenderSystem {
  var window:Window;

  public function new(window:Window) {
    this.window = window;
  }

  override function render(renderer:Renderer, forge:Forge) {
    var spriteEntities = forge.getEntities([SpriteComponent, UIPositionComponent]);
    var uiSprites = spriteEntities.map(entityId -> {
      return {
        sprite: forge.getEntityComponent(entityId, SpriteComponent),
        position: forge.getEntityComponent(entityId, UIPositionComponent)
      }
    });

    for (uiSprite in uiSprites) {
      uiSprite.sprite.sprite.drawAt(uiSprite.position.x, uiSprite.position.y, renderer, 3);
    }
  }
}

class SpriteRenderSystem extends RenderSystem {
  public function new() {}

  override function render(renderer:Renderer, forge:Forge) {
    var spriteEntities = forge.getEntities([SpriteComponent, PositionComponent]);
    var sprites = spriteEntities.map(entityId -> {
      return {
        sprite: forge.getEntityComponent(entityId, SpriteComponent),
        position: forge.getEntityComponent(entityId, PositionComponent)
      }
    });

    for (sprite in sprites) {
      sprite.sprite.sprite.drawAt(
        Math.floor(sprite.position.x),
        Math.floor(sprite.position.y),
        renderer,
        4
      );
    }
  }
}
