package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.FlxObject;

class PlayState extends FlxState {
  var world: World;

  override public function create(): Void {
    super.create();

    /*
    player = new FlxSprite(64, 0);
    player.makeGraphic(16, 16, FlxColor.RED);
    player.acceleration.y = 420;
    add(player);
    */

    FlxG.mouse.useSystemCursor = true;

    world = new World();
    add(world);
  }

  override public function update(elapsed: Float): Void {
    super.update(elapsed);
  }
}
