package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.FlxObject;
import flixel.math.FlxPoint;

class PlayState extends FlxState {
  var level: Level;
  var hud: HUD;

  override public function create(): Void {
    super.create();

    FlxG.mouse.useSystemCursor = true;

    level = new Level('test');
    add(level);

    hud = new HUD();
    hud.x = -level.width;
    hud.y = -level.height;
    add(hud);

    FlxG.camera.focusOn(new FlxPoint(level.width / 2, level.height / 2));
    FlxG.camera.bgColor = 0xFFdb1b3b;
  }

  override public function update(elapsed: Float): Void {
    super.update(elapsed);
  }
}
