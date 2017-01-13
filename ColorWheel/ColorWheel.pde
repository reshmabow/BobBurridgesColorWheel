import java.util.*;

BobsColorWheel bob;
Thumbnail thumbnail;
PaintingSketch paintingSketch;

void setup() {
    size(700, 700);
    colorMode(HSB, 360, 100, 100, 1.0);
    bob = new BobsColorWheelv1(180, 180);
    thumbnail = new Thumbnail(350, 50, 300, 300);
    paintingSketch = new PaintingSketch(10, 400, 680, 280);
}
void draw() {
    background(200);
    bob.draw();
    thumbnail.draw();
    paintingSketch.draw();
}
class Params
{
    static final int COLOR_LABEL_ANGLE_FREQ = 45;
    static final int GLOBAL_WHEEL_ROTATION = 180;

    public static final int FOCAL_ANGLE = 180;
    public static final int SPICE_ANGLE = 115;

    public static final int NUM_BASECOLOR_RECTS = 70;
    public static final int NUM_FOCALCOLOR_RECTS = 100;
    public static final int NUM_SPICECOLOR_RECTS = 250;
}


void keyPressed()
{
    if (key == CODED)
    {
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
        bob.setDirty();
    }
}
void keyReleased()
{
    if (key == CODED)
    {
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
    color getRandomColorVariation(color pureColor)
    {
        int hue = int(hue(pureColor) + random(0, hueVariation));
        hue = bowlimit(hue, 0, 360);

        int brightness = int(brightness(pureColor) + random(0, brightnessVariation));
        brightness = bowlimit(brightness, 0, 100);

        int saturation = int(saturation(pureColor) + random(0, saturationVariation));
        saturation = bowlimit(saturation, 0, 100);


        float alpha = alpha(pureColor) + random(0, alphaVariation);
        alpha = bowlimit(alpha, 0.0, 0.05);//0.0, 0.5

        color colorVariation = color(hue, saturation, brightness, alpha);
        return colorVariation;
    }
    public color reduceAlpha(color raw)
    {
        float a = alpha(raw);
        a -= 0.03;
        a =  bowlimit(a, 0.0, 0.5);
        return color(hue(raw), saturation(raw), brightness(raw), a);
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
    List<MyRect> baseColorRects;
    List<MyRect> focalColorRects;
    List<MyRect> spice1ColorRects;
    List<MyRect> spice2ColorRects;

    public PaintingSketch(int x, int y, int _w, int _h)
    {
        loc = new PVector(x, y);
        w = _w;
        h = _h;
        baseColorRects = new ArrayList<MyRect>();
        focalColorRects = new ArrayList<MyRect>();
        spice1ColorRects = new ArrayList<MyRect>();
        spice2ColorRects = new ArrayList<MyRect>();
    }
    private void createColorRects()
    {
        if (bob.isDirty())
        {
            createBaseColorRects();
            createFocalColorRects();
            createSecondaryFocalColorLines();
            createSpice1ColorRects();
            createSecondarySpice1ColorLines();
            createSpice2ColorRects();
            createSecondarySpice2ColorLines();
            bob.setNotDirty();
        }
    }
    private void createBaseColorRects()
    {
        baseColorRects.clear();
        baseColorRects.add(new MyRect(0, 0, w, h, bob.getBaseColor()));
        for (int i=0; i < Params.NUM_BASECOLOR_RECTS; i++)
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
    private void createFocalColorRects()
    {
        int focalMaxWidth = 80;
        int focalMaxHeight = 80;
        int focalCenterX = 2*w/3;
        int focalCenterY = h/3;

        focalColorRects.clear();
        focalColorRects.addAll(
            createClusteredColorRectsHelper(Params.NUM_FOCALCOLOR_RECTS, focalCenterX, focalCenterY, focalMaxWidth, focalMaxHeight, bob.getFocalColorVariation())
            );
    }
    private void createSpice1ColorRects()
    {
        int focalCenterX = (2*w/3)-30;
        int focalCenterY = h/3;

        int spiceMaxWidth = 20;
        int spiceMaxHeight = 20;
        spice1ColorRects.clear();
        spice1ColorRects.addAll(
            createClusteredColorRectsHelper(Params.NUM_SPICECOLOR_RECTS/2, focalCenterX, focalCenterY, spiceMaxWidth, spiceMaxHeight, bob.getSpice1ColorVariation())
            );
    }

    private void createSpice2ColorRects()
    {
        int focalCenterX = (2*w/3)+50;
        int focalCenterY = h/3;

        int spiceMaxWidth = 20;
        int spiceMaxHeight = 20;
        spice2ColorRects.clear();
        spice2ColorRects.addAll(
            createClusteredColorRectsHelper(Params.NUM_SPICECOLOR_RECTS/2, focalCenterX, focalCenterY, spiceMaxWidth, spiceMaxHeight, bob.getSpice2ColorVariation())
            );
    }
    private  List<MyRect> createColorRectsHelper(
        int numRects, 
        int maxWidth, int maxHeight, 
        color c)
    {
        List<MyRect> createdRects = new ArrayList<MyRect>();
        for (int i=0; i < numRects; i++)
        {
            int rx = int(random(w));
            int ry = int(random(h));
            int rw = int(random(min(w-rx, maxWidth)));
            int rh = int(random(min(h-ry, maxHeight)));
            MyRect mr = new MyRect(rx, ry, rw, rh, c);
            createdRects.add(mr);
        }
        return createdRects;
    }


    private void createSecondaryFocalColorLines()
    {
        int focalMaxWidth = w;
        int focalMaxHeight = 10;
        int focalCenterX = 0;
        int focalCenterY = h-(h/10);
        ColorVariater colorVariater = new ColorVariater(20, 90, 9, 0.002);
        color fc1 = colorVariater.reduceAlpha(bob.getFocalColorVariation());

        //horiz lines
        focalColorRects.addAll(
            createClusteredColorRectsHelper(Params.NUM_FOCALCOLOR_RECTS, focalCenterX, focalCenterY, focalMaxWidth, focalMaxHeight, fc1)
            );

        // vert lines
        focalMaxWidth = 10;
        focalMaxHeight = h;
        focalCenterX = 30;
        focalCenterY = w/10;
        focalColorRects.addAll(
            createClusteredColorRectsHelper(Params.NUM_FOCALCOLOR_RECTS, focalCenterX, focalCenterY, focalMaxWidth, focalMaxHeight, fc1)
            );
    }

    private void createSecondarySpice1ColorLines()
    {
        int focalMaxWidth = w;
        int focalMaxHeight = 10;
        int focalCenterX = 0;
        int focalCenterY = h-(h/10);
        ColorVariater colorVariater = new ColorVariater(20, 90, 9, 0.002);
        color sc1 = colorVariater.reduceAlpha(bob.getSpice1ColorVariation());

        //horiz lines
        spice1ColorRects.addAll(
            createClusteredColorRectsHelper(Params.NUM_SPICECOLOR_RECTS/4, focalCenterX, focalCenterY, focalMaxWidth, focalMaxHeight, sc1)
            );

        // vert lines
        focalMaxWidth = 10;
        focalMaxHeight = h;
        focalCenterX = 30;
        focalCenterY = w/10;
        spice1ColorRects.addAll(
            createClusteredColorRectsHelper(Params.NUM_SPICECOLOR_RECTS/4, focalCenterX, focalCenterY, focalMaxWidth, focalMaxHeight, sc1)
            );
    }

    private void createSecondarySpice2ColorLines()
    {
        int focalMaxWidth = w;
        int focalMaxHeight = 15;
        int focalCenterX = 0;
        int focalCenterY = h-(h/10);
        ColorVariater colorVariater = new ColorVariater(20, 90, 9, 0.002);
        color sc2 = colorVariater.reduceAlpha(bob.getSpice2ColorVariation());

        //horiz lines
        spice2ColorRects.addAll(
            createClusteredColorRectsHelper(Params.NUM_SPICECOLOR_RECTS/4, focalCenterX, focalCenterY, focalMaxWidth, focalMaxHeight, sc2)
            );

        // vert lines
        focalMaxWidth = 45;
        focalMaxHeight = h;
        focalCenterX = 30;
        focalCenterY = w/10;
        spice2ColorRects.addAll(
            createClusteredColorRectsHelper(Params.NUM_SPICECOLOR_RECTS/4, focalCenterX, focalCenterY, focalMaxWidth, focalMaxHeight, sc2)
            );
    }


    private  List<MyRect> createClusteredColorRectsHelper(
        int numRects, 
        int centerX, 
        int centerY, 
        int maxWidth, int maxHeight, 
        color c)
    {
        List<MyRect> createdRects = new ArrayList<MyRect>();
        for (int i=0; i < numRects; i++)
        {
            int rx = centerX + int(random(-20, 20));
            int ry = centerY + int(random(-40, 40));
            int rw = int(random(min(w-rx, maxWidth)));
            int rh = int(random(min(h-ry, maxHeight)));
            MyRect mr = new MyRect(rx, ry, rw, rh, c);
            createdRects.add(mr);
        }
        return createdRects;
    }

    void draw()
    {
        createColorRects();
        rectMode(CORNER);
        pushMatrix();
        translate(loc.x, loc.y);
        drawBaseColorRects();
        drawFocalColorRects();
        drawSpiceColorRects();
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
    void drawFocalColorRects()
    {
        for (MyRect r : focalColorRects)
        {
            fill(r.col);
            stroke(r.col);
            rect(r.x, r.y, r.w, r.h);
        }
    }
    void drawSpiceColorRects()
    {
        drawSpice1ColorRects();
        drawSpice2ColorRects();
    }
    void drawSpice1ColorRects()
    {
        for (MyRect r : spice1ColorRects)
        {
            fill(r.col);
            stroke(r.col);
            rect(r.x, r.y, r.w, r.h);
        }
    }
    void drawSpice2ColorRects()
    {
        for (MyRect r : spice2ColorRects)
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