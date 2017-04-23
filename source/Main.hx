package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;

class Main extends Sprite {
  public function new() {
    super();
    addChild(new FlxGame(0, 0, PlayState, 1, 60, 60, true));

    // volume keys
    FlxG.sound.muteKeys = ['m'];
    FlxG.sound.volumeUpKeys = null;
    FlxG.sound.volumeDownKeys = null;

    // play music idk
    FlxG.sound.playMusic(AssetPaths.relix__ogg, 1, true);
  }
}
