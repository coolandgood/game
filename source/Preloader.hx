package;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flixel.system.FlxBasePreloader;
import flash.events.Event;

class Preloader extends FlxBasePreloader {
  private var progressBar: Bitmap;
  static inline var BAR_HEIGHT: Int = 32;
  static inline var BAR_WIDTH: Int = 632;

  public function new(minDisplayTime: Float = 0, ?allowedURLs: Array<String>) {
    super(minDisplayTime, allowedURLs);

    #if js
    // this makes the html5 build look better <3
    untyped {
      document.oncontextmenu = document.body.oncontextmenu = function() {
        return false;
      }

      var css = '#openfl-content {'
              + '  position: absolute; top: 50%; left: 50%;'
              + '  transform: translate(-50%, -50%) scale(1); }'
              + 'canvas { image-rendering: optimizespeed; }'
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

  private function onAddedToStage(e: Event) {
    addEventListener(Event.ENTER_FRAME, onEnterFrame);
    create();
  }

  override private function create() {
    var c = 0xffffffff;

    var border1: Bitmap = new Bitmap(new BitmapData(BAR_WIDTH - 8, 4, false, c));
    var border2: Bitmap = new Bitmap(new BitmapData(4, BAR_HEIGHT - 8, false, c));
    var border3: Bitmap = new Bitmap(new BitmapData(4, BAR_HEIGHT - 8, false, c));
    var border4: Bitmap = new Bitmap(new BitmapData(BAR_WIDTH - 8, 4, false, c));

    progressBar = new Bitmap(new BitmapData(1, BAR_HEIGHT - 8, false, c));
    progressBar.x = border4.x = border1.x = (640 / 2) - (border1.width / 2);

    border1.y = (480 / 2) - BAR_HEIGHT / 2;
    border2.x = border1.x - 4;
    progressBar.y = border3.y = border2.y = border1.y + 4;
    border3.x = border1.x + border1.width;
    border4.y = border2.y + border2.height;

    addChild(border1);
    addChild(border2);
    addChild(border3);
    addChild(border4);
    addChild(progressBar);
  }

  override function update(percent: Float) {
    progressBar.width = (percent * (BAR_WIDTH - 8) / 4) * 4;
  }
}
