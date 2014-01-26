package  
{
  import org.flixel.*;
  public class Glass extends FlxSprite
  {
    [Embed(source = "../data/art/empty_drink.png")] private var glassGraphic:Class;

    public const FRAME_WIDTH:int = 4;
    public const FRAME_HEIGHT:int = 8;
    
    public function Glass(X:Number, Y:Number) 
    {
      super(X, Y);
      loadGraphic(glassGraphic, true, true, FRAME_WIDTH, FRAME_HEIGHT);
    }
    
    override public function update():void
    {
      super.update();
    }
  }

}
