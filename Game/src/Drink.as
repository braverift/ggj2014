package  
{
  import org.flixel.*;
  public class Drink
  {
    public var name:String;
    public var desc:String;
    public var color:uint;
    public var mood:Number;

    public function Drink(name:String, desc:String, color:uint, mood:Number)
    {
      this.name = name;
      this.desc = desc;
      this.color = color;
      this.mood = mood;
    }
  }

}
