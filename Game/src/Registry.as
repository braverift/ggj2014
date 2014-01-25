package  
{
  public class Registry 
  {
    public static var barScene:uint; // ID of the current bar scene
    
    public static function initialize(): void
    {
      barScene = 0;
    }

    /*
     * BAR DIALOGUE
     */
    public static const SP_PLAYER:uint = 0xFFCCCCCC; // Player's speech color
    public static const SP_BART:uint = 0xFFEE7942; // Bartender's speech color
    public static const SP_OTHER:uint = 0xFF859C27; // Other's speech color
    public static const SP_BRO:uint = 0xFF6666CC; // Bro's speech color
    public static var barScenes:Array = new Array(
      new Array( // Scene 0
        new Dialogue("I am the main character."),
        new Dialogue("I talk like this."),
        new Dialogue("And now the bartender talks.", SP_BART),
        new Dialogue("And now the Other talks.", SP_OTHER),
        new Dialogue("And now Bro talks.", SP_BRO),
        new DrinkSet(
         new Drink("Whiskey, Neat", "Whiskey in highball", -0.1),
         new Drink("Tom Collins", "Gin, lemon juice, simple syrup, soda", 0.0),
         new Drink("Cosmopolitan", "Citron, Cointreau, lime juice, cranberry juice", 0.1)
        )
      ),
      new Array( // Scene 1
        new Dialogue("You have picked the first drink.", SP_BART)
      ),
      new Array( // Scene 2
        new Dialogue("You have picked the second drink.", SP_BART)
      ),
      new Array( // Scene 3
        new Dialogue("You have picked the third drink.", SP_BART)
      )
    );

      
  }

}
