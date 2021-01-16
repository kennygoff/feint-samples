package components;

import feint.forge.Component;

class ShipHealthComponent extends Component {
  public var health:Int;
  public var hurtFrames:Int;

  public function new(health:Int) {
    this.health = health;
    this.hurtFrames = 0;
  }
}
