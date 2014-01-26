package  
{
	/**
   * ...
   * @author ...
   */
  public class AtkBullet extends AtkPunch
  {
    [Embed(source = "../data/art/atk_bullet.png")] private var bulletGraphic:Class;

    public function AtkBullet(X:Number, Y:Number, FACING:uint) 
    {
      super(X, Y, FACING);
      
      visible = true;
      loadGraphic(bulletGraphic, false, true);
      width = 16;
      height = 16;
      offset.x = 0;
      offset.y = 40;
      
      SPEED = 200;
      _lifetime  = 10;
    }
    
    public override function  isBullet(): Boolean
    {
      return true;
    }
  }

}