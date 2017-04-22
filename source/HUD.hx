package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.FlxSprite;

class HUD extends FlxTypedGroup<FlxSprite> {
  var text: FlxText;

  public function new() {
    super();

    text = new FlxText(8, 8, 'idk', 16);
    add(text);
  }
}
