package  
{
	import flash.display.Stage;
	import org.flixel.FlxGame;
	import TitleState;

	/**
	 * ...
	 * @author Doug Macdonald
	 */
	
	[SWF(width = "640", height = "480", backgroundColor = "#FFFFFF")]
	[Frame(factoryClass = "Preloader")]
	
	public class GGJ2K4 extends FlxGame
	{
    public function GGJ2K4(): void
    {
      super(320, 240, TitleState, 2);
    }    
	}
}