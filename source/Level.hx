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
  var shadowLayer: FlxGroup;
  var border: FlxTilemap;
  var player: Player;

  public var width: Int;
  public var height: Int;

  public var objects: Array<TiledObject> = [];
  private var parent: FlxState;

  private var going: Bool = false;
  private var music: String;

  public function new(level: String, parent: FlxState) {
    super();
    this.parent = parent;
    visible = false;

    load(level);
  }

  public function getMeta(level: String) {
    var map = new TiledMap('assets/data/$level.tmx');
    var objectsLayer: TiledObjectLayer = cast map.getLayer('objects');
    objects = objectsLayer.objects;

    var song: String = '';

    for (object in objects) {
      if (object.type == 'music')
        song = object.name;
    }

    return {
      music: song
    };
  }

  public function load(level: String) {
    if (tilemap != null) tilemap.destroy();
    if (shadowTilemap != null) shadowTilemap.destroy();
    if (shadowLayer != null) shadowLayer.destroy();
    if (border != null) border.destroy();
    if (player != null) player.destroy();

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
      var tileX:Int = Math.floor(tile.x / 16);
      var tileY:Int = Math.floor(tile.y / 16);
      var shadowX:Int = tileX + 1;
      var shadowY:Int = tileY + 1;

      // TODO particles would be nice
      var disappearingTile: FlxSprite = tilemap.tileToSprite(tileX, tileY, 4);
      var disappearingShadowTile: FlxSprite = shadowTilemap.tileToSprite(shadowX, shadowY, 4);
      add(disappearingTile);
      shadowLayer.add(disappearingShadowTile);

      new FlxTimer().start(0.2,
        function(timer) {
          disappearingTile.alpha -= 0.1;
          disappearingShadowTile.alpha = disappearingTile.alpha;
          if (disappearingTile.alpha <= 0.01) {
            tilemap.setTile(tileX, tileY, 0);
            shadowTilemap.setTile(shadowX, shadowY, 0);
            remove(disappearingTile);
            shadowLayer.remove(disappearingShadowTile);
            timer.cancel();
          }
        },
        10);
    }, Player);

    // finish level tile
    tilemap.setTileProperties(3, FlxObject.NONE);

    // spike
    tilemap.setTileProperties(11, FlxObject.NONE);

    // shadows
    var shadowTileArray:Array<Int> = [];

    shadowTileArray.push(solidLayer.tileArray[map.height * map.width - 1]);
    for (x in 0...map.width) {
      var i:Int = (map.height - 1) * map.width + x;
      // var i:Int = x;
      shadowTileArray.push(solidLayer.tileArray[i]);
    }

    for (y in 0...map.height) {
      var i:Int = y * map.width;
      shadowTileArray.push(solidLayer.tileArray[i + map.width - 1]);
      for (x in 0...map.width) {
        shadowTileArray.push(solidLayer.tileArray[i + x]);
      }
    }

    shadowTilemap = new FlxTilemap();
    shadowTilemap.loadMapFromArray(shadowTileArray,
                                   map.width + 1,
                                   map.height + 1,
                                   AssetPaths.tileset_shadow__png,
                                   16, 16, 1);

    shadowTilemap.x = shadowTilemap.y = 4 - 16;

    // A separate group to act as the layer the shadow tilemap will be added
    // to, so that we can later add new shadow sprites to this layer (and below
    // normal tiles and sprites).
    shadowLayer = new FlxGroup();
    shadowLayer.add(shadowTilemap);
    add(shadowLayer);

    add(player);
    add(tilemap);
    add(genBorder(map.width + 3, map.height + 3));

    var objectsLayer: TiledObjectLayer = cast map.getLayer('objects');
    objects = objectsLayer.objects;

    for (object in objects) {
      if (object.type == "spawn")
        player.setPosition(object.x, object.y);

      if (object.type == "music" && music != object.name) {
        music = object.name;
        FlxG.sound.playMusic(object.name, 1, true);
      }
    }

    player.lvWidth = width = map.width * 16;
    player.lvHeight = height = map.height * 16;
  }

  public function go() {
    // animate!

    visible = true;
    player.visible = false;
    player.immovable = true;
    trace('level go!');

    var things = [ tilemap, shadowTilemap, border ];
    for (thing in things) {
      var oy = thing.y;
      thing.y -= 640;
      FlxTween.tween(thing, { y: oy }, 0.6, {
        ease: FlxEase.expoOut,
        type: FlxTween.PERSIST,
        onComplete: function(tween: FlxTween) {
          going = true;

          player.visible = true;
          player.scale.x = 0; player.scale.y = 0;

          FlxTween.tween(player.scale, { x: 1, y: 1 }, 0.4, {
            ease: FlxEase.expoOut,
            type: FlxTween.PERSIST,
            onComplete: function(tween: FlxTween) {
              player.immovable = false;
              player.controllable = true;
            }
          });
        }
      });
    }
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

    if (getMeta(object.name).music != music)
      FlxG.sound.music.stop();

    new FlxTimer().start(1.5, function(timer: FlxTimer) {
      // close off the level
      FlxG.camera.fade(0xffdb1b3b, 0.2, false, function() {
        load(object.name);
        go();

        FlxG.camera.fade(0xffdb1b3b, 0, true); // reset fade
        trace('next level', object.name);
      });
    });
  }
}
