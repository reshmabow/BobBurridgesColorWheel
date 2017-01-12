import java.util.*;

BobsColorWheel bob;
Thumbnail thumbnail;
PaintingSketch paintingSketch;

void setup() {
    size(700, 700);
    colorMode(HSB, 360, 100, 100, 1.0);
    bob = new BobsColorWheel(180, 180);
    thumbnail = new Thumbnail(350, 50, 300, 300);
    paintingSketch = new PaintingSketch(10, 400, 680, 280);
}
void draw() {
    background(200);
    bob.draw();
    thumbnail.draw();
    paintingSketch.draw();
}



void keyPressed()
{
    if (key == CODED)
    {
        logln(keyCode);
        if (keyCode == SHIFT)
        {
            bob.movePaddlesSlow();
        }
        if (keyCode == LEFT)
        {
            bob.decBase();
        } 
        if (keyCode == RIGHT)
        {
            bob.incBase();
        }
    }
}
void keyReleased()
{
    if (key == CODED)
    {
        logln(keyCode);
        if (keyCode == SHIFT)
        {
            bob.movePaddlesFast();
        }
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
        pushMatrix();
        drawBaseColor();
        drawFocalColor();
        drawSpiceColors();
        popMatrix();
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
    boolean movePaddlesFast;
    int paddleSlowSpeed = 2;
    int paddleFastSpeed = 25;

    PVector location; 
    int base; 

    int focalAngle = 180; 
    int focal; 

    int spiceAngle = 115; 
    int spice1; 
    int spice2; 

    int brightness = 70;
    int saturation = 80;

    static final int COLOR_LABEL_ANGLE_FREQ = 45;
    static final int GLOBAL_WHEEL_ROTATION = 180;

    ColorVariater baseColorVariater;

    public BobsColorWheel(int x, int y)
    {
        setBase(0); 
        location = new PVector(x, y);
        setFocal(base + focalAngle);
        setSpice1(base + spiceAngle);
        setSpice2(base - spiceAngle);
        movePaddlesFast = true;
        baseColorVariater = new ColorVariater(20, 0, 0, 0.002);
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
        rotate(radians(segment+GLOBAL_WHEEL_ROTATION)); 
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
        drawPaddle(focal+GLOBAL_WHEEL_ROTATION, getFocalColor(), 30);
    }

    void drawSpice1ColorPaddle()
    {
        drawPaddle(spice1+GLOBAL_WHEEL_ROTATION, getSpice1Color(), 15);
    }
    void drawSpice2ColorPaddle()
    {
        drawPaddle(spice2+GLOBAL_WHEEL_ROTATION, getSpice2Color(), 15);
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
        if (segment%COLOR_LABEL_ANGLE_FREQ == 0)
        { 
            fill(0);
            stroke(0);
            textSize(16);
            text(segment, 0, 80);
        }
    }
}

class ColorVariater
{
    int hueVariation;
    int brightnessVariation; 
    int saturationVariation;
    float alphaVariation;

    public ColorVariater(int _hueVariation, int _brightnessVariation, int _saturationVariation, float _alphaVariation)
    {
        hueVariation = _hueVariation;
        brightnessVariation = _brightnessVariation;
        saturationVariation = _saturationVariation;
        alphaVariation = _alphaVariation;
    }
    color getRandomColorVariation(color baseColor)
    {
        //int hueVariation = 0;
        int hue = int(hue(baseColor) + random(0, hueVariation));
        hue = bowlimit(hue, 0, 360);

        //int brightnessVariation = 0;
        int brightness = int(brightness(baseColor) + random(0, brightnessVariation));
        brightness = bowlimit(brightness, 0, 100);

        //int saturationVariation = 0;
        int saturation = int(saturation(baseColor) + random(0, saturationVariation));
        saturation = bowlimit(saturation, 0, 100);

        //float alphaVariation = 0.002;
        float alpha = alpha(baseColor) + random(0, alphaVariation);
        alpha = bowlimit(alpha, 0.0, 0.5);

        color colorVariation = color(hue, saturation, brightness, alpha);
        return colorVariation;
    }
    int bowlimit(int raw, int low, int hi)
    {
        if (raw < low)
        {
            return low;
        }
        if (raw > hi)
        {
            return hi;
        }
        return raw;
    }
    float bowlimit(float raw, float low, float hi)
    {
        if (raw < low)
        {
            return low;
        }
        if (raw > hi)
        {
            return hi;
        }
        return raw;
    }
}

class PaintingSketch
{
    PVector loc;
    int w;
    int h;
    public static final int NUM_BASECOLOR_RECTS = 20;
    List<MyRect> baseColorRects;

    public PaintingSketch(int x, int y, int _w, int _h)
    {
        loc = new PVector(x, y);
        w = _w;
        h = _h;
        baseColorRects = new ArrayList<MyRect>();
        createBaseColorRects();
    }
    private void createBaseColorRects()
    {
        baseColorRects.add(new MyRect(0, 0, w, h, 120));
        for (int i=0; i < NUM_BASECOLOR_RECTS; i++)
        {
            int rx = int(random(w));
            int ry = int(random(h));
            int rw = int(random(w-rx));
            int rh = int(random(h-ry));
            int rc = bob.getBaseColorVariation();
            MyRect mr = new MyRect(rx, ry, rw, rh, rc);
            baseColorRects.add(mr);
        }
    }
    void draw()
    {
        rectMode(CORNER);
        pushMatrix();
        translate(loc.x, loc.y);
        drawBaseColorRects();
        popMatrix();
    }
    void drawBaseColorRects()
    {
        for (MyRect r : baseColorRects)
        {
            fill(r.col);
            stroke(r.col);
            rect(r.x, r.y, r.w, r.h);
        }
    }
}

class MyRect
{
    int x, y, w, h;
    color col;
    public MyRect(int _x, int _y, int _w, int _h, int _col)
    {
        x=_x;
        y=_y;
        w=_w;
        h=_h;
        col=_col;
    }
}