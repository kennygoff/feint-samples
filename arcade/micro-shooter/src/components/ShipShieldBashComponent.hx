package components;

import feint.forge.Component;

class ShipShieldBashComponent extends Component {
  public var isBashing:Bool;
  public var bashRate:Float;
  public var cooldown:Float;

  /**
   * @param bashRate Cooldown time in milliseconds after each bash
   */
  public function new(bashRate:Float) {
    this.bashRate = bashRate;
    this.cooldown = 0;
    this.isBashing = false;
  }
}
