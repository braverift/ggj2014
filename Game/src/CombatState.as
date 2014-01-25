package  
{
  import org.flixel.*;
	/**
   * ...
   * @author ...
   */
  public class CombatState extends FlxState
  {
    [Embed(source = "../data/art/bg_fight.png" )] private var background:Class;

    private var _player:Player;
    private var _playerAttackGroup:FlxGroup;
    private var _enemies:FlxGroup;
    private var _enemyAttackGroup:FlxGroup;
    private var _downedEnemyGroup:FlxGroup;
    
    public function CombatState() 
    {
      
    }
    
    override public function create(): void
    {
      FlxG.debug = true;
			FlxG.visualDebug = true;
      
      _playerAttackGroup = new FlxGroup;
      _player = new Player(150, 150, _playerAttackGroup);
      
      _enemies = new FlxGroup;
      _enemyAttackGroup = new FlxGroup;
      _downedEnemyGroup = new FlxGroup;
      
      _enemies.add(new Enemy(160, 180, _enemyAttackGroup, _downedEnemyGroup));
      _enemies.add(new Enemy(30, 190, _enemyAttackGroup, _downedEnemyGroup));
      _enemies.add(new Enemy(50, 120, _enemyAttackGroup, _downedEnemyGroup));
   
      add(new FlxSprite(0, 0, background));
      add(_downedEnemyGroup);
      add(_player);
      add(_playerAttackGroup);
      add(_enemies);
      add(_enemyAttackGroup);
    }
    
    override public function update():void
    {
      super.update();
      
      _player.update();
      _playerAttackGroup.update();
      
      FlxG.overlap(_enemies, _playerAttackGroup, punchEnemy);
    }
    
    public function punchEnemy(enemy:Enemy, punch:AtkPunch): void
    {
      enemy.punched(punch.facing);
      punch.kill();
      
      for each (var en:Enemy in _enemies.members)
      {
        en.aggro(_player);
      }
    }
    
    
  }

}