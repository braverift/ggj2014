package  
{
	/**
   * ...
   * @author ...
   */
  import org.flixel.FlxGroup;

  public class EnemyWeak extends Enemy
  {
    public function EnemyWeak(X:Number, Y:Number, attackGroup:FlxGroup, downedGroup:FlxGroup) 
    {
      super(X, Y, attackGroup, downedGroup);
      
      MOVE_SPEED_X = 60;
      MOVE_SPEED_Y = 20;
      ATTACK_TIME = 1.0;
      _HP = 2;
    }
  }

}