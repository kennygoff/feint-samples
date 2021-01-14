package components;

import feint.forge.Component;

class AccelerationComponent extends Component {
  public var x:Float;
  public var y:Float;

  public function new(x:Float, y:Float) {
    this.x = x;
    this.y = y;
  }
}
