interface BobsColorWheel
{

    void draw();
    void movePaddlesSlow();
    void movePaddlesFast();
    void decBase();
    void incBase();
    int getBaseValue();
    boolean isDirty();
    void setDirty();
    void setNotDirty();
    color getBaseColor();
    color getBaseColorVariation();
    color getFocalColor();
    color getFocalColorVariation();
    color getSpice1Color();
    color getSpice1ColorVariation();
    color getSpice2Color();
    color getSpice2ColorVariation();
    color getColorFromAngle(int angle);
}


/**
 * This version uses Processing's native colors on the wheel.
 * This means that, for instance, a color value of 0 would map to red.
 * whilst this works, Bob Burridge uses a specific set of 10 colors for his wheel
 * and processing's native colors uses many more.
 *
 * If you are interested in a color wheel that is much closer to Bob Burridges wheel, then
 * please consider using BobsColorWheelv2
 *
 */
class BobsColorWheelv1 implements BobsColorWheel
{
    boolean movePaddlesFast;
    int paddleSlowSpeed = 2;
    int paddleFastSpeed = 25;

    PVector location; 
    int base; 

    int focalAngle = Params.FOCAL_ANGLE; 
    int focal; 

    int spiceAngle = Params.SPICE_ANGLE;
    int spice1; 
    int spice2; 

    int brightness = 00;//70
    int saturation = 00;//80

    ColorVariater baseColorVariater;
    ColorVariater focalColorVariater;
    ColorVariater spice1ColorVariater;
    ColorVariater spice2ColorVariater;

    boolean isDirty = true;


    public BobsColorWheelv1(int x, int y)
    {
        setBase(0); 
        location = new PVector(x, y);
        setFocal(base + focalAngle);
        setSpice1(base + spiceAngle);
        setSpice2(base - spiceAngle);
        movePaddlesFast = true;
        baseColorVariater = new ColorVariater(20, 90, 9, 0.002);
        focalColorVariater = new ColorVariater(10, 10, 30, 0.002);
        spice1ColorVariater = new ColorVariater(10, 10, 5, 0.2);
        spice2ColorVariater = new ColorVariater(10, 10, 5, 0.2);
    }
    boolean isDirty() {
        return isDirty;
    }
    void setDirty() {
        isDirty = true;
    }
    void setNotDirty() {
        isDirty = false;
    }

    void decBase()
    {
        int paddleSpeed = (movePaddlesFast) ? paddleFastSpeed: paddleSlowSpeed;
        int newBase = (base-paddleSpeed)%360; 
        if (newBase < 0)
        {
            newBase += 360;
        }
        setBase(newBase);
    }
    void incBase() {
        int paddleSpeed = (movePaddlesFast) ? paddleFastSpeed: paddleSlowSpeed;
        int newBase = (base+paddleSpeed)%360; 
        setBase(newBase);
    }
    void movePaddlesFast() {
        movePaddlesFast = true;
    }
    void movePaddlesSlow() {
        movePaddlesFast = false;
    }


    String toString()
    {
        return "(" + base + "," + focal + "," + spice1 + "," + spice2 + ")";
    }
    int getBaseValue() {
        return base;
    }
    color getBaseColor()
    {
        return color(base, saturation, brightness, 1.0);
    }
    color getBaseColorVariation()
    {
        return baseColorVariater.getRandomColorVariation(color(base, saturation, brightness, 1.0));
    }
    color getFocalColorVariation()
    {
        return focalColorVariater.getRandomColorVariation(color(focal, saturation, brightness, 1.0));
    }

    color getSpice1ColorVariation()
    {
        return spice1ColorVariater.getRandomColorVariation(color(spice1, saturation, brightness, 1.0));
    }
    color getSpice2ColorVariation()
    {
        return spice2ColorVariater.getRandomColorVariation(color(spice2, saturation, brightness, 1.0));
    }

    color getFocalColor()
    {
        return color(focal, saturation, brightness, 1.0);
    }
    void setFocal(int _focal)
    {
        focal = normalizeValue(_focal);
    }
    color getSpice1Color()
    {
        return color(spice1, saturation, brightness, 1.0);
    }
    color getSpice2Color()
    {
        return color(spice2, saturation, brightness, 1.0);
    }
    void setSpice1(int _spice)
    {
        spice1 = normalizeValue(_spice);
    }
    void setSpice2(int _spice)
    {
        spice2 = normalizeValue(_spice);
    }
    private int normalizeValue(int rawValue)
    {
        int normalizedValue = rawValue;
        while (normalizedValue > 360)
        {
            normalizedValue -= 360;
        }
        while (normalizedValue < 0)
        {
            normalizedValue += 360;
        }
        return normalizedValue;
    }
    void setBase(int b)
    {
        base = b; 
        setFocal(base + focalAngle); 
        setSpice1(base + spiceAngle); 
        setSpice2(base - spiceAngle);
    }

    void draw() {
        rectMode(CENTER);
        pushMatrix();
        translate(location.x, location.y); 
        drawColorWheel();
        drawFocalColorPaddle();
        drawSpice1ColorPaddle();
        drawSpice2ColorPaddle();
        popMatrix();
    }
    private void drawColorWheel()
    {
        for (int i=0; i < 360; i++) {
            drawColorSegment(i);
        }
    }
    color getColorFromAngle(int angle)
    {
        return color(angle, 100, 60, 1.0);
    }
    private void drawColorSegment(int segment)
    {
        color fillColor = getColorFromAngle(segment); // TODO bow this needs to call a method to do a color lookup
        fill(fillColor); 
        stroke(fillColor); 
        pushMatrix(); 
        rotate(radians(segment+Params.GLOBAL_WHEEL_ROTATION)); 
        rect(0, 25, 5, 40); 
        drawBaseColorPaddle(segment);
        drawColorValueText(segment);
        popMatrix();
    }
    void drawBaseColorPaddle(int segment)
    {
        if (bob.getBaseValue() == segment)
        {
            rect(0, 100, 45, 12);
        }
    }

    void drawFocalColorPaddle()
    {
        drawPaddle(focal+Params.GLOBAL_WHEEL_ROTATION, getFocalColor(), 30);
    }

    void drawSpice1ColorPaddle()
    {
        drawPaddle(spice1+Params.GLOBAL_WHEEL_ROTATION, getSpice1Color(), 15);
    }
    void drawSpice2ColorPaddle()
    {
        drawPaddle(spice2+Params.GLOBAL_WHEEL_ROTATION, getSpice2Color(), 15);
    }

    private void drawPaddle(int angle, color col, int paddleWidth)
    {
        pushMatrix();
        rotate(radians(angle));
        fill(col);
        stroke(col);
        rect(0, 90, paddleWidth, 5);
        popMatrix();
    }
    void drawColorValueText(int segment)
    {
        if (segment%Params.COLOR_LABEL_ANGLE_FREQ == 0)
        { 
            fill(0);
            stroke(0);
            textSize(16);
            text(segment, 0, 80);
        }
    }
}








/**
 * This version of the color wheel uses a specific set of 10 colors
 * distributed around the color wheel.
 * The resulting schemes should match more closely the "real" color wheel.
 *
 * Also note: this version can be extended to put any 10 colors around the wheel
 * allowing us to experiment with other color combinations.
 */
class BobsColorWheelv2 extends BobsColorWheelv1
{
    List<Integer> colorSlots;
    int[] colorLookup;

    public BobsColorWheelv2(int x, int y)
    {
        super(x, y);
        createColorWheel();
    }

    void createColorWheel()
    {
        colorSlots = new ArrayList<Integer>();
        colorLookup = new int[360];


        color red = color(0, 89, 82, 1.0);// 235 25 25
        color orange = color(38, 92, 84, 1.0);// 240 160 19
        color yellow = color(59, 78, 82, 1.0);// 236 232 50
        color lightGreen = color(134, 84, 62, 1.0);// 58 160 77
        color green = color(153, 88, 42, 1.0);//  12 108 64
        color blueGreen = color(206, 93, 55, 1.0);// 10 85 142
        color skyBlue = color(217, 90, 61, 1.0);// 15 69 156
        color darkBlue = color(231, 77, 45, 1.0);// 26 40 115
        color lightPurple = color(326, 100, 73, 1.0);// 212 0 119? light purple
        color darkPurple = color(237, 85, 33, 1.0);// 215 20 40

        addColorsToSlots(
            red, 
            orange, 
            yellow, 
            lightGreen, 
            green, 
            blueGreen, 
            skyBlue, 
            darkBlue, 
            darkPurple, 
            lightPurple);
    }
    private void addColorsToSlots(color ... col)
    {
        int numColors = howManyColors(col);
        int angleSizePerColor = 360/numColors;
        int angle = 0;
        for (color c : col)
        {
            addColorToSlot(angle, angle+angleSizePerColor, c); 
            angle += angleSizePerColor;
        }
    }
    private int howManyColors(color ... col)
    {
        int numColors = 0;
        for (color c : col)
        {
            numColors++;
        }
        return numColors;
    }
    private void  addColorToSlot(int startAngle, int endAngle, color c)
    {
        colorSlots.add(c);
        int colorIndex = colorSlots.size()-1;
        for (int i=startAngle; i < endAngle; i++)
        {
            colorLookup[i] = colorIndex;
        }
    }

    @Override color getColorFromAngle(int angle)
    {
        return lookupColor(angle);
    }
    @Override color getBaseColor()
    {
        return  lookupColor(base);
    }
    @Override color getFocalColor()
    {
        return  lookupColor(focal);
    }
    @Override color getSpice1Color()
    {
        return  lookupColor(spice1);
    }
    @Override color getSpice2Color()
    {
        return  lookupColor(spice2);
    }

    @Override color getBaseColorVariation()
    {
        return baseColorVariater.getRandomColorVariation(getBaseColor());
    }
    @Override color getFocalColorVariation()
    {
        return focalColorVariater.getRandomColorVariation(getFocalColor());
    }

    @Override color getSpice1ColorVariation()
    {
        return spice1ColorVariater.getRandomColorVariation(getSpice1Color());
    }
    @Override color getSpice2ColorVariation()
    {
        return spice2ColorVariater.getRandomColorVariation(getSpice2Color());
    }

    private color lookupColor(int index)
    {
        return colorSlots.get(colorLookup[index]);
    }
}