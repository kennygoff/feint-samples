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
  public var waitTime:Int;
  public var waveKills:Int;
  public var kills:Int;
  public var waveShips:Int;

  public function new(waitTime:Int) {
    this.currentWave = 1;
    this.shipsRemaining = 2;
    this.waveShips = 2;
    this.maxConcurrentShips = 2;
    this.maxConcurrentAsteroids = 0;
    this.ready = false;
    this.active = false;
    this.cooldown = waitTime;
    this.waitTime = waitTime;
    this.waveKills = 0;
    this.kills = 0;
  }
}
