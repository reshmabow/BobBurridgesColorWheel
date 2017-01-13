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
}



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

    int brightness = 70;
    int saturation = 80;

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
        for (int i=0; i <= 360; i++) {
            drawColorSegment(i);
        }
    }
    private void drawColorSegment(int segment)
    {
        color fillColor = color(segment, 100, 60, 1.0); 
        fill(fillColor); 
        stroke(fillColor); 
        pushMatrix(); 
        rotate(radians(segment+Params.GLOBAL_WHEEL_ROTATION)); 
        rect(0, 25, 5, 25); 
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