package  
{
  import org.flixel.*;
  public class DrinkSelectState extends FlxState
  {
    [Embed(source = "../data/art/lemonmartini.png")] private var martini:Class;
  
    private static const DRINK_SIZE:Number = 80;
    private static const DRINK_BUFFER:Number = 20;
    private static const DRINK_TOP:Number = 50; 
    private static const HIGHLIGHT_WIDTH:Number = 5;
    private static const NAME_TOP:Number = 150;
    private static const DESC_TOP:Number = 180;
    private static const DESC_COLOR:uint = 0xFFEEEEEE;

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

    private static var fading:Boolean;

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
      titleBox.size = 16;
      add(titleBox);

      var highlightSize:Number = DRINK_SIZE + 2*HIGHLIGHT_WIDTH;
      highlightSprite.makeGraphic(highlightSize, highlightSize);
      add(highlightSprite);

      for(var i:Number=0;i < drinkSprites.length;i++) {
        drinkSprites[i].loadGraphic(martini, false, false, DRINK_SIZE, DRINK_SIZE);
        add(drinkSprites[i]);
      }

      nameBox = new FlxText(10, NAME_TOP, 300);
      nameBox.alignment = "center";
      nameBox.size = 16;
      add(nameBox);

      descBox = new FlxText(10, DESC_TOP, 300);
      descBox.alignment = "center";
      descBox.color = DESC_COLOR;
      descBox.shadow = Utility.darkerize(DESC_COLOR);
      descBox.size = 16;
      add(descBox);

      fading = true;
      FlxG.flash(0xFF000000, 0.5, function():void {fading=false;});
    }
    
    override public function update():void
    {
      // Place the highlight
      highlightSprite.x = DRINK_BUFFER*(curDrink+1) + DRINK_SIZE*curDrink - HIGHLIGHT_WIDTH;
      highlightSprite.y = DRINK_TOP - HIGHLIGHT_WIDTH;

      if (!fading) {
        if (FlxG.keys.justPressed("RIGHT")) {
          curDrink = (curDrink+1) % drinkSprites.length;
        } else if (FlxG.keys.justPressed("LEFT")) {
          curDrink = (curDrink-1+drinkSprites.length) % drinkSprites.length;
        } else if (FlxG.keys.justPressed("X")) {
          Registry.barScene += curDrink+1;
          Registry.mood += drinks.drinks[curDrink].mood;
          fading = true;
          FlxG.fade(0xFF000000, 0.5, function():void {
            FlxG.switchState(new BarState(true, drinks.drinks[curDrink].color));
          });
        }
      }

      var drink:Drink = drinks.drinks[curDrink];
      nameBox.color = drink.color;
      nameBox.shadow = Utility.darkerize(drink.color);
      nameBox.text = drink.name;
      descBox.text = drink.desc;

      super.update();
    }
  }

}
