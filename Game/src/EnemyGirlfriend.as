package  
{
	/**
   * ...
   * @author ...
   */
  import org.flixel.FlxGroup;

  public class EnemyGirlfriend extends Enemy
  {
    [Embed(source = "../data/art/char_girlfriend.png")] private var girlfriendGraphic:Class;

    public function EnemyGirlfriend(X:Number, Y:Number, attackGroup:FlxGroup, downedGroup:FlxGroup) 
    {
      super(X, Y, attackGroup, downedGroup);
      
      MOVE_SPEED_X = 60;
      MOVE_SPEED_Y = 20;
      ATTACK_TIME = 0.5;
      _HP = 8;
      
       loadGraphic(girlfriendGraphic, true, true, FRAME_WIDTH, FRAME_HEIGHT);
      width = 28;
      height = 16;
      offset.x = 18;
      offset.y = FRAME_HEIGHT - height;
      color = 0xffffffff;

    }
    
            
    public override function makeCorpse(X:Number, Y:Number, color:uint, isBullet:Boolean, facing:uint):EnemyKOed
    {
      return new EnemyKOed(X, Y, color, isBullet, facing, EnemyInfo.GIRLFRIEND);
    }
  }

}