package  
{
  import org.flixel.*;
  public class BarState extends FlxState
  {
    [Embed(source = "../data/art/bg_bar.png" )] private var background:Class;
    
    public static var diagBox:FlxText;
    public static var sceneIdx:uint;
    public static var sceneArray:Array; 

    override public function create(): void
    {      
      add(new FlxSprite(0, 0, background));
    
      sceneIdx = 0;
      diagBox = new FlxText(20, 180, 280);
      add(diagBox);

      sceneArray = Registry.barScenes[Registry.barScene];
    }
    
    override public function update():void
    {
      // Dialogue
      var curDiag:Dialogue = sceneArray[sceneIdx];
      diagBox.text = curDiag.text;
      diagBox.color = curDiag.color;
      super.update();      
      if (FlxG.keys.justPressed("SPACE"))
      {
        sceneIdx++;
        if (sceneArray[sceneIdx] is DrinkSet) {
         FlxG.switchState(new DrinkSelectState(sceneArray[sceneIdx])); 
        }
      }
    }
  }

}
