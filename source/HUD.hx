package;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.FlxSprite;

class HUD extends FlxSpriteGroup {
  var text: FlxText;
  var tick: Int = 0;

  public function new() {
    super();

    scrollFactor.set(0, 0); // prevents group from scrolling w/ camera

    text = new FlxText(8, 8, 'elapsed: 0', 16); // TODO?
    //add(text);
  }

  override public function update(elapsed: Float) {
    super.update(elapsed);
    tick++;

    text.text = 'elapsed: $tick';
  }
}
