package components;

import feint.forge.Component;

class WaveComponent extends Component {
  public var currentWave:Int;
  public var shipsRemaining:Int;
  public var maxConcurrentShips:Int;
  public var asteroidsRemaining:Int;
  public var maxConcurrentAsteroids:Int;
  public var ready:Bool;
  public var active:Bool;
  public var cooldown:Float;

  public function new() {
    this.currentWave = 0;
    this.shipsRemaining = 0;
    this.maxConcurrentShips = 0;
    this.asteroidsRemaining = 0;
    this.maxConcurrentAsteroids = 0;
    this.ready = false;
    this.active = false;
    this.cooldown = 0;
  }
}
