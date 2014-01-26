package  
{
  import org.flixel.*;
  public class Registry 
  {
    public static var mood:Number;      // Current mood, in the range [-1, 1]
    public static var intensity:Number; // Current intensity, in the range [0, 1]
    public static var barScene:uint;    // ID of the current bar scene
    public static var gameScene:uint;   // ID of the current game scene
    
    public static function initialize(): void
    {
      mood = intensity = 0;
      barScene = 0;
      FlxG.watch(Registry, "mood");
      FlxG.watch(Registry, "intensity");
    }

    /*
     * COMBAT TO BAR TRANSITIONS
     *
     * A transition specifies the possible bar scene IDs to transition to. 
     * The order is Talk, Walk, Win, Lose.
     * As per the bar dialogue format, these will only ever be multiples of 4.
     */
    public static const combatToBarTransArray:Array = new Array(
      new CombatToBarTransition(8, 4, 12, 16) // Scene 0 - Party
    );
    
    public static const TALK:uint = 0;
    public static const WALK:uint = 1;
    public static const WIN:uint = 2;
    public static const LOSE:uint = 3;
    public static function endScene(outcome:uint): void
    {
      switch (outcome) {
        case TALK:
          barScene = combatToBarTransArray[gameScene].talk;
          break;
        case WALK:
          barScene = combatToBarTransArray[gameScene].walk;
          break;
        case WIN:
          barScene = combatToBarTransArray[gameScene].win;
          break;
        case LOSE:
          barScene = combatToBarTransArray[gameScene].lose;
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
         new Drink("Whiskey, Neat", "Whiskey in highball", 0xFFB46A2F, -0.1),
         new Drink("Tom Collins", "Gin, lemon juice, simple syrup, soda", 0xFFDDEEDD, 0.0),
         new Drink("Cosmopolitan", "Citron, Cointreau, lime juice, cranberry juice", 0xFFEE0053, 0.1)
        )
      ),
      new Array( // Scene 1
        new Dialogue("Sure thing. Here you go.", SP_BART),
        new Dialogue("(Hold Z to drink your drink.)" +
                     "                             ", SP_GEN),
        new Dialogue("Rough day?", SP_BART),
        new Dialogue("This is a bunch of idle chatter that will take a while " +
                     "to finish. Use this time to test out drinking your drink.",
                     SP_GEN)
      ),
      new Array( // Scene 2
        new Dialogue("Sure thing. Here you go.", SP_BART),
        new Dialogue("(Hold Z to drink your drink.)" +
                     "                             ", SP_GEN),
        new Dialogue("This is a bunch of idle chatter that will take a while " +
                     "to finish. Use this time to test out drinking your drink.",
                     SP_GEN)
      ),
      new Array( // Scene 3
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
         new Drink("Whiskey, Neat", "Whiskey in highball", 0xFFB46A2F, -0.1),
         new Drink("Tom Collins", "Gin, lemon juice, simple syrup, soda", 0xFFDDEEDD, 0.0),
         new Drink("Cosmopolitan", "Citron, Cointreau, lime juice, cranberry juice", 0xFFEE0053, 0.1)
        )
      )
    );
      
  }
}
