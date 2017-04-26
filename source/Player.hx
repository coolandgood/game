package;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.util.FlxColor;

import flixel.effects.particles.FlxEmitter.FlxEmitterMode;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

class Player extends FlxSprite {
  private static inline var TERMINAL_XV = 72 * 2;
  private static inline var TERMINAL_YV = 256 * 2;

  private static inline var JUMP_FORCE = 300 * 2;
  private static inline var GRAVITY = 10 * 2;

  private static inline var SPEED = 20 * 2;
  private static inline var DRAG_X = 0.8;
  private static inline var DRAG_Y = 0.95;

  private var ox: Float;
  private var oy: Float;

  public var lvWidth: Int = 640;
  public var lvHeight: Int = 480;
  public var level: Level; // reference to parent Level

  public var controllable: Bool = true;

  public function new(x: Float, y: Float, level: Level) {
    super(x, y);
    loadGraphic(AssetPaths.cube_health_1__png);
    setSize(16, 16);

    this.level = level;
    maxVelocity.set(TERMINAL_XV, TERMINAL_YV);
  }

  override public function update(tick: Float): Void {
    if (controllable) move();

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

  public function explode() {
    // explode into a bunch of particles
    var emitter = new FlxEmitter(x + width/2, y + height/2, 75);
    level.add(emitter);
    kill(); // remove self

    FlxG.sound.play("boom");

    emitter.launchMode = FlxEmitterMode.SQUARE;
    emitter.acceleration.set(-8, GRAVITY * -1, -16, GRAVITY * -3);

    emitter.makeParticles(2, 2, 0xFF5674B9, 75).start(true, 0, 0);
    FlxG.camera.shake(0.05, 0.2);
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
      velocity.x *= DRAG_X;
    }

    if (keys.justPressed.UP && isTouching(FlxObject.FLOOR)) {
      // jump!
      velocity.y = -JUMP_FORCE;
      FlxG.sound.play("jump");
    } else if (velocity.y < 0 && keys.justReleased.UP) {
      velocity.y *= 0.5; // jump height is based on how long you hold the up key
    }

    velocity.y += GRAVITY;
    velocity.y *= DRAG_Y;
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
