package  
{
  import org.flixel.*;
  public class Utility
  {
    public static function darkerize(color:uint):uint
    {
      var r:uint = (color >> 16) & 0xFF;
      var g:uint = (color >> 8) & 0xFF;
      var b:uint = color & 0xFF;

      r *= 0.5;
      g *= 0.5;
      b *= 0.5;

      return 0xFF000000 | (r << 16) | (g << 8) | b;
    }
  }

}
