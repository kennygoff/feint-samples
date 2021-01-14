package components;

import feint.forge.Component;

class ShipShieldComponent extends Component {
  public var shields:Int;

  public function new(shields:Int) {
    this.shields = shields;
  }
}
