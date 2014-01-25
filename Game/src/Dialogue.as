package  
{
  import org.flixel.*;
  public class Dialogue
  {
    public var text:String;
    public var color:uint;
    public var minMood:Number;
    public var maxMood:Number;
    //TODO: I assume that intensity doesn't affect dialogue currently
    //TODO: Does mood matter?

    public function Dialogue(
      text:String = "UNITIALIZED", 
      color:uint = Registry.SP_PLAYER, 
      minMood:Number = 0, 
      maxMood:Number = 1
    ){
      this.text = text;
      this.color = color;
      this.minMood = minMood;
      this.maxMood = maxMood;
    }
  }

}
