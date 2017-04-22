package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.FlxObject;
import flixel.util.FlxColor;

class PlayState extends FlxState {
  var player: FlxSprite;

  override public function create(): Void {
    super.create();

    #if FLX_MOUSE
      FlxG.mouse.visible = false;
    #end

    var text = new flixel.text.FlxText(0, 0, 0, "Hello World", 64);
    text.screenCenter();
    add(text);

    player = new FlxSprite(64, 0);
    player.makeGraphic(16, 16, FlxColor.RED);
    player.acceleration.y = 420;
    add(player);
  }

  override public function update(elapsed: Float): Void {
    super.update(elapsed);
  }
}
