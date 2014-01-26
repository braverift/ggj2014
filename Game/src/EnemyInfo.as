package  
{
	/**
   * ...
   * @author ...
   */
  public class EnemyInfo 
  {
    public static const NORMAL:uint = 0;
    public static const OTHER:uint = 1;
    public static const BRO:uint = 2;
    
    public var type:uint;
    public var x:Number;
    public var y:Number;
    public var minIntensity:Number;
    public var dialogue:Array;
    
    public function EnemyInfo(type:uint, x:Number, y:Number, minIntensity:Number) 
    {
      this.type = type;
      this.x = x;
      this.y = y;
      this.minIntensity = minIntensity;
      dialogue = new Array;
    }
    
    public function addDialogue(dialogue:Array): void
    {
      this.dialogue = dialogue;
    }
  }

}