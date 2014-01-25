package  
{
  import org.flixel.*;
	/**
   * ...
   * @author ...
   */
  public class Player extends FlxSprite
  {
    [Embed(source = "../data/art/char_hero.png")] private var heroGraphic:Class;
    
    public function Player(x:Number, y:Number) 
    {
      super(x, y);
      
      loadGraphic(heroGraphic, true, true, 32, 48);
      
      addAnimation("idle", [0, 1], 120, true);
    }
    
    override public function update():void
    {
      super.update();
      
      play("idle");
    }
  }

}