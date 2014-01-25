package  
{
  import org.flixel.*;
	/**
   * ...
   * @author ...
   */
  public class AtkPunch extends FlxSprite
  {
    [Embed(source = "../data/art/atk_punch.png")] private var punchGraphic:Class;
    
    private const LIFETIME:Number = 0.2;
    private const SPEED:Number = 50;
    
    private var _lifetime:Number;
    
    public function AtkPunch(X:Number, Y:Number, FACING:uint) 
    {
      super(X, Y);
      
      facing = FACING;
      _lifetime = LIFETIME;
      
      loadGraphic(punchGraphic, false, true);
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