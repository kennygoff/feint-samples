package utils;

import components.PositionComponent;
import components.HitboxComponent;

typedef AABB = {
  position:PositionComponent,
  hitbox:HitboxComponent
};

class Physics {
  /**
   * Test overlap of two hitbox components, returns true if overlapping
   * @param a First hitbox to check against
   * @param b Second hitbox to check against
   * @return Bool
   */
  public static function overlaps(a:AABB, b:AABB):Bool {
    return !
      ((a.position.x + a.hitbox.x + a.hitbox.width <= b.position.x + b.hitbox.x) ||
        (a.position.x + a.hitbox.x >= b.position.x + b.hitbox.x + b.hitbox.width) ||
        (a.position.y + a.hitbox.y + a.hitbox.height <= b.position.y + b.hitbox.y) ||
        (a.position.y + a.hitbox.y >= b.position.y + b.hitbox.y + b.hitbox.width)
      );
  }
}
