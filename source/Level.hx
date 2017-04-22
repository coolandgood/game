package;

import flixel.tile.FlxTilemap;
import flixel.FlxObject;

class Level extends FlxTilemap {
  public function new(mapData: Array<Int>, lvWidth: Int, lvHeight: Int) {
    super();

    loadMapFromArray(mapData, lvWidth, lvHeight, AssetPaths.tileset__png, 16, 16);
  }
}
