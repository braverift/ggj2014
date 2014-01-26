package  
{
  import org.flixel.*;
  public class PlayerStill extends FlxSprite
  {
    [Embed(source = "../data/art/char_hero.png")] private var heroGraphic:Class;

    public const FRAME_WIDTH:int = 64;
    public const FRAME_HEIGHT:int = 80;
    
    public function PlayerStill(X:Number, Y:Number) 
    {
      super(X, Y);
      
      loadGraphic(heroGraphic, true, true, FRAME_WIDTH, FRAME_HEIGHT);
      addAnimation("idle", [0, 1, 2, 1, 0], 10, true);
      addAnimation("idle_aggro", [7, 8, 9, 8, 7], 10, true);
      addAnimation("walk", [6, 5], 7, true);
      addAnimation("punch", [3, 4, 3, 1], 20, false);
      addAnimation("idle_gun", [10, 11, 12, 11, 10], 10, true);
      addAnimation("shoot", [13, 14, 13], 20, false);
      addAnimation("walk_gun", [15, 16], 7, true);
    }
    
    override public function update():void
    {
      super.update();
    }
  }
}
