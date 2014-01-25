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

    private static var drinks:DrinkSet;
    private static var highlightSprite:FlxSprite = new FlxSprite(); 
    private static var curDrink:Number = 0;

    private static var titleBox:FlxText;
    private static var nameBox:FlxText;
    private static var descBox:FlxText;

    public function DrinkSelectState(d:DrinkSet)
    {
      drinks = d;
    }

    override public function create(): void
    {
      //add(new FlxSprite(0, 0, background));
      titleBox = new FlxText(0, 10, 320, "What'll it be?");
      titleBox.alignment = "center";
      titleBox.color = Registry.SP_BART;
      titleBox.shadow = Utility.darkerize(Registry.SP_BART);
      add(titleBox);

      var highlightSize:Number = DRINK_SIZE + 2*HIGHLIGHT_WIDTH;
      highlightSprite.makeGraphic(highlightSize, highlightSize);
      add(highlightSprite);

      for(var i:Number=0;i < drinkSprites.length;i++) {
        drinkSprites[i].loadGraphic(martini, false, false, DRINK_SIZE, DRINK_SIZE);
        add(drinkSprites[i]);
      }

      nameBox = new FlxText(0, 140, 320);
      nameBox.alignment = "center";
      add(nameBox);

      descBox = new FlxText(0, 160, 320);
      descBox.alignment = "center";
      add(descBox);
    }
    
    override public function update():void
    {
      // Place the highlight
      highlightSprite.x = DRINK_BUFFER*(curDrink+1) + DRINK_SIZE*curDrink - HIGHLIGHT_WIDTH;
      highlightSprite.y = DRINK_TOP - HIGHLIGHT_WIDTH;

      if (FlxG.keys.justPressed("RIGHT")) {
        curDrink = (curDrink+1) % drinkSprites.length;
      } else if (FlxG.keys.justPressed("LEFT")) {
        curDrink = (curDrink-1+drinkSprites.length) % drinkSprites.length;
      } else if (FlxG.keys.justPressed("X")) {
        Registry.barScene += curDrink+1;
        Registry.mood += drinks.drinks[curDrink].mood;
        FlxG.switchState(new BarState());
      }

      nameBox.text = drinks.drinks[curDrink].name;
      descBox.text = drinks.drinks[curDrink].desc;

      super.update();
    }
  }

}
