package  
{
  import org.flixel.*;
	/**
   * ...
   * @author ...
   */
  public class PlayerAtBar extends FlxSprite
  {
    [Embed(source = "../data/art/char_hero_drink.png")] private var heroGraphic:Class;

    public const FRAME_WIDTH:int = 32;
    public const FRAME_HEIGHT:int = 54;
    
    public function PlayerAtBar(X:Number, Y:Number) 
    {
      super(X, Y);
      
      loadGraphic(heroGraphic, true, true, FRAME_WIDTH, FRAME_HEIGHT);
      addAnimation("idle", [0]);
      addAnimation("drinking", [1]);
    }
    
    override public function update():void
    {
      super.update();
    }
  }

}
