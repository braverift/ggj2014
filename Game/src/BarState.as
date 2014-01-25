package  
{
  import org.flixel.*;
  import flash.utils.*;
  public class BarState extends FlxState
  {
    [Embed(source = "../data/art/bg_bar.png" )] private var background:Class;
    
    private static const TIME_PER_CHAR:Number = 0.08; // Time per character of text in seconds
    private static const TIME_AT_END:Number = 1.0; // Length of pause after each line in seconds
    private static const DIAG_X:Number = 40;
    private static const DIAG_Y:Number = 186;
    private static const DIAG_W:Number = 260;
    private static const DIAG_H:Number = 34;
    private static const DIAG_B:Number = 2;

    private static var diagBox:FlxText;
    private static var diagBackSprite:FlxSprite;
    private static var sceneIdx:uint;
    private static var sceneArray:Array; 
    private static var diagTime:Number; // Time current line of dialogue has been displayed

    private static const DRINK_DOWN:Number = 0.2;  // Speed at which you consume drink
    private static const DRINK_UP:Number = 0.3;    // Speed at which drink is refilled
    private static const DRINK_X:Number = 20;
    private static const DRINK_Y:Number = 20;
    private static const DRINK_W:Number = 10;
    private static const DRINK_H:Number = 200;
    private static const DRINK_B:Number = 2;

    private static var hasDrink:Boolean;
    private static var drinkColor:uint;
    private static var drinkLevel:Number; // Amount of drink remaining, in range [0, 1]
    private static var drinkRefilling:Boolean;
    private static var drinkLevelSprite:FlxSprite;
    private static var drinkBarSprite:FlxSprite;
    private static var drinkBackSprite:FlxSprite;

    public function BarState(hd:Boolean = false, dc:uint = 0):void
    {
      hasDrink = hd;
      drinkColor = dc;
    }

    override public function create():void
    {      
      add(new FlxSprite(0, 0, background));
    
      sceneIdx = 0;
      diagBox = new FlxText(DIAG_X, DIAG_Y, DIAG_W);
      diagBackSprite = new FlxSprite(DIAG_X-DIAG_B, DIAG_Y-DIAG_B);
      diagBackSprite.makeGraphic(DIAG_W + 2*DIAG_B, DIAG_H + 2*DIAG_B, 0x55000000);
      add(diagBackSprite);
      add(diagBox);

      if(hasDrink) {
        drinkLevel = 0.0;
        drinkRefilling = true;
        drinkLevelSprite = new FlxSprite(DRINK_X, DRINK_Y);
        drinkLevelSprite.makeGraphic(DRINK_W, DRINK_H, drinkColor);
        drinkBackSprite = new FlxSprite(DRINK_X, DRINK_Y);
        drinkBackSprite.makeGraphic(DRINK_W, DRINK_H, Utility.darkerize(drinkColor));
        drinkBarSprite = new FlxSprite(DRINK_X-DRINK_B, DRINK_Y-DRINK_B);
        drinkBarSprite.makeGraphic(DRINK_W + 2*DRINK_B, DRINK_H + 2*DRINK_B, 0xFFCCCCCC);
        add(drinkBarSprite);
        add(drinkBackSprite);
        add(drinkLevelSprite);
      }

      sceneArray = Registry.barScenes[Registry.barScene];
      diagTime = 0;
    }
    
    override public function update():void
    {
      // Dialogue
      diagTime += FlxG.elapsed;
      var charsToShow:Number = diagTime / TIME_PER_CHAR;
      var curDiag:Dialogue = sceneArray[sceneIdx];
      diagBox.text = curDiag.text.substr(0, charsToShow);
      diagBox.color = curDiag.color;
      diagBox.shadow = Utility.darkerize(curDiag.color)

      // Drink
      if (hasDrink) {
        if (drinkRefilling) {
          drinkLevel += FlxG.elapsed * DRINK_UP;
          if(drinkLevel >= 1.0) {
            drinkLevel = 1.0;
            drinkRefilling = false;
          }
        } else if (drinkLevel < 0) {
          drinkRefilling = true;
          drinkLevel = 0.0;
        }

        var consumed:int = (1 - drinkLevel) * DRINK_H;
        drinkLevelSprite.y = DRINK_Y + consumed;
        drinkLevelSprite.makeGraphic(DRINK_W, DRINK_H-consumed, drinkColor);
      }

      super.update();

      if (FlxG.keys.justPressed("X")) {
        diagTime = Math.max(diagTime, curDiag.text.length*TIME_PER_CHAR);
      }
      if (FlxG.keys.Z && hasDrink && !drinkRefilling) {
        drinkLevel -= FlxG.elapsed * DRINK_DOWN;
      }

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
