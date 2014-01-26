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
    public static const SP_GIRLFRIEND:uint = 0xFFCCCCCC;     // Girlfriend's speech color
    
    public static function initialize(): void
    {
      mood = 0;
      intensity = 0;
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
    
    public static function isIntense(): Boolean
    {
      return mood <= -.25;
    }

    public static function isWhimisical(): Boolean
    {
      return mood >= .25;
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
        if (outcomes[0] == TALK) barScene = 4; // Warehouse A
        if (outcomes[0] == WALK) barScene = 8; // Apartment A
        if (outcomes[0] == WIN) barScene = 12; // Apartment B
        if (outcomes[0] == LOSE) barScene = 16; // Warehouse B
      }

      if (outcomes.length == 2) {
        if (outcomes[0] == TALK && outcomes[1] == TALK) barScene = 32;  // Skyscraper B
        if (outcomes[0] == TALK && outcomes[1] == WALK) barScene = 24;  // Park B
        if (outcomes[0] == TALK && outcomes[1] == WIN) barScene = 28;   // Train B
        if (outcomes[0] == TALK && outcomes[1] == LOSE) barScene = 36;  // Cave B
        if (outcomes[0] == WALK && outcomes[1] == TALK) barScene = 28;  // Train A
        if (outcomes[0] == WALK && outcomes[1] == WALK) barScene = 24;  // Park A
        if (outcomes[0] == WALK && outcomes[1] == WIN) barScene = 32;   // Skyscraper A
        if (outcomes[0] == WALK && outcomes[1] == LOSE) barScene = 36;  // Cave A
        if (outcomes[0] == WIN && outcomes[1] == TALK) barScene = 24;   // Park C
        if (outcomes[0] == WIN && outcomes[1] == WALK) barScene = 28;   // Train C
        if (outcomes[0] == WIN && outcomes[1] == WIN) barScene = 32;    // Skyscraper C
        if (outcomes[0] == WIN && outcomes[1] == LOSE) barScene = 36;   // Cave C
        if (outcomes[0] == LOSE && outcomes[1] == TALK) barScene = 24;  // Park D
        if (outcomes[0] == LOSE && outcomes[1] == WALK) barScene = 36;  // Cave D
        if (outcomes[0] == LOSE && outcomes[1] == WIN) barScene = 32;   // Skyscraper D
        if (outcomes[0] == LOSE && outcomes[1] == LOSE) barScene = 28;  // Train D
      }
      
      if (outcomes.length > 2) {
        barScene = 20;
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
      new Array(1, 1), // Warehouse (Party TALK)
      new Array(1, 0), // Apartment (Party WALK)
      new Array(1, 0), // Apartment (Party WIN)
      new Array(1, 1), // Warehouse (Party LOSE)
      new Array(9, 0), // DEAD FILLER STATE
      new Array(2, 0), // Park
      new Array(2, 1), // Train
      new Array(2, 2), // Skyscraper
      new Array(2, 3)  // Cave
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
         new Drink("Absinthe", "No ambiguity", 0xFF3DFB07, -0.25),
         new Drink("Gin and Tonic", "Gin, tonic water, twist of lime", 0xFFFFDDEEEE, 0.0),
         new Drink("Bellini", "Sparkling wine, peach puree", 0xFFFF9955, 0.25)
        )
      ),
      new Array( // Scene 20a
        new Dialogue("On the house.", SP_BART)
      ),
      new Array( // Scene 20b
        new Dialogue("On the house.", SP_BART)
      ),
      new Array( // Scene 20c
        new Dialogue("On the house.", SP_BART)
      ),
      new Array( // Scene 24 - Before the Park
        new Dialogue("I GUESS YOU WENT TO THE PARK NEXT", SP_BART),
        new DrinkSet(
         new Drink("Everclear", "No ambiguity", 0x77FFFFFF, -0.25),
         new Drink("Sidecar", "Cognac, Triple Sec, lemon juice", 0xFFFFAE19, 0.0),
         new Drink("Aviation", "Gin, lemon juice, maraschino, creme de violette", 0xFFD8BFD8, 0.25)
        )
      ),
      new Array( // Scene 24a
        new Dialogue("YUP")
      ),
      new Array( // Scene 24b
        new Dialogue("YUP")
      ),
      new Array( // Scene 24c
        new Dialogue("YUP")
      ),
      new Array( // Scene 28 - Before the Train
        new Dialogue("I GUESS YOU RODE A TRAIN NEXT", SP_BART),
        new DrinkSet(
         new Drink("Everclear", "No ambiguity", 0x77FFFFFF, -0.25),
         new Drink("Sidecar", "Cognac, Triple Sec, lemon juice", 0xFFFFAE19, 0.0),
         new Drink("Aviation", "Gin, lemon juice, maraschino, creme de violette", 0xFFD8BFD8, 0.25)
        )
      ),
      new Array( // Scene 28a
        new Dialogue("YUP")
      ),
      new Array( // Scene 28b
        new Dialogue("YUP")
      ),
      new Array( // Scene 28c
        new Dialogue("YUP")
      ),
      new Array( // Scene 32 - Before the Skyscraper
        new Dialogue("I GUESS YOU SCALED A SKYSCRAPER NEXT", SP_BART),
        new DrinkSet(
         new Drink("Everclear", "No ambiguity", 0x77FFFFFF, -0.25),
         new Drink("Sidecar", "Cognac, Triple Sec, lemon juice", 0xFFFFAE19, 0.0),
         new Drink("Aviation", "Gin, lemon juice, maraschino, creme de violette", 0xFFD8BFD8, 0.25)
        )
      ),
      new Array( // Scene 32a
        new Dialogue("YUP")
      ),
      new Array( // Scene 32b
        new Dialogue("YUP")
      ),
      new Array( // Scene 32c
        new Dialogue("YUP")
      ),
      new Array( // Scene 36 - Before the Cave
        new Dialogue("I GUESS YOU EXPLORED A CAVE NEXT", SP_BART),
        new DrinkSet(
         new Drink("Everclear", "No ambiguity", 0x77FFFFFF, -0.25),
         new Drink("Sidecar", "Cognac, Triple Sec, lemon juice", 0xFFFFAE19, 0.0),
         new Drink("Aviation", "Gin, lemon juice, maraschino, creme de violette", 0xFFD8BFD8, 0.25)
        )
      ),
      new Array( // Scene 36a
        new Dialogue("YUP")
      ),
      new Array( // Scene 36b
        new Dialogue("YUP")
      ),
      new Array( // Scene 36c
        new Dialogue("YUP")
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
          new Dialogue("Have you seen Logan?", SP_PLAYER, -.1, .1),
          new Dialogue("Where the hell is Logan?", SP_PLAYER, -1, -.1),
          new Dialogue("Is Logan here? Six foot two, kinda dopey looking?", SP_PLAYER, .1, 1),
          new Dialogue("Who?", SP_GEN))));
        info.addEnemy(EnemyInfo.WEAK, 130, 20, 0, new Array(
          new Array(
          new Dialogue("Logan. Where is he.", SP_PLAYER, -.1, .1),
          new Dialogue("Where the hell is Logan?", SP_PLAYER, -1, -.1),
          new Dialogue("Did Logan get here yet?", SP_PLAYER, .1, 1),
          new Dialogue("Logan? Never met him.", SP_GEN))));
        info.addEnemy(EnemyInfo.WEAK, 180, 25, 2, new Array(
          new Array(
          new Dialogue("No, Logan's not here.", SP_GEN),
          new Dialogue("..I didn't ask you yet.", SP_PLAYER, -.1, .1),
          new Dialogue("Well, then ask me again.", SP_GEN, -.1, .1),
          new Dialogue("Have you seen-- wait, what?", SP_PLAYER, .1, 1),
          new Dialogue("Nevermind.", SP_PLAYER, .1, 1),          
          new Dialogue("Spill it, punk!", SP_PLAYER, -1, -.1),
          new Dialogue("Spill-- spill what?", SP_PLAYER, -1, -.1)
          ), new Array(
          new Dialogue("You're know something. If you don't point me towards Logan, I'll point you towards my right hook.", SP_PLAYER, -.1, .1),
          new Dialogue("Well, if you see him, can you tell him to call his sister?", SP_PLAYER, .1, 1),
          new Dialogue("Tell me where he is, or I'll beat it out of you.", SP_PLAYER, -1, .1),
          new Dialogue("Logan? I've never even heard that name before!", SP_GEN))));
        info.addEnemy(EnemyInfo.WEAK, 210, 80, 3, new Array(
          new Array(
          new Dialogue("Have you seen my brother?", SP_PLAYER),
          new Dialogue("I've seen a lot of things. I've seen a lot of brothers.", SP_GEN, -.1, .1),
          new Dialogue("Hey man, I ain't Logan's keeper.", SP_GEN, .1, 1),
          new Dialogue("Get out of here, lady, this doesn't concern you.", SP_GEN, -1, -.1))));
        info.addEnemy(EnemyInfo.OTHER, 260, 30, 0, new Array(
          new Array(
          new Dialogue("Is Logan here?", SP_PLAYER),
          new Dialogue("He was here. Now he's not. Funny how it works.", SP_OTHER, -.1, .1),
          new Dialogue("Ha, what a bizzare coincidence! You just missed him.", SP_OTHER, .1, 1),
          new Dialogue("Not anymore, he's not.", SP_OTHER, -1, -.1)
          ), new Array(
          new Dialogue("How about you tell me where he went. Make things nice and easy for the both of us.", SP_PLAYER, -.1, .1),
          new Dialogue("Maybe I know, maybe I don't. Maybe there's a warehouse -- number 3 -- at the docks. Maybe you should head there alone.", SP_OTHER, -.1, .1, true),
          new Dialogue("Did he say where he was going?", SP_PLAYER, .1, 1),
          new Dialogue("Yeah, some party at Warehouse 3. He got you on the list. No plus ones.", SP_OTHER, .1, 1, true),
          new Dialogue("Tell me where he is, or Lord help me, I will burn this place to the ground.", SP_PLAYER, -1, -.1),
          new Dialogue("Easy, chief. Head on over to Warehouse 3 over by the docks -- alone -- and everything will be clear.", SP_OTHER, -1, -.1, true))));
          
        return info;
      }
      else if (scene == 1)
      {
        if (variant == 0)
        {
          var info10:CombatScene = new CombatScene(CombatScene.BG_APARTMENT, 0, 80);
          info10.addEnemy(EnemyInfo.NORMAL, 260, 50, 0, new Array( new Array(
          new Dialogue("What are you doing here?", Registry.SP_GIRLFRIEND, -.1, .1),
          new Dialogue("Um, this isn't your apartment. What are you doing here?", Registry.SP_GIRLFRIEND, .1, 1),
          new Dialogue("What the hell are you doing here?", Registry.SP_GIRLFRIEND, -1, .1),
          new Dialogue("I could ask you the same question.", Registry.SP_PLAYER)
          ), new Array(
          new Dialogue("Tell me where my brother is. Try anything funny and my friend outside will make you regret it.", Registry.SP_PLAYER, -.1, .1),
          new Dialogue("Have you seen my brother? He bailed on me last night without any explanation.", Registry.SP_PLAYER, .1, 1),
          new Dialogue("Where's Logan? If this is his blood, it's about to have company.", Registry.SP_PLAYER, -1, -.1),
          new Dialogue("Relax, I was just on my way out. I've already finished going through Logan's things.", Registry.SP_OTHER, -.1, .1),
          new Dialogue("I know the feeling. He stood me up for our date yesterday, and I haven't heard from him since.", Registry.SP_OTHER, .1, 1),
          new Dialogue("If it's any consolation, it's not. Turns out he can dish it out just as well as he can take it.", Registry.SP_OTHER, -1, -.1)
          ), new Array(
          new Dialogue("What did you find?", Registry.SP_PLAYER, -.1, .1),
          new Dialogue("He bought a train ticket. Looks like my Logan decided to skip town.", Registry.SP_OTHER, -.1, .1, true),
          new Dialogue("Have you found anything here?", Registry.SP_PLAYER, .1, 1),
          new Dialogue("He bought a train ticket. Looks like my Logan decided to skip town.", Registry.SP_OTHER, .1, 1, true),
          new Dialogue("What happened?", Registry.SP_PLAYER, -1, -.1),
          new Dialogue("Logan's incurred some debts he refuses to pay. But I'll be damned if he thinks he can just hop the next train out of town.", Registry.SP_OTHER, -1, -.1, true))));
          return info10;
        }
      }
      else if (scene == 2)
      {
        if (variant == 0) // Park
        {
          info = new CombatScene(CombatScene.BG_PARK, 0, 80);
          info.addEnemy(EnemyInfo.NORMAL, 260, 50, 0, new Array( new Array(
          new Dialogue("What the hell are you doing here?", Registry.SP_OTHER),
          new Dialogue("I could ask you the same question.", Registry.SP_PLAYER)
          ), new Array(
          new Dialogue("Get the hell out or I'm calling the cops.", Registry.SP_PLAYER),
          new Dialogue("Relax, I was just on my way out. I've already finished going through Logan's things.", Registry.SP_OTHER)
          ), new Array(
          new Dialogue("What did you find?", Registry.SP_PLAYER),
          new Dialogue("He bought a train ticket. Looks like my Logan decided to skip town.", Registry.SP_OTHER, -1, 1, true))));
          return info;
        }
      }
      
      return new CombatScene(CombatScene.BG_BAR, 0, 0);
    }
  }
}
