package  
{
  import org.flixel.*;
  public class Registry 
  {
    public static var mood:Number; // Current mood, in the range [-1, 1]
    public static var intensity:Number; // Current intensity, in the range [0, 1]
    public static var barScene:uint; // ID of the current bar scene
    
    public static function initialize(): void
    {
      mood = intensity = 0;
      barScene = 0;
      FlxG.watch(Registry, "mood");
      FlxG.watch(Registry, "intensity");
    }

    /*
     * BAR DIALOGUE
     */
    public static const SP_PLAYER:uint = 0xFFDD0000;  // Player's speech color
    public static const SP_BART:uint = 0xFFEE7942;    // Bartender's speech color
    public static const SP_OTHER:uint = 0xFF859C27;   // Other's speech color
    public static const SP_BRO:uint = 0xFF6666CC;     // Bro's speech color
    public static const SP_GEN:uint = 0xFFCCCCCC;     // Generic character's speech color
    public static var barScenes:Array = new Array(
      new Array( // Scene 0
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
        new Dialogue("Here you go.", SP_BART),
        new Dialogue("Rough day?", SP_BART),
        new Dialogue("This is a bunch of idle chatter that will take a while " +
                     "to finish. Use this time to test out drinking your drink.",
                     SP_GEN)
      ),
      new Array( // Scene 2
        new Dialogue("Here you go.", SP_BART),
        new Dialogue("This is a bunch of idle chatter that will take a while " +
                     "to finish. Use this time to test out drinking your drink.",
                     SP_GEN)
      ),
      new Array( // Scene 3
        new Dialogue("Here you go.", SP_BART),
        new Dialogue("This is a bunch of idle chatter that will take a while " +
                     "to finish. Use this time to test out drinking your drink.",
                     SP_GEN)
      )
    );

      
  }

}
