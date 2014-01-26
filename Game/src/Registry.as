package  
{
  import org.flixel.*;
  public class Registry 
  {
    public static var mood:Number;      // Current mood, in the range [-1, 1]
    public static var intensity:Number; // Current intensity, in the range [0, 1]
    public static var barScene:uint;    // ID of the current bar scene
    public static var combatScene:uint; // ID of the current combat scene
    public static var hasGun:Boolean;
    public static var bullets:Number;
    public static var drinksDrunk:uint;
    
    public static function initialize(): void
    {
      mood = intensity = 0;
      barScene = 0;
      combatScene = 0;
      drinksDrunk = 0;
      FlxG.watch(Registry, "mood");
      FlxG.watch(Registry, "intensity");
      
      hasGun = true;
      bullets = 6;
    }

    /*
     * COMBAT TO BAR TRANSITIONS
     *
     * A transition specifies the possible bar scene IDs to transition to. 
     * The order is Talk, Walk, Win, Lose.
     * As per the bar dialogue format, these will only ever be multiples of 4.
     */
    public static const combatToBarTransArray:Array = new Array(
      new CombatToBarTransition(16, 4, 8, 12) // Scene 0 - Party
    );
    
    public static const TALK:uint = 0;
    public static const WALK:uint = 1;
    public static const WIN:uint = 2;
    public static const LOSE:uint = 3;
    public static function endScene(outcome:uint): void
    {
      switch (outcome) {
        case TALK:
          barScene = combatToBarTransArray[combatScene].talk;
          break;
        case WALK:
          barScene = combatToBarTransArray[combatScene].walk;
          break;
        case WIN:
          barScene = combatToBarTransArray[combatScene].win;
          break;
        case LOSE:
          barScene = combatToBarTransArray[combatScene].lose;
          break;
      }
      FlxG.fade(0xFF000000, 1, function():void {FlxG.switchState(new BarState());});
    }

    /*
     * BAR TO COMBAT TRANSITIONS
     *
     * These are always one-to-one, so you can simply specify a game scene ID
     * for each bar scene ID. 
     */
    public static const barToCombatTransArray:Array = new Array(
      0 // Before the Party
    );

    /*
     * BAR DIALOGUE
     * 
     * Every 4th entry (0, 4, 8, ...) must end with a DrinkSet.
     * The next 3 entries are the dialogue sets for the respective drinks.
     */
    public static const SP_PLAYER:uint = 0xFFDD0000;  // Player's speech color
    public static const SP_BART:uint = 0xFFEE7942;    // Bartender's speech color
    public static const SP_OTHER:uint = 0xFF859C27;   // Other's speech color
    public static const SP_BRO:uint = 0xFF6666CC;     // Bro's speech color
    public static const SP_GEN:uint = 0xFFCCCCCC;     // Generic character's speech color
    public static var barScenes:Array = new Array(
      new Array( // Scene 0 - Intro
        new Dialogue("I am the main character. I talk like this. " +
                     "Sometimes I talk so much it wraps around the screen. " +
                     "But I never speak more than three lines at once."),
        new Dialogue("And now the bartender talks.", SP_BART),
        new Dialogue("And now the Other talks.", SP_OTHER),
        new Dialogue("And now Bro talks.", SP_BRO),
        new Dialogue("And now a generic NPC talks.", SP_GEN),
        new DrinkSet(
         new Drink("Scotch on the Rocks", "Cool and classic", 0xFFBB7136, -0.25),
         new Drink("Tom Collins", "Gin, lemon juice, simple syrup, soda", 0xFFDDEEDD, 0.0),
         new Drink("Cosmopolitan", "Citron, Cointreau, lime juice, cranberry juice", 0xFFEE0053, 0.25)
        )
      ),
      new Array( // Scene 0a
        new Dialogue("Sure thing. Here you go.", SP_BART),
        new Dialogue("(Hold Z to drink your drink.)" +
                     "                             ", SP_GEN),
        new Dialogue("Rough day?", SP_BART),
        new Dialogue("This is a bunch of idle chatter that will take a while " +
                     "to finish. Use this time to test out drinking your drink.",
                     SP_GEN)
      ),
      new Array( // Scene 0b
        new Dialogue("Sure thing. Here you go.", SP_BART),
        new Dialogue("(Hold Z to drink your drink.)" +
                     "                             ", SP_GEN),
        new Dialogue("This is a bunch of idle chatter that will take a while " +
                     "to finish. Use this time to test out drinking your drink.",
                     SP_GEN)
      ),
      new Array( // Scene 0c
        new Dialogue("Sure thing. Here you go.", SP_BART),
        new Dialogue("(Hold Z to drink your drink.)" +
                     "                             ", SP_GEN),
        new Dialogue("This is a bunch of idle chatter that will take a while " +
                     "to finish. Use this time to test out drinking your drink.",
                     SP_GEN)
      ),
      new Array( // Scene 4 - WALK TEST
        new Dialogue("Huh.", SP_BART),
        new Dialogue("So you just walked away?", SP_BART),
        new DrinkSet(
         new Drink("Whiskey, Neat", "Enjoy the heat", 0xFFB46A2F, -0.25),
         new Drink("Bloody Mary", "Vodka, tomato juice, Worcestershire, Tabasco", 0xFFBB0000, 0.0),
         new Drink("Margarita", "Tequila, Cointreau, lime juice, blended", 0xFF96E643, 0.25)
        )
      ),
      new Array( // Scene 4a
        new Dialogue("Sure thing. Here you go.", SP_BART)
      ),
      new Array( // Scene 4b
        new Dialogue("Sure thing. Here you go.", SP_BART)
      ),
      new Array( // Scene 4c
        new Dialogue("Sure thing. Here you go.", SP_BART)
      ),
      new Array( // Scene 8 - WIN TEST
        new Dialogue("Huh.", SP_BART),
        new Dialogue("I guess you really gave them what for.", SP_BART),
        new DrinkSet(
         new Drink("Whiskey, Neat", "Enjoy the heat", 0xFFB46A2F, -0.1),
         new Drink("Bloody Mary", "Vodka, tomato juice, Worcestershire, Tabasco", 0xFFBB0000, 0.0),
         new Drink("Margarita", "Tequila, Cointreau, lime juice, blended", 0xFF96E643, 0.1)
        )
      ),
      new Array( // Scene 8a
        new Dialogue("Sure thing. Here you go.", SP_BART)
      ),
      new Array( // Scene 8b
        new Dialogue("Sure thing. Here you go.", SP_BART)
      ),
      new Array( // Scene 8c
        new Dialogue("Sure thing. Here you go.", SP_BART)
      ),
      new Array( // Scene 12 - LOSE TEST
        new Dialogue("Huh.", SP_BART),
        new Dialogue("I can see why you came in here.", SP_BART),
        new DrinkSet(
         new Drink("Whiskey, Neat", "Enjoy the heat", 0xFFB46A2F, -0.1),
         new Drink("Bloody Mary", "Vodka, tomato juice, Worcestershire, Tabasco", 0xFFBB0000, 0.0),
         new Drink("Margarita", "Tequila, Cointreau, lime juice, blended", 0xFF96E643, 0.1)
        )
      ),
      new Array( // Scene 12a
        new Dialogue("Sure thing. Here you go.", SP_BART)
      ),
      new Array( // Scene 12b
        new Dialogue("Sure thing. Here you go.", SP_BART)
      ),
      new Array( // Scene 12c
        new Dialogue("Sure thing. Here you go.", SP_BART)
      ),
      new Array( // Scene 16 - WALK TEST
        new Dialogue("Huh.", SP_BART),
        new Dialogue("Sounds like that could've gone worse.", SP_BART),
        new DrinkSet(
         new Drink("Whiskey, Neat", "Enjoy the heat", 0xFFB46A2F, -0.1),
         new Drink("Bloody Mary", "Vodka, tomato juice, Worcestershire, Tabasco", 0xFFBB0000, 0.0),
         new Drink("Margarita", "Tequila, Cointreau, lime juice, blended", 0xFF96E643, 0.1)
        )
      ),
      new Array( // Scene 16a
        new Dialogue("Sure thing. Here you go.", SP_BART)
      ),
      new Array( // Scene 16b
        new Dialogue("Sure thing. Here you go.", SP_BART)
      ),
      new Array( // Scene 16c
        new Dialogue("Sure thing. Here you go.", SP_BART)
      )
    );
  
    /* TEMP DRINKSET STORAGE

        new DrinkSet(
         new Drink("Everclear", "No ambiguity", 0x77FFFFFF, -0.25),
         new Drink("Sidecar", "Cognac, Triple Sec, lemon juice", 0xFFFFAE19, 0.0),
         new Drink("Aviation", "Gin, lemon juice, maraschino, creme de violette", 0xFFD8BFD8, 0.25)
        )
        
        new DrinkSet(
         new Drink("Absinthe", "No ambiguity", 0xFF3DFB07, -0.25),
         new Drink("Gin and Tonic", "Gin, tonic water, twist of lime", 0xFFFFDDEEEE, 0.0),
         new Drink("Bellini", "Sparkling wine, peach puree", 0xFFFF9955, 0.25)
        )

    */
  }
}
