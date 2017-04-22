package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.FlxObject;

class PlayState extends FlxState {
  var level: Level;
  var player: Player;

  override public function create(): Void {
    super.create();

    //FlxG.mouse.useSystemCursor = true;

    var map: Array<Int> = [
      0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0,
      1, 0, 0, 0, 1, 1, 1,
      1, 0, 0, 0, 0, 0, 1,
      1, 0, 0, 0, 0, 0, 1,
      1, 0, 0, 1, 1, 1, 1
    ];

    level = new Level(map, 7, 6);
    add(level);

    player = new Player(32, 8);
    add(player);

    FlxG.camera.bgColor = 0xFF140c1c;
  }

  override public function update(elapsed: Float): Void {
    super.update(elapsed);

    FlxG.collide(player, level);
  }
}
