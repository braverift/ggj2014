package  
{
  import org.flixel.*;
  public class Dialogue
  {
    public var text:String;
    public var color:uint;
    public var minMood:Number;
    public var maxMood:Number;
    public var isPlotPoint:Boolean;
    
    public function Dialogue(
      text:String = "UNITIALIZED", 
      color:uint = 0xFFDD0000, // Can't use Registry.SP_PLAYER? Wat. 
      minMood:Number = -1, 
      maxMood:Number = 1,
      plotPoint:Boolean = false
    ){
      this.text = text;
      this.color = color;
      this.minMood = minMood;
      this.maxMood = maxMood;
      this.isPlotPoint = plotPoint;
    }
  }

}
