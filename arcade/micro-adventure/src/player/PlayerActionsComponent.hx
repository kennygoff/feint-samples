package player;

import feint.forge.Component;

@shape('actions')
class PlayerActionsComponent extends Component {
  var left:Bool;
  var right:Bool;
  var up:Bool;
  var down:Bool;
  var attack:Bool;
  var shield:Bool;

  public function new() {
    left = false;
    right = false;
    up = false;
    down = false;
    attack = false;
    shield = false;
  }
}
