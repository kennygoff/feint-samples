package tiles;

import feint.forge.Component;

@shape('tile')
class TileComponent extends Component {
  public var tileId:Int;

  public function new(tileId:Int) {
    this.tileId = tileId;
  }
}
