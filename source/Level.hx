package;

import flixel.tile.FlxTilemap;
import flixel.FlxG;
import flixel.group.FlxGroup;

import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;

class Level extends FlxGroup {
  var tilemap: FlxTilemap;
  var shadowTilemap: FlxTilemap;
  var player: Player;

  public var width: Int;
  public var height: Int;

  public function new(level: String) {
    super();

    var player = new Player(32, 32);
    add(player);

    var map = new TiledMap('assets/data/$level.tmx');
    var mainLayer: TiledTileLayer = cast map.getLayer('solid');

    tilemap = new FlxTilemap();
    tilemap.loadMapFromArray(mainLayer.tileArray,
                             map.width,
                             map.height,
                             AssetPaths.tileset__png,
                             16, 16, 1);

    shadowTilemap = new FlxTilemap();
    shadowTilemap.loadMapFromArray(mainLayer.tileArray,
                                   map.width,
                                   map.height,
                                   AssetPaths.tileset_shadow__png,
                                   16, 16, 1);

    shadowTilemap.x = shadowTilemap.y = 4;

    add(shadowTilemap);
    add(tilemap);

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
}
