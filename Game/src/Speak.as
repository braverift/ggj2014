package  
{
  import org.flixel.*;
	/**
   * ...
   * @author ...
   */
  public class Speak extends FlxSprite
  {
    [Embed(source = "../data/art/atk_punch.png")] private var punchGraphic:Class;
    
    private const LIFETIME:Number = 0.2;
    private const SPEED:Number = 0;
    
    private var _lifetime:Number;
    
    public function Speak(X:Number, Y:Number, FACING:uint) 
    {
      super(X, Y);
      
      facing = FACING;
      _lifetime = LIFETIME;
      
      loadGraphic(punchGraphic, false, true);
      width = 16;
      height = 16;
      offset.x = 0;
      offset.y = 40;

      visible = false;
    }
    
    override public function update():void
    {
      super.update();
      
      if (facing == LEFT)
      {
        x -= SPEED * FlxG.elapsed;
      }
      else
      {
        x += SPEED * FlxG.elapsed;
      }
      
      _lifetime -= FlxG.elapsed;
      if (_lifetime < 0)
      {
        kill();
      }
    }
  }

}