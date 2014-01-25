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
    
    public function CombatState() 
    {
      
    }
    
    override public function create(): void
    {
      _playerAttackGroup = new FlxGroup();
      _player = new Player(150, 150, _playerAttackGroup);
   
      add(new FlxSprite(0, 0, background));
      add(_player);
      add(_playerAttackGroup);
    }
    
    override public function update():void
    {
      super.update();
      
      _player.update();
      _playerAttackGroup.update();
    }
  }

}