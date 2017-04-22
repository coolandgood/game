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
  var hud: HUD;

  override public function create(): Void {
    super.create();

    FlxG.mouse.useSystemCursor = true;

    var map: Array<Int> = [
      0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0,
      1, 0, 0, 0, 1, 1, 1,
      1, 0, 0, 0, 0, 0, 1,
      1, 0, 0, 0, 0, 0, 1,
      1, 0, 0, 1, 1, 1, 1
    ];

    player = new Player(32, 8);
    add(player);

    level = new Level(map, 7, 6);
    add(level);

    hud = new HUD();
    add(hud);

    FlxG.camera.bgColor = 0xFFdb1b3b;
  }

  override public function update(elapsed: Float): Void {
    super.update(elapsed);

    FlxG.collide(player, level);
  }
}
