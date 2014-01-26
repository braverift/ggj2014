package  
{
  import org.flixel.FlxState;
  import org.flixel.FlxG;
  import org.flixel.FlxText;
  
  public class TitleState extends FlxState
  { 
    private static var fading:Boolean;

    public function TitleState(): void
    {
      var txt:FlxText
      txt = new FlxText(0, 20, FlxG.width, "what'll it be");
      txt.setFormat(null, 24, 0xFFFFFFFF, "center");
      txt.shadow = 0xFF777777;
      this.add(txt);
      
      txt = new FlxText(0, 90, FlxG.width, "a drinking game");
      txt.setFormat(null, 16, 0xFFFFFFFF, "center");
      this.add(txt);
      
      txt = new FlxText(0, 130, FlxG.width, "by Jason Hamilton, Doug Macdonald, and Wesley May");
      txt.setFormat(null, 16, 0xFFFFFFFF, "center");
      this.add(txt);
      
      txt = new FlxText(0, 200, FlxG.width, "Z - Drink / Use Words");
      txt.setFormat(null, 8, 0xFFFFFFFF, "center");
      this.add(txt);
      
      txt = new FlxText(0, 210, FlxG.width, "X - Use Violence");
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
        else if (FlxG.keys.ENTER)
        {
          Registry.initialize();
          FlxG.switchState(new CombatState());
        }
      }
    }
  }
}
