package;

import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;

class Main extends Sprite {
  public function new() {
    super();
    addChild(new FlxGame(0, 0, PlayState, 1, 60, 60, true));
  
    #if js
    // this makes the html5 build look better <3
    untyped {
      document.oncontextmenu = document.body.oncontextmenu = function() {
        return false;
      }

      var css = '#openfl-content {'
              + '  position: absolute; top: 50%; left: 50%;'
              + '  transform: translate(-50%, -50%) !important; }'
              + 'body { background-color: #db1b3b; }';
      var head = document.head;
      var style = document.createElement('style');

      if (style.styleSheet) {
        style.styleSheet.cssText = css;
      } else {
        style.appendChild(document.createTextNode(css));
      }

      head.appendChild(style);
    }
    #end
  }
}
