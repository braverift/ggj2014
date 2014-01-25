package  
{
  import org.flixel.*;
  public class DrinkSet
  {
    public var drinks:Array;

    public function DrinkSet(drink1:Drink, drink2:Drink, drink3:Drink)
    {
      this.drinks = new Array(drink1, drink2, drink3);
    }
  }

}
