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
    private var _playerSpeechGroup:FlxGroup;
    private var _enemies:FlxGroup;
    private var _enemyAttackGroup:FlxGroup;
    private var _downedEnemyGroup:FlxGroup;
    private var _queuedDialogue:Array;
    private var _dialogueText:FlxText;
    private var _diagTime:Number;
    private var _currentDialogueString:String;
    
    public static const TIME_PER_CHAR:Number = 0.08; // Time per character of text in seconds
    public static const TIME_AT_END:Number = 1.0; // Length of pause after each line in seconds

    public function CombatState() 
    {
      
    }
    
    override public function create(): void
    {
      FlxG.debug = true;
			FlxG.visualDebug = true;
      
      _playerAttackGroup = new FlxGroup;
      _playerSpeechGroup = new FlxGroup;
      _player = new Player(150, 150, _playerAttackGroup, _playerSpeechGroup);
      
      _enemies = new FlxGroup;
      _enemyAttackGroup = new FlxGroup;
      _downedEnemyGroup = new FlxGroup;
      
      /*
      _enemies.add(new Enemy(160, 180, _enemyAttackGroup, _downedEnemyGroup));
      _enemies.add(new Enemy(30, 190, _enemyAttackGroup, _downedEnemyGroup));
      _enemies.add(new Enemy(50, 120, _enemyAttackGroup, _downedEnemyGroup));
      */
      
      var talkingEnemy:Enemy = new Enemy(160, 180, _enemyAttackGroup, _downedEnemyGroup);
      talkingEnemy.addDialogue(new Array(new Dialogue("Hello"), new Dialogue("Hiii.........")));
      _enemies.add(talkingEnemy);
      
      _dialogueText = new FlxText(20, 180, 280);
      _diagTime = 0;
      _queuedDialogue = new Array;
      
      add(new FlxSprite(0, 0, background));
      add(_downedEnemyGroup);
      add(_player);
      add(_playerAttackGroup);
      add(_enemies);
      add(_enemyAttackGroup);
      add(_dialogueText);
    }
    
    override public function update():void
    {
      super.update();
      
      _player.update();
      _playerAttackGroup.update();
      
      FlxG.overlap(_enemies, _playerAttackGroup, punchEnemy);
      FlxG.overlap(_player, _enemyAttackGroup, punchPlayer);
      FlxG.overlap(_enemies, _playerSpeechGroup, talkToEnemy);
      
      handleDialogue();
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
    
    public function punchPlayer(player:Player, punch:AtkPunch): void
    {
      player.punched(punch.facing);
      punch.kill();
    }
    
        
    public function talkToEnemy(enemy:Enemy, speak:Speak): void
    {
      speak.kill();

      var response:Array = enemy.getDialogue();
      for each (var line:Dialogue in response)
      {
        _queuedDialogue.push(line);
      }
      
      freezeAll(true);
    } 
    
    public function freezeAll(frozen:Boolean): void
    {
      for each (var en:Enemy in _enemies.members)
      {
        en.freeze(frozen);
      }
      _player.freeze(frozen);
    }
    
    private function handleDialogue(): void
    {
      if (_queuedDialogue.length > 0)
      {
        _diagTime += FlxG.elapsed;
        var charsToShow:Number = _diagTime / TIME_PER_CHAR;
        var curDiag:Dialogue = _queuedDialogue[0]
        _dialogueText.text = curDiag.text.substr(0, charsToShow);
        _dialogueText.color = curDiag.color;
        _dialogueText.shadow = Utility.darkerize(curDiag.color)
        
        // Auto advance text
        if (_diagTime > curDiag.text.length*TIME_PER_CHAR + TIME_AT_END)
        {
          _queuedDialogue.splice(0, 1);
          _diagTime = 0;
          _dialogueText.text = "";
          if (_queuedDialogue.length == 0)
          {
            freezeAll(false);
          }
        }
      }
    }
  }

}