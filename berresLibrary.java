// This file contains various useful/fun/time-saving tools

public class berresLibrary
{
    // Colors - for when colored output text is desired
    public static final String ANSI_RESET = "\u001B[0m";

    public static final String ANSI_RED = "\u001B[31m";
    public static final String ANSI_GREEN = "\u001B[32m";
    public static final String ANSI_YELLOW = "\u001B[33m";
    public static final String ANSI_BLUE = "\u001B[34m";
    public static final String ANSI_PURPLE = "\u001B[35m";
    public static final String ANSI_CYAN = "\u001B[36m";
    public static final String ANSI_WHITE = "\u001B[37m";



    // Convert numbers between bases
    public static String
    baseConverter(String num, int baseSource, int baseNew)
    {
        // Parse number given with source and turn it into new base
        return Integer.toString(
                Integer.parseInt(num, baseSource), baseNew);
    }

}
