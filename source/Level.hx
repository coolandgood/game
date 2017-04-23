package;

import flixel.tile.FlxTilemap;
import flixel.tile.FlxTile;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

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

  public var objects: Array<TiledObject> = [];
  private var parent: FlxState;

  private var going: Bool = false;

  public function new(level: String, parent: FlxState) {
    super();
    this.parent = parent;
    visible = false;

    player = new Player(32, 32, this);
    player.controllable = false;

    var map = new TiledMap('assets/data/$level.tmx');
    var solidLayer: TiledTileLayer = cast map.getLayer('solid');

    tilemap = new FlxTilemap();
    tilemap.loadMapFromArray(solidLayer.tileArray,
                             map.width,
                             map.height,
                             AssetPaths.tileset__png,
                             16, 16, 1);

    // one way tiles
    tilemap.setTileProperties(7,  FlxObject.RIGHT);
    tilemap.setTileProperties(13, FlxObject.RIGHT);
    tilemap.setTileProperties(8,  FlxObject.DOWN);
    tilemap.setTileProperties(14, FlxObject.DOWN);
    tilemap.setTileProperties(9,  FlxObject.UP);
    tilemap.setTileProperties(15, FlxObject.UP);
    tilemap.setTileProperties(10, FlxObject.LEFT);
    tilemap.setTileProperties(16, FlxObject.LEFT);

    // tile that breaks after stepping on
    tilemap.setTileProperties(17, FlxObject.UP, function(tile, object) {
      // TODO particles would be nice
      var disappearingTile: FlxSprite = tilemap.tileToSprite(cast tile.x / 16, cast tile.y / 16);
      add(disappearingTile);

      tilemap.setTile(cast tile.x / 16, cast tile.y / 16, 4);
      shadowTilemap.setTile(cast tile.x / 16, cast tile.y / 16, 4);

      new FlxTimer().start(0.2,
        function(timer) {
          disappearingTile.alpha -= 0.1;
          if (timer.loopsLeft == 0) {
            // XXX: why does this not work
            tilemap.setTile(cast tile.x / 16, cast tile.y / 16, 0);
            shadowTilemap.setTile(cast tile.x / 16, cast tile.y / 16, 0);
          }
        },
        10);
    }, Player);

    // finish level tile
    tilemap.setTileProperties(3, FlxObject.NONE);

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
    objects = objectsLayer.objects;

    for (object in objects) {
      if (object.type == "spawn")
        player.setPosition(object.x, object.y);

      if (object.type == "music")
        FlxG.sound.playMusic(object.name, 1, true);
    }

    player.lvWidth = width = map.width * 16;
    player.lvHeight = height = map.height * 16;
  }

  public function go() {
    // animate!

    visible = true;
    trace('level go!');

    var things = [ player, tilemap, shadowTilemap, border ];
    for (thing in things) {
      var oy = thing.y;
      thing.y -= 640;
      FlxTween.tween(thing, { y: oy }, 0.6, {
        ease: FlxEase.expoOut,
        type: FlxTween.PERSIST,
        onComplete: function(tween: FlxTween) {
          going = true;
        }
      });
    }

    player.controllable = true;
  }

  override public function update(elapsed: Float) {
    super.update(elapsed);

    if (!going) return;

    FlxG.collide(tilemap, player);

    if (player.alive) {
      // check for collisions with `finish` objects
      // XXX: could this be optimised?
      for (object in objects) {
        if (object.type == "finish") {
          var overlaps: Bool = player.x >= object.x - object.width / 2
            && player.x <= object.x + object.width / 2 
            && player.y >= object.y - object.height / 2
            && player.y <= object.y + object.height / 2;

          if (overlaps) {
            end(object);
            break;
          }
        }
      }
    }
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

    border.x = border.y = -16;
    return border;
  }

  public function end(object: TiledObject) {
    player.controllable = false;
    player.explode();

    FlxG.sound.music.stop(); // TODO: sfx

    new FlxTimer().start(1.5, function(timer: FlxTimer) {
      // close off the level
      FlxG.camera.fade(0xffdb1b3b, 0.2, false, function() {
        var nextLevel = new Level(object.name, parent);
        parent.add(nextLevel);

        trace('next level', object.name);
        destroy();

        nextLevel.go();
      });
    });
  }
}
