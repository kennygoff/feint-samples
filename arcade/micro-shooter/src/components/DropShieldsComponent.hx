package components;

import feint.forge.Component;

class DropShieldsComponent extends Component {
  public var shields:Int;

  public function new(shields:Int) {
    this.shields = shields;
  }
}
