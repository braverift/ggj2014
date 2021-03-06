package  
{
  import org.flixel.*;
  public class Player extends FlxSprite
  {
    [Embed(source = "../data/art/char_hero.png")] private var heroGraphic:Class;

    public const FRAME_WIDTH:int = 64;
    public const FRAME_HEIGHT:int = 80;
    
    private const MOVE_SPEED_X:Number = 120;
    private const MOVE_SPEED_Y:Number = 70;
    private const ATTACK_TIME:Number = 0.2;
    private const RECOIL_TIME:Number = 0.2;
    private const RECOIL_SPEED:Number = 200;
    private const MAX_HP:Number = 10;

    private var _attackGroup:FlxGroup;
    private var _speechGroup:FlxGroup;
    
    private var _attackCooldown:Number;
    private var _recoilTime:Number;
    private var _recoilDirection:uint;
    private var _HP:Number;
    private var _frozen:Boolean;
    private var _aggro:Boolean;
    private var _shootCallback:Function;
    
    public function Player(X:Number, Y:Number, attackGroup:FlxGroup, speechGroup:FlxGroup, shootCallback:Function) 
    {
      super(X, Y);
      
      _attackGroup = attackGroup;
      _speechGroup = speechGroup;
      _attackCooldown = 0;
      _frozen = false;
      _aggro = false;
      _HP = MAX_HP;
      _shootCallback = shootCallback;
      
      loadGraphic(heroGraphic, true, true, FRAME_WIDTH, FRAME_HEIGHT);
      addAnimation("idle", [0, 1, 2, 1, 0], 10, true);
      addAnimation("idle_aggro", [7, 8, 9, 8, 7], 10, true);
      addAnimation("walk", [6, 5], 7, true);
      addAnimation("punch", [3, 4, 3, 1], 20, false);
      addAnimation("idle_gun", [10, 11, 12, 11, 10], 10, true);
      addAnimation("shoot", [13, 14, 13], 20, false);
      addAnimation("walk_gun", [15, 16], 7, true);

      width = 28;
      height = 16;
      offset.x = 18;
      offset.y = FRAME_HEIGHT - height;
    }
    
    override public function update():void
    {
      super.update();
      
      var moved:Boolean = false;

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
        if (_attackCooldown <= 0)
        {
          if (FlxG.keys.LEFT)
          {
            x -= MOVE_SPEED_X * FlxG.elapsed;
            facing = LEFT;
            moved = true;
          }
          if (FlxG.keys.RIGHT)
          {
            x += MOVE_SPEED_X * FlxG.elapsed;
            facing = RIGHT;
            moved = true;
          }
          if (FlxG.keys.UP)
          {
            y -= MOVE_SPEED_Y * FlxG.elapsed;
            moved = true;
          }
          if (FlxG.keys.DOWN)
          {
            y += MOVE_SPEED_Y * FlxG.elapsed;
            moved = true;
          }
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
              if (canShoot())
              {
                punchSprite = new AtkBullet(x - 8, y, LEFT);
              }
              else
              {
                punchSprite = new AtkPunch(x - 8, y, LEFT);
              }
            }
            else
            {
              if (canShoot())
              {
                punchSprite = new AtkBullet(x + 24, y, RIGHT);
              }
              else
              {
                punchSprite = new AtkPunch(x + 24, y, RIGHT);
              }
            }
            
            if (canShoot())
            {
              FlxG.shake(0.05, 0.1, null, true, 0);
              FlxG.flash(0xffffffff, 0.1, null, true);
              --Registry.bullets;
              _shootCallback();
            }
            
            _attackGroup.add(punchSprite);
          }
          else if (FlxG.keys.justPressed("Z"))
          {
            var speechSprite:Speak;            
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
      
      if (_attackCooldown > 0)
      {
        play(Registry.hasGun ? "shoot" : "punch");
      }
      else if (moved)
      {
        play(Registry.hasGun ? "walk_gun" : "walk");
      }
      else 
      {
        if (Registry.hasGun)
        {
          play("idle_gun");
        }
        else if (_aggro)
        {
          play("idle_aggro");
        }
        else
        {
          play("idle");
        }
      }
    }
        
    public function punched(direction:uint): void
    {
      _recoilDirection = direction;
      _recoilTime = RECOIL_TIME;
      
      if (--_HP <= 0)
      {
        Registry.endScene(Registry.LOSE);
      }
    }
    
    public function freeze(frozen:Boolean): void
    {
      _frozen = frozen;
    }
        
    public function aggro(): void
    {
      _aggro = true;
    }
    
    public function canShoot():Boolean
    {
      return Registry.hasGun && Registry.bullets > 0;
    }
  }

}
