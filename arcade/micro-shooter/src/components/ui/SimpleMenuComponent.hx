package components.ui;

import feint.Window;
import feint.renderer.Renderer;

using Lambda;

import feint.input.device.Keyboard.KeyCode;
import feint.forge.Forge;
import feint.forge.System;
import feint.input.InputManager;
import feint.forge.Component;

class SimpleMenuComponent extends Component {
  public var name:String;
  public var focused:Bool;
  public var order:Int;
  public var callback:() -> Void;

  public function new(name:String, order:Int, focused:Bool = false, ?callback:() -> Void) {
    this.name = name;
    this.order = order;
    this.focused = focused;
    this.callback = callback;
  }
}

class SimpleMenuSystem extends System {
  var inputManager:InputManager;
  var window:Window;

  public function new(inputManager:InputManager, window:Window) {
    this.inputManager = inputManager;
    this.window = window;
  }

  override function update(elapsed:Float, forge:Forge) {
    var optionEntities = forge.getEntities([SimpleMenuComponent]);
    var options = optionEntities.map(
      entityId -> forge.getEntityComponent(entityId, SimpleMenuComponent)
    );

    var selectionSpriteEntities = forge.getEntities([SpriteComponent, UIPositionComponent]);
    var selectionSpritePosition = selectionSpriteEntities.map(
      entityId -> forge.getEntityComponent(entityId, UIPositionComponent)
    )
      .shift();

    if (inputManager.keyboard.keys[KeyCode.Down] == JustPressed) {
      navigate(options, selectionSpritePosition, 1);
    } else if (inputManager.keyboard.keys[KeyCode.Up] == JustPressed) {
      navigate(options, selectionSpritePosition, -1);
    } else if (inputManager.keyboard.keys[KeyCode.Enter] == JustPressed) {
      if (options.find(option -> option.focused).callback != null) {
        options.find(option -> option.focused).callback();
      }
    }
  }

  function navigate(
    options:Array<SimpleMenuComponent>,
    selectedSpritePosition:UIPositionComponent,
    nav:Int
  ) {
    var selected:Int = options.find(option -> option.focused).order;
    selected = (selected + (options.length + nav)) % options.length;
    for (option in options) {
      option.focused = selected == option.order;
    }

    if (selectedSpritePosition != null) {
      selectedSpritePosition.y = Math.floor(window.height / 2) - 3 + (48 * selected);
    }
  }
}

class SimpleMenuRenderSystem extends RenderSystem {
  var window:Window;

  public function new(window:Window) {
    this.window = window;
  }

  override function render(renderer:Renderer, forge:Forge) {
    var optionEntities = forge.getEntities([SimpleMenuComponent]);
    var options = optionEntities.map(
      entityId -> forge.getEntityComponent(entityId, SimpleMenuComponent)
    );

    for (option in options) {
      renderer.drawText(
        Math.floor(window.width / 2),
        Math.floor(window.height / 2) + (48 * option.order),
        option.focused ? option.name.toUpperCase() : option.name.toLowerCase(),
        40,
        '"kenney_mini", sans-serif',
        Center
      );
    }
  }
}
