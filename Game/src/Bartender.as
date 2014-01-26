package  
{
  import org.flixel.*;
  public class Bartender extends FlxSprite
  {
    [Embed(source = "../data/art/char_bartender.png")] private var bartGraphic:Class;

    public const FRAME_WIDTH:int = 30;
    public const FRAME_HEIGHT:int = 32;
    
    public function Bartender(X:Number, Y:Number) 
    {
      super(X, Y);
      
      loadGraphic(bartGraphic, true, true, FRAME_WIDTH, FRAME_HEIGHT);
      addAnimation("idle", [0]);
      addAnimation("serving", [1]);
    }
    
    override public function update():void
    {
      super.update();
    }
  }

}
