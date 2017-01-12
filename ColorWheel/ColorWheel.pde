BobsColorWheel bob;
Thumbnail thumbnail;

void setup() {
    size(700, 700);
    colorMode(HSB, 360, 100, 100, 1.0);
    bob = new BobsColorWheel(180, 180);
    thumbnail = new Thumbnail(350, 50, 300, 300);
}
void draw() {
    background(200);
    bob.draw();
    thumbnail.draw();
}



void keyPressed()
{
    if (key == ',')
    {
        bob.decBase();
    } else if (key == '.')
    {
        bob.incBase();
    }
}

void logln(int msg)
{
    System.out.println(msg);
}
void logln(String msg)
{
    System.out.println(msg);
}
void logl(String msg)
{   
    System.out.print(msg + " ");
}

class Thumbnail
{
    PVector location;
    int w;
    int h;
    int focalX;
    int focalY;
    int focalWidth;
    int focalHeight;
    int spiceX;
    int spiceY;
    int spiceWidth;
    int spiceHeight;

    public Thumbnail(int x, int y, int _w, int _h)
    {
        location = new PVector(x, y);
        w = _w;
        h = _h;
        focalWidth = w/5;
        focalHeight = w/5;
        focalX = w/3;
        focalY = h/3;
        spiceWidth = w/20;
        spiceHeight = focalHeight/2;
        spiceX = focalX-spiceWidth;
        spiceY = focalY;
    }
    void draw()
    {
        rectMode(CORNER);
        drawBaseColor();
        drawFocalColor();
        drawSpiceColors();
    }

    private void drawBaseColor()
    {
        color baseColor = bob.getBaseColor();
        fill(baseColor);
        stroke(baseColor);
        translate(location.x, location.y);
        rect(0, 0, w, h);
    }
    private void drawFocalColor()
    {
        color focalColor = bob.getFocalColor();
        fill(focalColor);
        stroke(focalColor);
        rect(focalX, focalY, focalWidth, focalHeight);
    }
    private void drawSpiceColors()
    {
        color spiceColor1 = bob.getSpice1Color();
        fill(spiceColor1);
        stroke(spiceColor1);
        translate(spiceX, spiceY);
        rect(0, 0, spiceWidth, spiceHeight);

        color spiceColor2 = bob.getSpice2Color();
        fill(spiceColor2);
        stroke(spiceColor2);
        translate(0, spiceHeight);
        rect(0, 0, spiceWidth, spiceHeight);
    }
}

class BobsColorWheel
{
    int paddleSpeed = 5;
    PVector location; 
    int base; 

    int focalAngle = 180; 
    int focal; 

    int spiceAngle = 115; 
    int spice1; 
    int spice2; 

    int brightness = 70;
    int saturation = 80;

    public BobsColorWheel(int x, int y)
    {
        setBase(0); 
        location = new PVector(x, y);
        setFocal(base + focalAngle);
        setSpice1(base + spiceAngle);
        setSpice2(base - spiceAngle);
    }

    void decBase()
    {
        int newBase = (base-paddleSpeed)%360; 
        if (newBase < 0)
        {
            newBase += 360;
        }
        setBase(newBase);
    }
    void incBase() {
        int newBase = (base+paddleSpeed)%360; 
        setBase(newBase);
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
        for (int i=0; i <= 360; i++) {
            drawColorSegment(i);
        }
        drawFocalColorPaddle();
        drawSpice1ColorPaddle();
        drawSpice2ColorPaddle();
        popMatrix();
    }
    private void drawColorSegment(int segment)
    {
        color fillColor = color(segment, 100, 60, 1.0); 
        fill(fillColor); 
        stroke(fillColor); 
        pushMatrix(); 
        rotate(radians(segment+180)); 
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
        drawPaddle(focal+180, getFocalColor(), 30);
    }

    void drawSpice1ColorPaddle()
    {
        drawPaddle(spice1+180, getSpice1Color(), 15);
    }
    void drawSpice2ColorPaddle()
    {
        drawPaddle(spice2+180, getSpice2Color(), 15);
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
        if (segment%45 == 0)
        { 
            fill(0);
            stroke(0);
            textSize(16);
            text(segment, 0, 80);
        }
    }
}