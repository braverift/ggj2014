package  
{
  import org.flixel.*;
	/**
   * ...
   * @author ...
   */
  public class BarState extends FlxState
  {
    [Embed(source = "../data/art/bg_bar.png" )] private var background:Class;
    
    override public function create(): void
    {      
      add(new FlxSprite(0, 0, background));
    }
    
    override public function update():void
    {

      super.update();      
      if (FlxG.keys.SPACE)
      {
        FlxG.switchState(new DrinkSelectState());
      }
    }
  }

}
