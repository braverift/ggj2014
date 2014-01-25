package  
{
  import org.flixel.*;
  import flash.utils.*;
  public class BarState extends FlxState
  {
    [Embed(source = "../data/art/bg_bar.png" )] private var background:Class;
    
    public static const TIME_PER_CHAR:Number = 0.08; // Time per character of text in seconds
    public static const TIME_AT_END:Number = 1.0; // Length of pause after each line in seconds

    public static var diagBox:FlxText;
    public static var sceneIdx:uint;
    public static var sceneArray:Array; 
    public static var diagTime:Number; // Time current line of dialogue has been displayed

    override public function create(): void
    {      
      add(new FlxSprite(0, 0, background));
    
      sceneIdx = 0;
      diagBox = new FlxText(20, 180, 280);
      add(diagBox);

      sceneArray = Registry.barScenes[Registry.barScene];
      diagTime = 0;
      FlxG.watch(BarState, "diagTime");
    }
    
    override public function update():void
    {
      // Dialogue
      diagTime += FlxG.elapsed;
      var charsToShow:Number = diagTime / TIME_PER_CHAR;
      var curDiag:Dialogue = sceneArray[sceneIdx];
      diagBox.text = curDiag.text.substr(0, charsToShow);
      diagBox.color = curDiag.color;

      super.update();

      // Auto advance text
      if (diagTime > curDiag.text.length*TIME_PER_CHAR + TIME_AT_END)
      {
        sceneIdx++;
        diagTime = 0;
        if (sceneArray[sceneIdx] is DrinkSet) {
         FlxG.switchState(new DrinkSelectState(sceneArray[sceneIdx])); 
        }
      }
    }
  }

}
