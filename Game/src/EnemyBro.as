package  
{
	/**
   * ...
   * @author ...
   */
  import org.flixel.FlxGroup;

  public class EnemyBro extends Enemy
  {
    [Embed(source = "../data/art/char_brother.png")] private var broGraphic:Class;

    public function EnemyBro(X:Number, Y:Number, attackGroup:FlxGroup, downedGroup:FlxGroup) 
    {
      super(X, Y, attackGroup, downedGroup);
      
      MOVE_SPEED_X = 80;
      MOVE_SPEED_Y = 30;
      ATTACK_TIME = 1.0;
      _HP = 15;
      
       loadGraphic(broGraphic, true, true, FRAME_WIDTH, FRAME_HEIGHT);
      width = 28;
      height = 16;
      offset.x = 18;
      offset.y = FRAME_HEIGHT - height;
      color = 0xffffffff;
    }
  }

}