package;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.util.FlxColor;

class Player extends FlxSprite {
  private static inline var TERMINAL_XV = 72 * 2;
  private static inline var TERMINAL_YV = 256 * 2;
  private static inline var TERMINAL_FALL = 72 * 2;

  private static inline var JUMP_FORCE = 164 * 2;
  private static inline var GRAVITY = 6 * 2;

  private static inline var SPEED = 24 * 2;
  private static inline var DRAG = 0.6;

  private var ox: Float;
  private var oy: Float;

  public var lvWidth: Int = 640;
  public var lvHeight: Int = 480;

  public function new(x, y) {
    super(x, y);
    loadGraphic(AssetPaths.cube_health_1__png);
    setSize(16, 16);

    maxVelocity.set(TERMINAL_XV, TERMINAL_YV);
  }

  override public function update(tick: Float): Void {
    move();

    if (FlxG.keys.justPressed.SPACE)
      FlxG.camera.shake(0.03, 0.3);

    super.update(tick);
  }

  override public function draw() {
    ox = x;
    oy = y;

    // wrapping
    drawWrapped();

    x = ox;
    y = oy;

    // shadow
    drawShadow();

    // actual
    super.draw();
  }

  private function move() {
    var keys = FlxG.keys;

    if (keys.pressed.LEFT) {
      // move left
      velocity.x -= SPEED;
    } else if (keys.pressed.RIGHT) {
      // move right
      velocity.x += SPEED;
    } else {
      // slow down
      velocity.x *= DRAG;
    }

    if (keys.justPressed.UP && isTouching(FlxObject.FLOOR)) {
      // jump!
      velocity.y = -JUMP_FORCE;
    } else if (velocity.y < 0 && keys.justReleased.UP) {
      velocity.y *= 0.5; // jump height is based on how long you hold the up key
    }

    if (velocity.y < TERMINAL_FALL)
      velocity.y += GRAVITY;
  }

  private function drawWrapped() {
    if (y > lvHeight - 16) {
      y = y - lvHeight;
      drawShadow();
      super.draw();
    }

    if (y < 0) {
      y = y + lvHeight;
      drawShadow();
      super.draw();
    }

    if (x > lvWidth - 16) {
      x = x - lvWidth;
      drawShadow();
      super.draw();
    }

    if (x < 0) {
      x = x + lvWidth;
      drawShadow();
      super.draw();
    }

    // wrap actual sprite

    if (oy > lvHeight) {
      trace('wrap: bottom -> top');
      oy = 0;
    }

    if (oy < -16) {
      trace('wrap: top -> bottom');
      oy = lvHeight - 16;
    }

    if (ox > lvWidth) {
      trace('wrap: right -> left');
      ox = 0;
    }

    if (ox < -16) {
      trace('wrap: left -> right');
      ox = lvWidth - 16;
    }
  }

  private function drawShadow() {
    x += 4;
    y += 4;

    loadGraphic(AssetPaths.cube_health_1_shadow__png);
    super.draw();

    x -= 4;
    y -= 4;

    loadGraphic(AssetPaths.cube_health_1__png);
  }
}
