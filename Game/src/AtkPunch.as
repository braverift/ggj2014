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
    
    protected var LIFETIME:Number = 0.2;
    protected var SPEED:Number = 50;
    
    protected var _lifetime:Number;
    
    public function AtkPunch(X:Number, Y:Number, FACING:uint) 
    {
      super(X, Y);
      
      visible = false;
      facing = FACING;
      _lifetime = LIFETIME;
      
      loadGraphic(punchGraphic, false, true);
      width = 16;
      height = 16;
      offset.x = 0;
      offset.y = 40;

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
    
    public function isBullet(): Boolean
    {
      return false;
    }
  }

}