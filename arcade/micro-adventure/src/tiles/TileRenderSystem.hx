package tiles;

import worlds.MainWorldComponent;
import tiles.TileComponent;
import feint.forge.Entity.EntityId;
import feint.renderer.Renderer;
import feint.forge.Forge;
import feint.forge.System.RenderSystem;
import feint.library.PositionComponent;
import feint.library.SpriteComponent;

private typedef Shape = {
  id:EntityId,
  sprite:SpriteComponent,
  position:PositionComponent,
  tile:TileComponent,
  mainWorld:MainWorldComponent
}

class TileRenderSystem extends RenderSystem {
  public function new() {}

  override function render(renderer:Renderer, forge:Forge) {
    var sprites:Array<Shape> = cast forge.getShapes(
      [SpriteComponent, PositionComponent, TileComponent, MainWorldComponent]
    );
    // var visibleSprites = sprites.filter(sprite -> sprite.sprite.sprite.alpha > 0);

    for (sprite in sprites) {
      sprite.sprite.sprite.drawTileAt(
        sprite.position.x,
        sprite.position.y,
        10,
        10,
        sprite.tile.tileId,
        renderer
      );
    }
  }
}
