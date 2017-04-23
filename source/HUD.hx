package;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.FlxSprite;

class HUD extends FlxSpriteGroup {
  var text: FlxText;

  public function new() {
    super();

    text = new FlxText(8, 8, 'press m to mute the cool and good music', 16);
    add(text);
  }
}
