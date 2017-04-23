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
  var border: FlxTilemap;
  var player: Player;

  public var width: Int;
  public var height: Int;

  public function new(level: String) {
    super();

    var player = new Player(32, 32);
    add(player);

    var map = new TiledMap('assets/data/$level.tmx');
    var solidLayer: TiledTileLayer = cast map.getLayer('solid');
    var borderLayer: TiledTileLayer = cast map.getLayer('border');

    tilemap = new FlxTilemap();
    tilemap.loadMapFromArray(solidLayer.tileArray,
                             map.width,
                             map.height,
                             AssetPaths.tileset__png,
                             16, 16, 1);
    add(tilemap);

    border = new FlxTilemap();
    border.loadMapFromArray(borderLayer.tileArray,
                             map.width,
                             map.height,
                             AssetPaths.tileset__png,
                             16, 16, 1);
    add(border);


    var objectsLayer: TiledObjectLayer = cast map.getLayer('objects');
    var objects: Array<TiledObject> = objectsLayer.objects;

    for (object in objects) {
      if (object.type == "spawn")
        player.setPosition(object.x, object.y);
    }

    width = map.width * 16;
    height = map.height * 16;

    player.lvWidth = width - 32;
    player.lvHeight = height - 32;
  }

  override public function update(elapsed: Float) {
    super.update(elapsed);

    FlxG.collide(player, tilemap);
  }

  override public function draw() {
    super.draw();
  }
}
