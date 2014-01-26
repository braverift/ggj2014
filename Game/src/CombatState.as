package  
{
  import org.flixel.*;
  public class CombatState extends FlxState
  {
    [Embed(source = "../data/art/bg_bar.png" )] private var bgBar:Class;
    [Embed(source = "../data/art/bg_skyscraper_noir.png" )] private var bgSkyscraperNoir:Class;
    [Embed(source = "../data/art/bg_cave_noir.png" )] private var bgCaveNoir:Class;
    [Embed(source = "../data/art/bg_train_noir.png" )] private var bgTrainNoir:Class;
    [Embed(source = "../data/art/bg_park_noir.png" )] private var bgParkNoir:Class;
    [Embed(source = "../data/art/bg_exterior_noir.png" )] private var bgOutsideBarNoir:Class;
    [Embed(source = "../data/art/bg_party_noir.png" )] private var bgPartyNoir:Class;
    [Embed(source = "../data/art/bg_warehouse_noir.png" )] private var bgWarehouseNoir:Class;
    [Embed(source = "../data/art/bg_apartment_noir.png" )] private var bgApartmentNoir:Class;
    [Embed(source = "../data/art/bg_skyscraper_whimsical.png" )] private var bgSkyscraperWhimsical:Class;
    [Embed(source = "../data/art/bg_cave_whimsical.png" )] private var bgCaveWhimsical:Class;
    [Embed(source = "../data/art/bg_train_whimsical.png" )] private var bgTrainWhimsical:Class;
    [Embed(source = "../data/art/bg_park_whimsical.png" )] private var bgParkWhimsical:Class;
    [Embed(source = "../data/art/bg_exterior_whimsical.png" )] private var bgOutsideBarWhimsical:Class;
    [Embed(source = "../data/art/bg_party_whimsical.png" )] private var bgPartyWhimsical:Class;
    [Embed(source = "../data/art/bg_warehouse_whimsical.png" )] private var bgWarehouseWhimsical:Class;
    [Embed(source = "../data/art/bg_apartment_whimsical.png" )] private var bgApartmentWhimsical:Class;
    [Embed(source = "../data/art/bg_skyscraper_intense.png" )] private var bgSkyscraperIntense:Class;
    [Embed(source = "../data/art/bg_cave_intense.png" )] private var bgCaveIntense:Class;
    [Embed(source = "../data/art/bg_train_intense.png" )] private var bgTrainIntense:Class;
    [Embed(source = "../data/art/bg_park_intense.png" )] private var bgParkIntense:Class;
    [Embed(source = "../data/art/bg_exterior_intense.png" )] private var bgOutsideBarIntense:Class;
    [Embed(source = "../data/art/bg_party_intense.png" )] private var bgPartyIntense:Class;
    [Embed(source = "../data/art/bg_warehouse_intense.png" )] private var bgWarehouseIntense:Class;
    [Embed(source = "../data/art/bg_apartment_intense.png" )] private var bgApartmentIntense:Class;

    private var _player:Player;
    private var _playerAndEnemies:FlxGroup;
    private var _playerAttackGroup:FlxGroup;
    private var _playerSpeechGroup:FlxGroup;
    private var _enemies:FlxGroup;
    private var _enemyAttackGroup:FlxGroup;
    private var _downedEnemyGroup:FlxGroup;
    private var _queuedDialogue:Array;
    private var _dialogueText:FlxText;
    private var _diagBackSprite:FlxSprite;
    private var _diagTime:Number;
    private var _currentDialogueString:String;
    private var _canEscape:Boolean;
    private var _controlsText:FlxText;

    public static const TIME_PER_CHAR:Number = 0.08; // Time per character of text in seconds
    public static const TIME_AT_END:Number = 1.0; // Length of pause after each line in seconds
    private const HORIZON:Number = 140;
    public function CombatState() 
    {
      
    }
    
    override public function create(): void
    {
      FlxG.debug = false;
      FlxG.visualDebug = false;
      
      _canEscape = true;
      
      var scene:CombatScene = Registry.getSceneInfo(Registry.combatScene, Registry.combatSceneVariant);
      
      var bg:Class;
      if (scene._background == CombatScene.BG_SKYSCRAPER)
      {
        bg = Registry.isIntense() ? bgSkyscraperIntense : (Registry.isWhimisical() ? bgSkyscraperWhimsical : bgSkyscraperNoir);
      }
      else if (scene._background == CombatScene.BG_CAVE)
      {
        bg = Registry.isIntense() ? bgCaveIntense : (Registry.isWhimisical() ? bgCaveWhimsical : bgCaveNoir);
      }
      else if (scene._background == CombatScene.BG_TRAIN)
      {
        bg = Registry.isIntense() ? bgTrainIntense : (Registry.isWhimisical() ? bgTrainWhimsical : bgTrainNoir);
      }      
      else if (scene._background == CombatScene.BG_PARK)
      {
        bg = Registry.isIntense() ? bgParkIntense : (Registry.isWhimisical() ? bgParkWhimsical : bgParkNoir);
      }
      else if (scene._background == CombatScene.BG_WAREHOUSE)
      {
        bg = Registry.isIntense() ? bgWarehouseIntense : (Registry.isWhimisical() ? bgWarehouseWhimsical : bgWarehouseNoir);
      }
      else if (scene._background == CombatScene.BG_OUTSIDE_BAR)
      {
        bg = Registry.isIntense() ? bgOutsideBarIntense : (Registry.isWhimisical() ? bgOutsideBarWhimsical : bgOutsideBarNoir);
      }      
      else if (scene._background == CombatScene.BG_PARTY)
      {
        bg = Registry.isIntense() ? bgPartyIntense : (Registry.isWhimisical() ? bgPartyWhimsical : bgPartyNoir);
      }     
      else if (scene._background == CombatScene.BG_APARTMENT)
      {
        bg = Registry.isIntense() ? bgApartmentIntense : (Registry.isWhimisical() ? bgApartmentWhimsical: bgApartmentNoir);
      }
      else
      {
        bg = bgBar;
      }
      
      add(new FlxSprite(0, 0, bg));
      

      _playerAndEnemies = new FlxGroup;
      _playerAttackGroup = new FlxGroup;
      _playerSpeechGroup = new FlxGroup;
      _player = new Player(scene._x, scene._y + 140, _playerAttackGroup, _playerSpeechGroup, onShoot);
      _playerAndEnemies.add(_player);
      
      _enemies = new FlxGroup;
      _enemyAttackGroup = new FlxGroup;
      _downedEnemyGroup = new FlxGroup;
      
      for each (var enInfo:EnemyInfo in scene._enemies)
      {
        var en:Enemy;
        if (Registry.intensity >= enInfo.minIntensity)
        {
          if (enInfo.type == EnemyInfo.WEAK)
          {
            en = new EnemyWeak(enInfo.x, enInfo.y + 140, _enemyAttackGroup, _downedEnemyGroup);
          }
          else if (enInfo.type == EnemyInfo.GIRLFRIEND)
          {
            en = new EnemyGirlfriend(enInfo.x, enInfo.y + 140, _enemyAttackGroup, _downedEnemyGroup);
          }          
          else if (enInfo.type == EnemyInfo.BRO)
          {
            en = new EnemyBro(enInfo.x, enInfo.y + 140, _enemyAttackGroup, _downedEnemyGroup);
          }          
          else if (enInfo.type == EnemyInfo.OTHER)
          {
            en = new EnemyOther(enInfo.x, enInfo.y + 140, _enemyAttackGroup, _downedEnemyGroup);
          }
          else
          {
            en = new Enemy(enInfo.x, enInfo.y + 140, _enemyAttackGroup, _downedEnemyGroup);
          }
          en.addDialogue(enInfo.dialogue);
          _enemies.add(en);
          _playerAndEnemies.add(en);
        }
      }

      _dialogueText = new FlxText(20, 16, 280);
      _diagBackSprite = new FlxSprite(18, 16);
      _diagBackSprite.makeGraphic(FlxG.width - 18 * 2, 38, 0x55000000);
      _diagBackSprite.visible = false;
      _diagTime = 0;
      _queuedDialogue = new Array;
      
      _controlsText = new FlxText(20, FlxG.height - 20, 280, controlsString());
      
      add(_downedEnemyGroup);
      add(_playerAndEnemies);
      add(_enemyAttackGroup);
      add(_playerAttackGroup);
      add(_diagBackSprite);
      add(_dialogueText);
      add(_controlsText);
    }
    
    override public function update():void
    {
      super.update();
      
      _playerAndEnemies.members.sort(heightSort);
      
      FlxG.overlap(_enemies, _playerAttackGroup, punchEnemy);
      FlxG.overlap(_player, _enemyAttackGroup, punchPlayer);
      FlxG.overlap(_enemies, _playerSpeechGroup, talkToEnemy);
      
      handleDialogue();
      boundsCheck();
    }
    
    public function punchEnemy(enemy:Enemy, punch:AtkPunch): void
    {
      enemy.punched(punch.facing, punch.isBullet());
      punch.kill();
      aggro();
    }
    
    public function aggro(): void
    {
      _canEscape = false;
      for each (var en:Enemy in _enemies.members)
      {
        en.aggro(_player);
      }
      _player.aggro();
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
      
      if (_queuedDialogue.length > 0)
      {
        freezeAll(true);
      }
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
        _diagBackSprite.visible = true;
        _diagTime += FlxG.elapsed;
        var charsToShow:Number = _diagTime / TIME_PER_CHAR;
        var curDiag:Dialogue = _queuedDialogue[0]
        _dialogueText.text = curDiag.text.substr(0, charsToShow);
        _dialogueText.color = curDiag.color;
        _dialogueText.shadow = Utility.darkerize(curDiag.color)
        
        // Auto advance text
        if (_diagTime > curDiag.text.length*TIME_PER_CHAR + TIME_AT_END)
        {
          if (curDiag.isPlotPoint)
          {
            Registry.endScene(Registry.TALK);
          }
          _queuedDialogue.splice(0, 1);
          _diagTime = 0;
          _dialogueText.text = "";
          _diagBackSprite.visible = false;
          if (_queuedDialogue.length == 0)
          {
            freezeAll(false);
          }
        }
      }
    }
    
    private function boundsCheck(): void
    {
      if (_player.y < HORIZON)
      {
        _player.y = HORIZON;
      }
      if (_canEscape)
      {
        if (_player.y > FlxG.height + 42 || _player.x < -32 || _player.x > FlxG.width)
        {
          Registry.endScene(Registry.WALK);
        }
      }
      else
      {
        if (_player.y > FlxG.height - 16)
        {
          _player.y = FlxG.height - 16;
        }
        if (_player.x < 0)
        {
          _player.x = 0;
        }
        else if (_player.x > FlxG.width - 32)
        {
          _player.x = FlxG.width - 32;
        }
        
        if (_enemies.countLiving() == 0)
        {
          Registry.endScene(Registry.WIN);
        }
      }
    }
    
    public function onShoot(): void
    {
      _controlsText.text = controlsString();
      aggro();
    }
    
    public function controlsString(): String
    {
      if (Registry.hasGun && Registry.bullets > 0)
      {
        var controls:String;
        controls = "[Z] Talk   [X] Gun (";
        for (var i:Number = 0; i < 6; ++i)
        {
          if (i < Registry.bullets)
          {
            controls += "*";
          }
          else
          {
            controls += "-";
          }
        }
        controls += ")"
        
        return controls;
      }
      else if (Registry.hasGun)
      {
        return "[Z] Talk   [X] Pistol Whip";
      }
      
      return "[Z] Talk   [X] Punch";
    }
    
    // Lifted from http://forums.flixel.org/index.php?topic=363.0
    public function heightSort(a_thing:FlxSprite, b_thing:FlxSprite):Number
    {
      var a_height:Number = a_thing.y;
      var b_height:Number = b_thing.y;
      if (a_height > b_height) 
      {
        return 1;
      } 
      else if (a_height < b_height) 
      {
        return -1;
      } 
      else 
      {
        return 0;
      }
    }
  }

}
