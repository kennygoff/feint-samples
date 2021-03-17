package worlds;

import feint.forge.Component;

@shape('mainWorld')
class MainWorldComponent extends Component {
  public var world:worlds.MainWorld;

  public function new(world:worlds.MainWorld) {
    this.world = world;
  }
}
