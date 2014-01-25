package  
{
  import org.flixel.FlxState;
  import org.flixel.FlxG;
  import org.flixel.FlxText;
  
  public class TitleState extends FlxState
  {  
    public function TitleState(): void
    {
      var txt:FlxText
      txt = new FlxText(0, 32, FlxG.width, "are you a wizard??")
      txt.setFormat(null, 24, 0xFFFFFFFF, "center")
      this.add(txt);
      
      txt = new FlxText(0, FlxG.height - 64, FlxG.width, "now you are.");
      txt.setFormat(null, 16, 0xFFFFFFFF, "center");
      this.add(txt);
    }
    
    override public function update():void
    {
      super.update();
    }
  }
}