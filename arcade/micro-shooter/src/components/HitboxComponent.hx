package components;

using Lambda;

import feint.renderer.Renderer;
import feint.forge.Forge;
import feint.forge.System.RenderSystem;
import feint.forge.Component;

class HitboxComponent extends Component {
  public var x:Float;
  public var y:Float;
  public var width:Float;
  public var height:Float;

  public function new(x:Float, y:Float, width:Float, height:Float) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }
}

class HitboxDebugRenderSystem extends RenderSystem {
  public var defaultColor:Int;
  public var colors:Map<String, Int>;

  public function new(defaultColor:Int = 0xFFFFFFFF, ?colors:Map<String, Int>) {
    this.defaultColor = defaultColor;
    this.colors = colors != null ? colors : [];
  }

  override function render(renderer:Renderer, forge:Forge) {
    var objectEntities = forge.getEntities([PositionComponent, HitboxComponent]);
    var objects = objectEntities.map(entityId -> {
      labels: forge.getEntityLabels(entityId, [for (key in colors.keys()) key]),
      position: forge.getEntityComponent(entityId, PositionComponent),
      hitbox: forge.getEntityComponent(entityId, HitboxComponent)
    });

    for (object in objects) {
      renderer.drawRect(
        Math.floor(object.position.x + object.hitbox.x),
        Math.floor(object.position.y + object.hitbox.y),
        Math.floor(object.hitbox.width),
        Math.floor(object.hitbox.height),
        0,
        object.labels.length > 0 ? colors[object.labels[0]] : defaultColor
      );
    }
  }
}
