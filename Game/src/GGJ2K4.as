package  
{
  import flash.display.Stage;
  import org.flixel.*;
  import TitleState;
  
  [SWF(width = "640", height = "480", backgroundColor = "#FFFFFF")]
  [Frame(factoryClass = "Preloader")]
	
  public class GGJ2K4 extends FlxGame
  {
    public function GGJ2K4(): void
    {
      super(320, 240, TitleState, 2);
      FlxG.debug = true;
    }    
  }
}
