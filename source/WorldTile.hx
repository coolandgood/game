package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.input.mouse.FlxMouseEventManager;

class WorldTile extends FlxSprite {
  public var tx: Int;
  public var ty: Int;
  var world: World;

  override public function new(world, tilex, tiley) {
    var width = 64;
    var height = 56; //Math.sqrt(3) / 2 * width;

    var horiz = width * 3/4;
    var vert = height;

    var x: Float = tilex * horiz;
    var y: Float = tiley * vert;

    // even-q vertical layout
    if (tilex % 2 == 1) {
      y -= vert / 2;
    }

    super(x, y);
    this.world = world;

    loadGraphic(AssetPaths.hex_tile__png);

    tx = tilex;
    ty = tiley;

    // simple mouseover stuff
    FlxMouseEventManager.add(this, null, null, onMouseIn, onMouseOut);
  }

  private function onMouseIn(self: WorldTile) {
    trace(tx, ty);
    loadGraphic(AssetPaths.hex_tile_blue__png);
  }

  private function onMouseOut(self: WorldTile) {
    loadGraphic(AssetPaths.hex_tile__png);
  }

  public function neighbour(direction) {
    var directions = [
      [ [ 1,  1], [ 1,  0], [ 0, -1],
        [-1,  0], [-1,  1], [ 0,  1] ],
      [ [ 1,  0], [ 1, -1], [ 0, -1],
        [-1, -1], [-1,  0], [ 0,  1] ]
    ];

    var parity = ty & 1;
    var dir = directions[parity][direction];

    return world.map[dir[1]][dir[0]];
  }
}
