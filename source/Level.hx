package;

import flixel.tile.FlxTilemap;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;

import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;

class Level extends FlxGroup {
  var tilemap: FlxTilemap;
  var shadowTilemap: FlxTilemap;
  var border: FlxTilemap;
  var player: Player;

  public var width: Int;
  public var height: Int;

  public function new(level: String) {
    super();

    var player = new Player(32, 32);

    var map = new TiledMap('assets/data/$level.tmx');
    var solidLayer: TiledTileLayer = cast map.getLayer('solid');

    tilemap = new FlxTilemap();
    tilemap.loadMapFromArray(solidLayer.tileArray,
                             map.width,
                             map.height,
                             AssetPaths.tileset__png,
                             16, 16, 1);

    shadowTilemap = new FlxTilemap();
    shadowTilemap.loadMapFromArray(solidLayer.tileArray,
                                   map.width,
                                   map.height,
                                   AssetPaths.tileset_shadow__png,
                                   16, 16, 1);

    shadowTilemap.x = shadowTilemap.y = 4;

    add(shadowTilemap);
    add(player);
    add(tilemap);
    add(genBorder(map.width + 3, map.height + 3));

    var objectsLayer: TiledObjectLayer = cast map.getLayer('objects');
    var objects: Array<TiledObject> = objectsLayer.objects;

    for (object in objects) {
      if (object.type == "spawn")
        player.setPosition(object.x, object.y);
    }

    player.lvWidth = width = map.width * 16;
    player.lvHeight = height = map.height * 16;
  }

  override public function update(elapsed: Float) {
    super.update(elapsed);

    FlxG.collide(player, tilemap);
  }

  /*
  override public function draw() {
    super.draw();
  }
  */

  private function genBorder(width: Int, height: Int): FlxTilemap {
    var borderData: Array<Int> = [];

    for (y in 0...height) {
      for (x in 0...width) {
        if (y == height-1) borderData.push(6);
        else if (x == width-1) borderData.push(6);
        else if (y == 0 || y == height-2) borderData.push(2);
        else if (x == 0) borderData.push(2);
        else if (x == width-2) borderData.push(2);
        else borderData.push(0);
      }
    }

    border = new FlxTilemap();
    border.loadMapFromArray(borderData,
                            width,
                            height,
                            AssetPaths.tileset__png,
                            16, 16, 1);

    trace(border);
    border.x = border.y = -16;
    return border;
  }
}
