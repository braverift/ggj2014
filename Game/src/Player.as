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

    public const FRAME_WIDTH:int = 64;
    public const FRAME_HEIGHT:int = 80;
    
    private const MOVE_SPEED_X:Number = 40;
    private const MOVE_SPEED_Y:Number = 20;
    private const ATTACK_TIME:Number = 0.5;
    private const RECOIL_TIME:Number = 0.2;
    private const RECOIL_SPEED:Number = 80;

    private var _attackGroup:FlxGroup;
    private var _speechGroup:FlxGroup;
    
    private var _attackCooldown:Number;
    private var _recoilTime:Number;
    private var _recoilDirection:uint;
    private var _frozen:Boolean;
    
    public function Player(X:Number, Y:Number, attackGroup:FlxGroup, speechGroup:FlxGroup) 
    {
      super(X, Y);
      
      _attackGroup = attackGroup;
      _speechGroup = speechGroup;
      _attackCooldown = 0;
      _frozen = false;

      loadGraphic(heroGraphic, true, true, FRAME_WIDTH, FRAME_HEIGHT);
      addAnimation("idle", [0, 1, 2, 1, 0], 5, true);
      addAnimation("punch", [1, 3, 4, 3, 1], 60, false);
      width = 28;
      height = 16;
      offset.x = 18;
      offset.y = FRAME_HEIGHT - height;
    }
    
    override public function update():void
    {
      super.update();
      
      if (!_frozen)
      {
        // Recoil from being punched
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
        if (_attackCooldown <= 0)
        {
          if (FlxG.keys.justPressed("X"))
          {
            var punchSprite:AtkPunch;
            _attackCooldown = ATTACK_TIME;
            
            if (facing == LEFT)
            {
              punchSprite = new AtkPunch(x - 8, y, LEFT);
            }
            else
            {
              punchSprite = new AtkPunch(x + 24, y, RIGHT);
            }
            
            _attackGroup.add(punchSprite);
          }
          else if (FlxG.keys.justPressed("Z"))
          {
            var speechSprite:Speak;
            _attackCooldown = ATTACK_TIME;
            
            if (facing == LEFT)
            {
              speechSprite = new Speak(x - 8, y, LEFT);
            }
            else
            {
              speechSprite = new Speak(x + 24, y, RIGHT);
            }
            
            _speechGroup.add(speechSprite);
          }
        }
      }
      
      play("idle");
    }
        
    public function punched(direction:uint): void
    {
      _recoilDirection = direction;
      _recoilTime = RECOIL_TIME;

    }
    
    public function freeze(frozen:Boolean): void
    {
      _frozen = frozen;
    }
  }

}