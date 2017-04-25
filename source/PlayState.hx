package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.FlxObject;
import flixel.math.FlxPoint;

class PlayState extends FlxState {
  var hud: HUD;

  override public function create(): Void {
    super.create();

    FlxG.mouse.useSystemCursor = true;

    var level = new Level('lvTonix1', this); // TODO TODO TODO TODO TODO mainmenu
    add(level);

    hud = new HUD();
    add(hud);

    FlxG.camera.focusOn(new FlxPoint(level.width / 2, level.height / 2));
    FlxG.camera.bgColor = 0xFFdb1b3b;

    level.go();
  }

  override public function update(elapsed: Float): Void {
    super.update(elapsed);
  }
}
