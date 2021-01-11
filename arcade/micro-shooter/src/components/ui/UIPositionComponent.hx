package components.ui;

import feint.forge.Component;

class UIPositionComponent extends Component {
  public var x:Int;
  public var y:Int;

  public function new(x:Int, y:Int) {
    this.x = x;
    this.y = y;
  }
}
