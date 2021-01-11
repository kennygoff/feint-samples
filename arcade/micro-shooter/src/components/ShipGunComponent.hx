package components;

import feint.forge.Component;

class ShipGunComponent extends Component {
  public var ready:Bool;
  public var fireRate:Float;
  public var cooldown:Float;

  /**
   * @param fireRate Cooldown time in milliseconds after each shot
   */
  public function new(fireRate:Float) {
    this.fireRate = fireRate;
    this.cooldown = 0;
    this.ready = true;
  }
}
