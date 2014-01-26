package  
{
  import org.flixel.FlxState;
  import org.flixel.FlxG;
  import org.flixel.FlxText;
  import org.flixel.FlxSprite;
  
  public class TitleState extends FlxState
  { 
    private static var fading:Boolean;
    [Embed(source = "../data/art/bg_bar.png" )] private var bgBar:Class;

    public function TitleState(): void
    {
      add(new FlxSprite(0, 0, bgBar));

      fading = false;

      var txt:FlxText
      txt = new FlxText(0, 20, FlxG.width, "What'll it be?");
      txt.setFormat(null, 24, 0xFFFFFFFF, "center");
      txt.shadow = 0xFF777777;
      this.add(txt);
      
      txt = new FlxText(0, 170, FlxG.width, "a drinking game");
      txt.setFormat(null, 16, 0xFFFFFFFF, "center");
      this.add(txt);
      
      txt = new FlxText(0, 200, FlxG.width, "by Jason Hamilton, Doug Macdonald, and Wesley May");
      txt.setFormat(null, 8, 0xFFFFFFFF, "center");
      this.add(txt);
      
      txt = new FlxText(0, FlxG.height - 12, FlxG.width, "Z - Drink / Use Words          X - Use Violence");
      txt.setFormat(null, 8, 0xFFFFFFFF, "center");
      this.add(txt);

    }
    
    override public function update():void
    {
      super.update();
     
      if (!fading) {
        if (FlxG.keys.X || FlxG.keys.Z)
        {
          Registry.initialize();
          fading = true;
          FlxG.fade(0xFF000000, 1, function():void {
            FlxG.switchState(new BarState());
          });
        }
      }
    }
  }
}
