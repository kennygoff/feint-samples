package player;

import feint.forge.Component;

@shape('actions')
class PlayerActionsComponent extends Component {
  public var left:Bool;
  public var right:Bool;
  public var up:Bool;
  public var down:Bool;
  public var attack:Bool;
  public var shield:Bool;

  public function new() {
    left = false;
    right = false;
    up = false;
    down = false;
    attack = false;
    shield = false;
  }
}
