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
    [Embed(source = "../data/art/char_enemy_dead.png")] private var shotGraphic:Class;

    public const FRAME_WIDTH:int = 58;
    public const FRAME_HEIGHT:int = 80;

    public function EnemyKOed(X:Number, Y:Number, ownerColor:uint, wasShot:Boolean) 
    {
      super(X, Y);
      loadGraphic(wasShot ? shotGraphic : enemyGraphic, false, false, FRAME_WIDTH, FRAME_HEIGHT);
      color = ownerColor;
    }
    
  }

}