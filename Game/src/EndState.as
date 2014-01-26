package  
{
  import org.flixel.*;
  import flash.utils.*;
  public class EndState extends FlxState
  {
    [Embed(source = "../data/art/bg_exterior_intense.png")] private var exteriorIntense:Class;
    [Embed(source = "../data/art/bg_exterior_noir.png")] private var exteriorNoir:Class;
    [Embed(source = "../data/art/bg_exterior_whimsical.png")] private var exteriorWhimsical:Class;
    [Embed(source = "../data/art/bar_last_call.png")] private var barLastCall:Class;
    [Embed(source = "../data/art/bar_chub_pug.png")] private var barChubPug:Class;
    [Embed(source = "../data/art/bar_soldier.png")] private var barSoldier:Class;
    [Embed(source = "../data/art/bar_risky_sours.png")] private var barRiskySours:Class;
    
    private static const TIME_PER_CHAR:Number = 0.08; // Time per character of text in seconds
    private static const TIME_AT_END:Number = 1.0; // Length of pause after each line in seconds
    private static const DIAG_X:Number = 30;
    private static const DIAG_Y:Number = 190;
    private static const DIAG_W:Number = 260;
    private static const DIAG_H:Number = 34;
    private static const DIAG_B:Number = 2;

    private static var diagBox:FlxText;
    private static var diagBackSprite:FlxSprite;
    private static var sceneIdx:uint;
    private static var sceneArray:Array; 
    private static var diagTime:Number; // Time current line of dialogue has been displayed
    private static var curDiag:Dialogue;
  
    private static var fading:Boolean;

    private static const PLAYER_X:Number = 64;
    private static const PLAYER_Y:Number = 86;
    private static var playerSprite:PlayerStill;

    override public function create():void
    {    
      if (Registry.isWhimisical()) add(new FlxSprite(0, 0, exteriorWhimsical));
      else if (Registry.isIntense()) add(new FlxSprite(0, 0, exteriorIntense));
      else add(new FlxSprite(0, 0, exteriorNoir));

      if (Registry.endSceneType == Registry.YOU_DEAD) {
        add(new FlxSprite(0, 0, barLastCall));
        curDiag = new Dialogue("I hope he'll be OK.                                                       "+
                               "I'll be watching.                        ");
      }
      if (Registry.endSceneType == Registry.BRO_DEAD) {
        add(new FlxSprite(0, 0, barSoldier));
        curDiag = new Dialogue("I tried my best, but I couldn't save him.                                 ");
      }
      if (Registry.endSceneType == Registry.BRO_LOST) {
        add(new FlxSprite(0, 0, barChubPug));
        curDiag = new Dialogue("I don't know where he is now.                                             "+
                               "I hope he's safe.                 ");
      }
      if (Registry.endSceneType == Registry.BRO_SAFE) {
        add(new FlxSprite(0, 0, barRiskySours));
        curDiag = new Dialogue("It was a hell of a ride. I'm just glad he's OK.                           ");
      }
    
      playerSprite = new PlayerStill(PLAYER_X, PLAYER_Y);
      add(playerSprite);

      sceneIdx = 0;
      diagBox = new FlxText(DIAG_X, DIAG_Y, DIAG_W);
      diagBackSprite = new FlxSprite(DIAG_X-DIAG_B, DIAG_Y-DIAG_B);
      diagBackSprite.makeGraphic(DIAG_W + 2*DIAG_B, DIAG_H + 2*DIAG_B, 0x55000000);
      add(diagBackSprite);
      add(diagBox);

      diagTime = 0;

      fading = true;
      FlxG.flash(0xFF000000, 5, function():void {fading=false;});
    }
    
    override public function update():void
    {
      // Dialogue
      if (!fading) {
        diagTime += FlxG.elapsed;
        var charsToShow:Number = diagTime / TIME_PER_CHAR;
        diagBackSprite.visible = true;
        diagBox.text = curDiag.text.substr(0, charsToShow);
        diagBox.color = curDiag.color;
        diagBox.shadow = Utility.darkerize(curDiag.color);
      }
      
      super.update();

      // Auto advance text
      if (diagTime > curDiag.text.length*TIME_PER_CHAR + TIME_AT_END)
      {
        fading = true;
        FlxG.fade(0xFF000000, 2.0, function():void {
          Registry.initialize();
          FlxG.switchState(new TitleState()); 
        });
      }
    }
  }
}
