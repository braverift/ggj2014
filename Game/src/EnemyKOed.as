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
    [Embed(source = "../data/art/char_enemy_armor_ko.png")] private var enemyArmoredGraphic:Class;
    [Embed(source = "../data/art/char_enemy_armor_dead.png")] private var enemyArmoredShotGraphic:Class;
    [Embed(source = "../data/art/char_brother_ko.png")] private var broGraphic:Class;
    [Embed(source = "../data/art/char_brother_dead.png")] private var broShotGraphic:Class;
    [Embed(source = "../data/art/char_girlfriend_ko.png")] private var gfGraphic:Class;
    [Embed(source = "../data/art/char_girlfriend_dead.png")] private var gfShotGraphic:Class;
    [Embed(source = "../data/art/char_other_ko.png")] private var otherGraphic:Class;
    [Embed(source = "../data/art/char_other_dead.png")] private var otherShotGraphic:Class;

    public const FRAME_WIDTH:int = 58;
    public const FRAME_HEIGHT:int = 80;
    
    public const FRICTION:Number = 10;

    public function EnemyKOed(X:Number, Y:Number, ownerColor:uint, wasShot:Boolean, facing:uint, type:Number) 
    {
      super(X, Y);
      if (type == EnemyInfo.NORMAL)
      {
        loadGraphic(wasShot ? enemyArmoredShotGraphic : enemyArmoredGraphic, false, true, FRAME_WIDTH, FRAME_HEIGHT);
      }
      else if (type == EnemyInfo.WEAK)
      {
        loadGraphic(wasShot ? shotGraphic : enemyGraphic, false, true, FRAME_WIDTH, FRAME_HEIGHT);
      }
      else if (type == EnemyInfo.BRO)
      {
        loadGraphic(wasShot ? broShotGraphic : broGraphic, false, true, FRAME_WIDTH, FRAME_HEIGHT);
      }
      else if (type == EnemyInfo.GIRLFRIEND)
      {
        loadGraphic(wasShot ? gfShotGraphic : gfGraphic, false, true, FRAME_WIDTH, FRAME_HEIGHT);
      }
      else if (type == EnemyInfo.OTHER)
      {
        loadGraphic(wasShot ? otherShotGraphic : otherGraphic, false, true, FRAME_WIDTH, FRAME_HEIGHT);
      }
      color = ownerColor;
        
      velocity.x = ((facing == LEFT) ? 1 : -1) * (wasShot ? 500 : 100);
    }
    
    public override function update(): void
    {
      super.update();
      
      velocity.x *= 0.8;
    }
  }

}