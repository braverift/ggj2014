package  
{
	/**
   * ...
   * @author ...
   */
  import org.flixel.FlxGroup;

  public class EnemyWeak extends Enemy
  {
    [Embed(source = "../data/art/char_enemy.png")] private var weakEnemyGraphic:Class;

    public function EnemyWeak(X:Number, Y:Number, attackGroup:FlxGroup, downedGroup:FlxGroup) 
    {
      super(X, Y, attackGroup, downedGroup);
      
      MOVE_SPEED_X = 60;
      MOVE_SPEED_Y = 20;
      ATTACK_TIME = 1.0;
      _HP = 2;
      
      loadGraphic(weakEnemyGraphic, true, true, FRAME_WIDTH, FRAME_HEIGHT);
      width = 28;
      height = 16;
      offset.x = 18;
      offset.y = FRAME_HEIGHT - height;
    }
    
            
    public override function makeCorpse(X:Number, Y:Number, color:uint, isBullet:Boolean, facing:uint):EnemyKOed
    {
      return new EnemyKOed(X, Y, color, isBullet, facing, EnemyInfo.WEAK);
    }
  }

}