package  
{
  import org.flixel.FlxSprite;
	/**
   * ...
   * @author ...
   */

  public class EnemyKOed extends FlxSprite
  {
    [Embed(source = "../data/art/char_enemy_ko.png")] private var enemyGraphic:Class;

    public function EnemyKOed(X:Number, Y:Number) 
    {
      super(X, Y);
      
      loadGraphic(enemyGraphic, false, false, 32, 48);
    }
    
  }

}