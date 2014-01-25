package  
{
	import flash.display.Stage;
	import org.flixel.FlxGame;
	import TitleState;

	/**
	 * ...
	 * @author Doug Macdonald
	 */
	
	[SWF(width = "550", height = "450", backgroundColor = "#FFFFFF")]
	[Frame(factoryClass = "Preloader")]
	
	public class GGJ2K4 extends FlxGame
	{
    public function GGJ2K4(): void
    {
      super(550, 450, TitleState, 1);
    }    
	}
}