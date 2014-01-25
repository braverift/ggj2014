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
    
    private const MOVE_SPEED_X:Number = 40;
    private const MOVE_SPEED_Y:Number = 20;
    private const ATTACK_TIME:Number = 0.5;
    
    private var _attackGroup:FlxGroup;
    
    private var _attackCooldown:Number;
    
    public function Player(X:Number, Y:Number, attackGroup:FlxGroup) 
    {
      super(X, Y);
      
      _attackGroup = attackGroup;
      _attackCooldown = 0;
      
      loadGraphic(heroGraphic, true, true, 32, 48);
      addAnimation("idle", [0, 1], 120, true);
    }
    
    override public function update():void
    {
      super.update();
      
      // Player movement
      if (FlxG.keys.LEFT)
      {
        x -= MOVE_SPEED_X * FlxG.elapsed;
        facing = LEFT;
      }
      if (FlxG.keys.RIGHT)
      {
        x += MOVE_SPEED_X * FlxG.elapsed;
        facing = RIGHT;
      }
      if (FlxG.keys.UP)
      {
        y -= MOVE_SPEED_Y * FlxG.elapsed;
      }
      if (FlxG.keys.DOWN)
      {
        y += MOVE_SPEED_Y * FlxG.elapsed;
      }
      
      // Attacking
      if (_attackCooldown > 0)
      {
        _attackCooldown -= FlxG.elapsed;
      }
      if (FlxG.keys.justPressed("X") && _attackCooldown <= 0)
      {
        var punchSprite:AtkPunch;
        _attackCooldown = ATTACK_TIME;
        
        if (facing == LEFT)
        {
          punchSprite = new AtkPunch(x - 8, y + 16, LEFT);
        }
        else
        {
          punchSprite = new AtkPunch(x + 24, y + 16, RIGHT);
        }
        
        _attackGroup.add(punchSprite);
      }
      
      play("idle");
    }
  }

}