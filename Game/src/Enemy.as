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
    private const MAX_HP:Number = 5;
    private const FRIENDLY:uint = 0;
    private const ANGRY:uint = 1;
    
    private var _attackGroup:FlxGroup;
    private var _downedGroup:FlxGroup;
    private var _dialogueGroup:FlxGroup;
    
    private var _attackCooldown:Number;
    private var _recoilTime:Number;
    private var _recoilDirection:uint;
    private var _state:uint;
    private var _destination:FlxPoint;
    private var _target:FlxSprite;
    private var _dialogue:Array;
    private var _HP:Number;
    private var _frozen:Boolean;

    public function Enemy(X:Number, Y:Number, attackGroup:FlxGroup, downedGroup:FlxGroup, dialogueGroup:FlxGroup) 
    {
      super(X, Y);
      
      _attackGroup = attackGroup;
      _downedGroup = downedGroup;
      _dialogueGroup = dialogueGroup;
      _attackCooldown = 0;
      _HP = MAX_HP;
      _state = FRIENDLY;
      _dialogue = new Array;
      _frozen = false;
      
      loadGraphic(enemyGraphic, true, true, 32, 48);
      addAnimation("idle", [0, 1], 120, true);      
      width = 28;
      height = 16;
      offset.x = 2;
      offset.y = 32;
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
        
        if (_state == ANGRY)
        {  
          // Chase after the target
          var moved:Boolean = false;
          if (!overlaps(_target))
          {
            if (x < _target.x - 8)
            {
              x += MOVE_SPEED_X * FlxG.elapsed;
              facing = RIGHT;
              moved = true;
            }
            else if (x > _target.x + 24)
            {
              x -= MOVE_SPEED_X * FlxG.elapsed;
              facing = LEFT;
              moved = true;
            }
            if (y < _target.y)
            {
              y += MOVE_SPEED_Y * FlxG.elapsed;
              moved = true;
            }
            else if (y > _target.y + 4)
            {
              y -= MOVE_SPEED_Y * FlxG.elapsed;
              moved = true;
            }
          }
          
          // Punch the target if in range
          if (_attackCooldown > 0)
          {
            _attackCooldown -= FlxG.elapsed;
          }
          if (!moved && _attackCooldown <= 0)
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
        }
      }
      
      play("idle");
    }
    
    public function punched(direction:uint): void
    {
      _recoilDirection = direction;
      _recoilTime = RECOIL_TIME;
      
      --_HP;
      if (_HP < 0)
      {
        _downedGroup.add(new EnemyKOed(x - offset.x, y - offset.y));
        kill();
      }
    }
    
    public function aggro(target:FlxSprite): void
    {
      _state = ANGRY;
      _target = target;
    }
    
    public function addDialogue(dialogue:Array): void
    {
      _dialogue.push(dialogue);
    }    
    
    public function getDialogue(): Array
    {
      var response:Array;
      if (_dialogue.length > 0)
      {
        response = _dialogue[0];
        _dialogue.splice(0, 1);
      }
      else
      {
        response = new Array;
        response.push(new Dialogue(".....", Registry.SP_PLAYER));
        response.push(new Dialogue(".............", Registry.SP_OTHER));
      }
      return response;
    }
    
    public function freeze(frozen:Boolean): void
    {
      _frozen = frozen;
    }
  }
}