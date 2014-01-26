package  
{
  import org.flixel.*;
  public class Registry 
  {
    public static var mood:Number;      // Current mood, in the range [-1, 1]
    public static var intensity:Number; // Current intensity, in the range [0, 1]
    public static var barScene:uint;    // ID of the current bar scene
    public static var combatScene:uint; // ID of the current combat scene
    public static var combatSceneVariant:uint; // ID of the current combat scene
    public static var hasGun:Boolean;
    public static var bullets:Number;
    public static var drinksDrunk:uint;
    private static var outcomes:Array;
    private static var fading:Boolean;
    
    public static const SP_PLAYER:uint = 0xFFDD0000;  // Player's speech color
    public static const SP_BART:uint = 0xFFEE7942;    // Bartender's speech color
    public static const SP_OTHER:uint = 0xFF859C27;   // Other's speech color
    public static const SP_BRO:uint = 0xFF6666CC;     // Bro's speech color
    public static const SP_GEN:uint = 0xFFCCCCCC;     // Generic character's speech color
    
    public static function initialize(): void
    {
      mood = intensity = 0;
      barScene = 0;
      combatScene = 0;
      combatSceneVariant = 0;
      drinksDrunk = 0;
      fading = false;
      FlxG.watch(Registry, "mood");
      FlxG.watch(Registry, "intensity");
      
      hasGun = false;
      bullets = 0;

      outcomes = new Array();
    }

    /*
     * COMBAT TO BAR TRANSITIONS
     *
     * As per the bar dialogue format, these will only ever be multiples of 4.
     */
    
    public static const TALK:uint = 0;
    public static const WALK:uint = 1;
    public static const WIN:uint = 2;
    public static const LOSE:uint = 3;
    public static function endScene(outcome:uint): void
    {
      if (fading) return;
      outcomes[outcomes.length] = outcome;
     
      FlxG.log(outcomes);
      if (outcomes.length == 1) {
        if (outcomes[0] == TALK) barScene = 4;
        if (outcomes[0] == WALK) barScene = 8;
        if (outcomes[0] == WIN) barScene = 12;
        if (outcomes[0] == LOSE) barScene = 16;
      }

      if (outcomes.length == 2) {
        if (outcomes[0] == TALK && outcomes[1] == TALK) barScene = 20;
        if (outcomes[0] == TALK && outcomes[1] == WALK) barScene = 20;
        if (outcomes[0] == TALK && outcomes[1] == WIN) barScene = 20;
        if (outcomes[0] == TALK && outcomes[1] == LOSE) barScene = 20;
        if (outcomes[0] == WALK && outcomes[1] == TALK) barScene = 20;
        if (outcomes[0] == WALK && outcomes[1] == WALK) barScene = 20;
        if (outcomes[0] == WALK && outcomes[1] == WIN) barScene = 20;
        if (outcomes[0] == WALK && outcomes[1] == LOSE) barScene = 20;
        if (outcomes[0] == WIN && outcomes[1] == TALK) barScene = 20;
        if (outcomes[0] == WIN && outcomes[1] == WALK) barScene = 20;
        if (outcomes[0] == WIN && outcomes[1] == WIN) barScene = 20;
        if (outcomes[0] == WIN && outcomes[1] == LOSE) barScene = 20;
        if (outcomes[0] == LOSE && outcomes[1] == TALK) barScene = 20;
        if (outcomes[0] == LOSE && outcomes[1] == WALK) barScene = 20;
        if (outcomes[0] == LOSE && outcomes[1] == WIN) barScene = 20;
        if (outcomes[0] == LOSE && outcomes[1] == LOSE) barScene = 20;
      }
      
      fading = true;
      FlxG.fade(0xFF000000, 1, function():void {
        fading = false;
        FlxG.switchState(new BarState());
      });
    }

    /*
     * BAR TO COMBAT TRANSITIONS
     *
     * These are always one-to-one, so you can simply specify a combat (scene, variant)
     * for each bar ID. 
     */
    public static const barToCombatTransArray:Array = new Array(
      new Array(0, 0), // Party
      new Array(1, 0), // Warehouse (Party TALK)
      new Array(1, 1), // Apartment (Party WALK)
      new Array(1, 1), // Apartment (Party WIN)
      new Array(1, 0), // Warehouse (Party LOSE)
      new Array(2, 0)  // ALL CONFRONTATIONS ARE THE SAME 'CAUSE I'M LAZY :)
    );

    public static function getNextCombatState():void {
      combatScene = barToCombatTransArray[Math.floor(barScene/4)][0];
      combatSceneVariant = barToCombatTransArray[Math.floor(barScene/4)][1];
      FlxG.switchState(new CombatState());
    }

    /*
     * BAR DIALOGUE
     * 
     * Every 4th entry (0, 4, 8, ...) must end with a DrinkSet.
     * The next 3 entries are the dialogue sets for the respective drinks.
     */
    public static var barScenes:Array = new Array(
      new Array( // Scene 0 - Intro
        new Dialogue("Hey.          "),
        new Dialogue("Hey.          ", SP_BART),
        new Dialogue("What'll it be?", SP_BART),
        new DrinkSet(
         new Drink("Scotch on the Rocks", "Cool and classic", 0xFFBB7136, -0.25),
         new Drink("Tom Collins", "Gin, lemon juice, simple syrup, soda", 0xFFDDEEDD, 0.0),
         new Drink("Cosmopolitan", "Citron, Cointreau, lime juice, cranberry juice", 0xFFEE0053, 0.25)
        )
      ),
      new Array( // Scene 0a
        new Dialogue("Sure thing.", SP_BART),
        new Dialogue("(Hold Z to drink your drink.)" +
                     "                             ", SP_GEN),
        new Dialogue("Something on your mind?", SP_BART),
        new Dialogue("...       "),
        new Dialogue("Yeah.     "),
        new Dialogue("I was at a party.")
      ),
      new Array( // Scene 0b
        new Dialogue("Sure thing.", SP_BART),
        new Dialogue("(Hold Z to drink your drink.)" +
                     "                             ", SP_GEN),
        new Dialogue("Here on your own?", SP_BART),
        new Dialogue("Well.     "),
        new Dialogue("I was at this party."),
        new Dialogue("It was a friend of a friend's, you know that kind of thing."),
        new Dialogue("Not really my scene, but I was going to meet my brother there."),
        new Dialogue("I hadn't seen him for a while.")
      ),
      new Array( // Scene 0c
        new Dialogue("Sure thing.", SP_BART),
        new Dialogue("(Hold Z to drink your drink.)" +
                     "                             ", SP_GEN),
        new Dialogue("Wanna hear a crazy story?"),
        new Dialogue("Sure.     ", SP_BART),
        new Dialogue("I was at a party with a bunch of friends, right?"),
        new Dialogue("My brother was going to meet me there. I was waiting for him to show up.")
      ),
      new Array( // Scene 4 - Talked to OTHER at the party
        new Dialogue("Did you recognize him?", SP_BART),
        new Dialogue("No, not at all."),
        new DrinkSet(
         new Drink("Whiskey, Neat", "Enjoy the heat", 0xFFB46A2F, -0.25),
         new Drink("Bloody Mary", "Vodka, tomato juice, Worcestershire, Tabasco", 0xFFBB0000, 0.0),
         new Drink("Margarita", "Tequila, Cointreau, lime juice, blended", 0xFF96E643, 0.25)
        )
      ),
      new Array( // Scene 4a
        new Dialogue("What an asshole."),
        new Dialogue("But looking at him, I knew he wasn't lying."),
        new Dialogue("Did you call the police?", SP_BART),
        new Dialogue("No. I don't trust the police."),
        new Dialogue("That's a whole different story."),
        new Dialogue("I went down to the warehouse alone.")
      ),
      new Array( // Scene 4b
        new Dialogue("At first I assumed it was just a practical joke. " +
                     "Probably one of Logan's idiot friends."),
        new Dialogue("But looking at him, I knew he wasn't lying."),
        new Dialogue("Did you call the police?", SP_BART),
        new Dialogue("No. I didn't think there was time."),
        new Dialogue("I needed to act quickly."),
        new Dialogue("I went down to the warehouse alone.")
      ),
      new Array( // Scene 4c
        new Dialogue("What a dude, huh?"),
        new Dialogue("Did you call the police?", SP_BART),
        new Dialogue("The police?"),
        new Dialogue("It was obviously just one of Logan's friends."),
        new Dialogue("Logan's kind of a joker."),
        new Dialogue("It was just his way of telling me where he was. I went down to the warehouse.")
      ),
      new Array( // Scene 8 - Walked away from the party
        new Dialogue("You just left?", SP_BART),
        new Dialogue("Yeah. I was really only there to see Logan."),
        new DrinkSet(
         new Drink("Whiskey, Neat", "Enjoy the heat", 0xFFB46A2F, -0.25),
         new Drink("Bloody Mary", "Vodka, tomato juice, Worcestershire, Tabasco", 0xFFBB0000, 0.0),
         new Drink("Margarita", "Tequila, Cointreau, lime juice, blended", 0xFF96E643, 0.25)
        )
      ),
      new Array( // Scene 8a
        new Dialogue("I went to his apartment to look for him.")
      ),
      new Array( // Scene 8b
        new Dialogue("I went to his apartment to look for him.")
      ),
      new Array( // Scene 8c
        new Dialogue("I went to his apartment to look for him.")
      ),
      new Array( // Scene 12 - Won a fight at the party
        new Dialogue("Huh.", SP_BART),
        new Dialogue("That sure escalated quickly.", SP_BART),
        new DrinkSet(
         new Drink("Whiskey, Neat", "Enjoy the heat", 0xFFB46A2F, -0.25),
         new Drink("Bloody Mary", "Vodka, tomato juice, Worcestershire, Tabasco", 0xFFBB0000, 0.0),
         new Drink("Margarita", "Tequila, Cointreau, lime juice, blended", 0xFF96E643, 0.25)
        )
      ),
      new Array( // Scene 12a
        new Dialogue("I went to his apartment to see if he was OK.")
      ),
      new Array( // Scene 12b
        new Dialogue("I went to his apartment to see if he was OK.")
      ),
      new Array( // Scene 12c
        new Dialogue("I went to his apartment to see if he was OK.")
      ),
      new Array( // Scene 16 - Lost a fight at the party
        new Dialogue("Sounds like you picked a pretty bad fight.", SP_BART),
        new DrinkSet(
         new Drink("Whiskey, Neat", "Enjoy the heat", 0xFFB46A2F, -0.25),
         new Drink("Bloody Mary", "Vodka, tomato juice, Worcestershire, Tabasco", 0xFFBB0000, 0.0),
         new Drink("Margarita", "Tequila, Cointreau, lime juice, blended", 0xFF96E643, 0.25)
        )
      ),
      new Array( // Scene 16a
        new Dialogue("I don't remember what happened right afterwards, "+
                     "but I woke up in a warehouse.")
      ),
      new Array( // Scene 16b
        new Dialogue("I don't remember what happened right afterwards, "+
                     "but I woke up in a warehouse.")
      ),
      new Array( // Scene 16c
        new Dialogue("Ha, it was nothing."),
        new Dialogue("I know those guys. It was all in good fun."),
        new Dialogue("I don't remember what happened right afterwards, "+
                     "but I woke up in a warehouse.")
      ),
      new Array( // Scene 20 - IN WHICH THE BARTENDER HAS HAD ENOUGH
        new Dialogue("Yeah, there's no more game after this point. Have another drink though.", SP_BART),
        new DrinkSet(
         new Drink("Whiskey, Neat", "Enjoy the heat", 0xFFB46A2F, -0.25),
         new Drink("Bloody Mary", "Vodka, tomato juice, Worcestershire, Tabasco", 0xFFBB0000, 0.0),
         new Drink("Margarita", "Tequila, Cointreau, lime juice, blended", 0xFF96E643, 0.25)
        )
      ),
      new Array( // Scene 20a
        new Dialogue("Sure thing. Here you go.", SP_BART)
      ),
      new Array( // Scene 20b
        new Dialogue("Sure thing. Here you go.", SP_BART)
      ),
      new Array( // Scene 20c
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

    public static function getSceneInfo(scene:Number, variant:Number):CombatScene
    {
      var info:CombatScene;
      if (scene == 0)
      {
        info = new CombatScene(CombatScene.BG_PARTY, 30, 50);
        info.addEnemy(EnemyInfo.WEAK, 100, 60, 0, new Array(
          new Array(
          new Dialogue("Have you seen Logan?", SP_PLAYER),
          new Dialogue("Who?", SP_GEN))));
        info.addEnemy(EnemyInfo.WEAK, 130, 20, 0, new Array(
          new Array(
          new Dialogue("Is Logan here?", SP_PLAYER),
          new Dialogue("Logan? Never met him.", SP_GEN))));
        info.addEnemy(EnemyInfo.WEAK, 180, 25, 0, new Array(
          new Array(
          new Dialogue("No, Logan's not here.", SP_GEN),
          new Dialogue("But I didn't ask you yet.", SP_PLAYER),
          new Dialogue("Well, then ask me again.", SP_GEN)),
          new Array(
          new Dialogue("...have you seen Logan?", SP_PLAYER),
          new Dialogue("Logan? I've never even heard that name before!", SP_GEN))));
        info.addEnemy(EnemyInfo.WEAK, 210, 80, 0, new Array(
          new Array(
          new Dialogue("Have you seen my brother?", SP_PLAYER),
          new Dialogue("Hey man, I ain't Logan's keeper.", SP_GEN))));

        return info;
      }
      else if (scene == 1)
      {
        if (variant == 0)
        {
          var info10:CombatScene = new CombatScene(CombatScene.BG_APARTMENT, 0, 80);
          info10.addEnemy(EnemyInfo.NORMAL, 260, 50, 0, new Array( new Array(
          new Dialogue("What the hell are you doing here?", Registry.SP_OTHER),
          new Dialogue("I could ask you the same question.", Registry.SP_PLAYER)
          ), new Array(
          new Dialogue("Get the hell out or I'm calling the cops.", Registry.SP_PLAYER),
          new Dialogue("Relax, I was just on my way out. I've already finished going through Logan's things.", Registry.SP_OTHER)
          ), new Array(
          new Dialogue("What did you find?", Registry.SP_PLAYER),
          new Dialogue("He bought a train ticket. Looks like my Logan decided to skip town.", Registry.SP_OTHER, -1, 1, true))));
          return info10;
        }
      }
      
      return new CombatScene(CombatScene.BG_BAR, 0, 0);
    }
  }
}
