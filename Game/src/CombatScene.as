package  
{
  public class CombatScene 
  {
    public static const BG_BAR:Number = 0;
    public static const BG_PARTY:Number = 1;
    public static const BG_WAREHOUSE:Number = 2;
    public static const BG_APARTMENT:Number = 3;
    public static const BG_PARK:Number = 4;
    public static const BG_TRAIN:Number = 5;
    public static const BG_SKYSCRAPER:Number = 6;
    public static const BG_CAVE:Number = 7;
    public static const BG_OUTSIDE_BAR:Number = 8;
    
    public var _background:uint;
    public var _enemies:Array;
    public var _x:Number;
    public var _y:Number;
    
    public function CombatScene(bg:uint, xStart:Number, yStart:Number)
    {
      _background = bg;
      _enemies = new Array;
      _x = xStart;
      _y = yStart;
    }
    
    public function addSilentEnemy(type:uint, x:Number, y:Number, minIntensity:Number = 0): void
    {
      _enemies.push(new EnemyInfo(type, x, y, minIntensity));
    }
    
    public function addEnemy(type:uint, x:Number, y:Number, minIntensity:Number, dialogue:Array): void
    {
      var enemy:EnemyInfo = new EnemyInfo(type, x, y, minIntensity);
      enemy.addDialogue(dialogue);
      _enemies.push(enemy);
    }
  }

}
