package  
{
  import org.flixel.*;
	/**
   * ...
   * @author ...
   */
  public class Enemy extends FlxSprite
  {
    [Embed(source = "../data/art/char_enemy.png")] private var enemyGraphic:Class;
    
    private const MOVE_SPEED_X:Number = 40;
    private const MOVE_SPEED_Y:Number = 20;
    private const ATTACK_TIME:Number = 0.5;
    private const RECOIL_TIME:Number = 0.2;
    private const RECOIL_SPEED:Number = 80;
    
    private var _attackGroup:FlxGroup;
    
    private var _attackCooldown:Number;
    private var _recoilTime:Number;
    private var _recoilDirection:uint;

    public function Enemy(X:Number, Y:Number, attackGroup:FlxGroup) 
    {
      super(X, Y);
      
      _attackGroup = attackGroup;
      _attackCooldown = 0;
      
      loadGraphic(enemyGraphic, true, true, 32, 48);
      addAnimation("idle", [0, 1], 120, true);
    }
    
    override public function update():void
    {
      super.update();
      super.update();
      
      if (_recoilDirection)
      {
        if (_recoilDirection == LEFT)
        {
          x -= RECOIL_SPEED * FlxG.elapsed;
        }
        else
        {
          x += RECOIL_SPEED * FlxG.elapsed;
        }
        
        _recoilTime -= FlxG.elapsed;
        if (_recoilTime < 0)
        {
          _recoilDirection = 0;
        }
      }
      
      play("idle");
    }
    
    public function punched(direction:uint): void
    {
      _recoilDirection = direction;
      _recoilTime = RECOIL_TIME;
    }
  }

}