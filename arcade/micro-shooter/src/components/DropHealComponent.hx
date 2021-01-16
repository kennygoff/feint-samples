package components;

import feint.forge.Component;

class DropHealComponent extends Component {
  public var heal:Int;

  public function new(heal:Int) {
    this.heal = heal;
  }
}
