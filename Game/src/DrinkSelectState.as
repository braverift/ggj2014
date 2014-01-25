package  
{
  import org.flixel.*;
  public class DrinkSelectState extends FlxState
  {
    [Embed(source = "../data/art/lemonmartini.png")] private var martini:Class;
  
    private static const DRINK_SIZE:Number = 80;
    private static const DRINK_BUFFER:Number = 20;
    private static const DRINK_TOP:Number = 40; 
    private static const HIGHLIGHT_WIDTH:Number = 5;

    private static var drinkSprites:Array = new Array(
      new FlxSprite(DRINK_BUFFER, DRINK_TOP),
      new FlxSprite(DRINK_BUFFER*2 + DRINK_SIZE, DRINK_TOP),
      new FlxSprite(DRINK_BUFFER*3 + DRINK_SIZE*2, DRINK_TOP)
    );

    private static var drinkDescs:Array = new Array(
      "Whiskey, neat: Because you're a progressive woman",
      "Tom Collins: Because you're a down-to-earth woman",
      "Cosmopolitan: Because you're a woman"
    );

    private static var highlightSprite:FlxSprite = new FlxSprite(); 
    private static var curDrink:Number = 0;

    override public function create(): void
    {
      //add(new FlxSprite(0, 0, background));
      var title:FlxText = new FlxText(0, 10, 320, "What'll it be?");
      title.alignment = "center";
      add(title);

      var highlightSize:Number = DRINK_SIZE + 2*HIGHLIGHT_WIDTH;
      highlightSprite.makeGraphic(highlightSize, highlightSize);
      add(highlightSprite);

      for(var i:Number=0;i < drinkSprites.length;i++) {
        //drinkSprites[i].makeGraphic(DRINK_SIZE, DRINK_SIZE, 0xFFFF0000);
        drinkSprites[i].loadGraphic(martini, false, false, DRINK_SIZE, DRINK_SIZE);
        add(drinkSprites[i]);
      }

      for(i=0;i < drinkDescs.length;i++) {
        drinkDescs[i] = new FlxText(0, 160, 320, drinkDescs[i]);
        drinkDescs[i].alignment = "center";
        drinkDescs[i].exists = false;
        add(drinkDescs[i]);
      }
    }
    
    override public function update():void
    {
      // Place the highlight
      highlightSprite.x = DRINK_BUFFER*(curDrink+1) + DRINK_SIZE*curDrink - HIGHLIGHT_WIDTH;
      highlightSprite.y = DRINK_TOP - HIGHLIGHT_WIDTH;

      if(FlxG.keys.justPressed("RIGHT")) {
        curDrink = (curDrink+1) % drinkSprites.length;
      } else if(FlxG.keys.justPressed("LEFT")) {
        curDrink = (curDrink-1+drinkSprites.length) % drinkSprites.length;
      }

      for(var i:Number=0;i < drinkDescs.length;i++) {
        drinkDescs[i].exists = curDrink == i;
      }

      super.update();      
    }
  }

}
