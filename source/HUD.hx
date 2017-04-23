package;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.FlxSprite;

class HUD extends FlxSpriteGroup {
  var text: FlxText;
  var tick: Int = 0;

  public function new() {
    super();

    text = new FlxText(8, 8, 'elapsed: 0', 16);
    add(text);
  }

  override public function update(elapsed: Float) {
    super.update(elapsed);
    tick++;

    text.text = 'elapsed: $tick';
  }
}
