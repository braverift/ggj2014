package  
{
  import org.flixel.*;
  public class GameToBarTransition
  {
    public var talk:int;
    public var walk:int;
    public var win:int;
    public var lose:int;

    public function GameToBarTransition(talk:uint, walk:uint, win:uint, lose:uint)
    {
      this.talk = talk;
      this.walk = walk;
      this.win = win;
      this.lose = lose;
    }
  }
}
