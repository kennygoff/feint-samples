package player;

import feint.forge.Component;

enum Direction {
  Up;
  Down;
  Left;
  Right;
}

@shape('state')
class PlayerStateComponent extends Component {
  public var facing:Direction;
  public var attacking:Bool;
  public var attackFrame:Int;

  public function new() {
    facing = Down;
    attacking = false;
    attackFrame = 0;
  }
}
