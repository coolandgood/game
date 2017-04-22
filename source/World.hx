package;

import flixel.group.FlxGroup;
import flixel.text.FlxText;

class World extends FlxGroup {
  public var map: Array<Array<WorldTile>>;

  public function new() {
    super();

    var coordMap = [
      [0, 0], [1, 0], [2, 0],
      [0, 1], [1, 1], [2, 1],
              [1, 2]
    ];

    map = [];

    for (coords in coordMap) {
      var x = coords[0];
      var y = coords[1];

      var tile = new WorldTile(this, x, y);

      if (map[x] == null) map[x] = [];
      map[x][y] = tile;

      add(tile);
    }
  }
}
