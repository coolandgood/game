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

  public function new(x, y) {
    super(x, y);
    loadGraphic(AssetPaths.cube_health_1__png); // TODO
    setSize(16, 16);

    maxVelocity.set(TERMINAL_XV, TERMINAL_YV);
  }

  override public function update(tick: Float): Void {
    move();

    super.update(tick);
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
}
