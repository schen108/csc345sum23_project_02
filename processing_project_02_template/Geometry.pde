/*
Author: Md Moyeen Uddin
moyeen@arizona.edu

- note:
    - 

*/



class Point {
    public float x;
    public float y;
    
    Point(float x, float y) {
        this.x = x;
        this.y = y;
    }
    
    public float getX() {
        return this.x;
    }
    public float getY() {
        return this.y;
    }
    //
    public void setX(float x) {
        this.x = x;
    }
    public void setY(float y) {
        this.y = y;
    }
    //
    public String toString() {
        // return "Point(x: " + str(x) + ", y:" + str(y) + ")";
        return "(" + str(x) + ", " + str(y) + ")";
    }
}

class EndPoint extends Point implements Comparable<EndPoint> {
    private int lineId;
    private int endPointId;

        // lineId+[0 or 1].
    EndPoint(
        int lineId,
        int endPointId,
        //
        float x,
        float y
    ) {
        /*
            - desc:
                - endPointId:
                    - lineId.[0 or 1].
        */
        super(x, y);
        this.lineId = lineId;
        this.endPointId = endPointId;
    }

    public int getLineId() {
        return this.lineId;
    }

    public int getEndPointId() {
        return this.endPointId;
    }
    
    //
    @Override
    public int compareTo(EndPoint endpointR) {

        /*
            - desc:
                - if P -> Q -> R clock-wise,
                    then, P < Q
            - eg: return:
                - -1: P < Q 
                - 0: P -- Q co-linear
                - +1: P > Q
        */
        // [need to implement]

        return -1;
    }

    public String getFullIdString() {
        return str(this.lineId) + "." + str(this.endPointId);
    }
    public String toString() {
        return "eid: " + this.getFullIdString();
    }
}

class LineSegment {
    private int lineId = -1;
    private RgbColor rgbColor = lineDefaultRgbColor;
    //
    private EndPoint firstEndPoint;
    boolean isFirstEndpointBeginning = false;
    private EndPoint secondEndPoint;
    
    LineSegment() {
    }
    
    LineSegment(
        int lineId,
        EndPoint firstEndPoint,
        EndPoint secondEndPoint
    ) {
        this.lineId = lineId;
        this.firstEndPoint = firstEndPoint;
        this.secondEndPoint = secondEndPoint;
    }

    //
    public int getLineId() {
        return this.lineId;
    }
    public void setLineId(int lineId) {
        this.lineId = lineId;
    }
    
    public EndPoint getFirstEndPoint() {
        return this.firstEndPoint;
    }
    public EndPoint getSecondEndPoint() {
        return this.secondEndPoint;
    }
    public RgbColor getRgbColor() {
        return this.rgbColor;
    }
    //
    public void setRgbColor(RgbColor rgbColor) {
        this.rgbColor = rgbColor;
    }
    public void setFirstEndPoint(EndPoint firstEndPoint) {
        this.firstEndPoint = firstEndPoint;
    }
    public void setSecondEndPoint(EndPoint secondEndPoint) {
        this.secondEndPoint = secondEndPoint;
    }
    //
    public String toString() {
        // return "HorizontalLineSegment(lp: " + this.leftEndPoint.toString() + ", rp:" + this.rightEndPoint.toString() + ")";
        return "s" + str(this.getLineId());
    }
}



class HorizontalLineSegment {
    private int lineId = -1;
    private RgbColor rgbColor;
    private Point leftEndPoint;
    private Point rightEndPoint;
    
    HorizontalLineSegment() {
        this.lineId = -1;
        this.rgbColor = lineDefaultRgbColor; // default color
        this.leftEndPoint = null;
        this.rightEndPoint = null;
    }
    HorizontalLineSegment(int lineId, Point leftEndPoint, Point rightEndPoint) {
        this.lineId = lineId;
        this.rgbColor = lineDefaultRgbColor; // default color
        this.leftEndPoint = leftEndPoint;
        this.rightEndPoint = rightEndPoint;
    }
    //
    public int getLineId() {
        return this.lineId;
    }
    public void setLineId(int lineId) {
        this.lineId = lineId;
    }
    public Point getLeftEndPoint() {
        return this.leftEndPoint;
    }
    public Point getRightEndPoint() {
        return this.rightEndPoint;
    }
    public RgbColor getRgbColor() {
        return this.rgbColor;
    }
    //
    public void setRgbColor(RgbColor rgbColor) {
        this.rgbColor = rgbColor;
    }
    public void setLeftEndPoint(Point leftEndPoint) {
        this.leftEndPoint = leftEndPoint;
    }
    public void setRightEndPoint(Point rightEndPoint) {
        this.rightEndPoint = rightEndPoint;
    }
    //
    public String toString() {
        // return "HorizontalLineSegment(lp: " + this.leftEndPoint.toString() + ", rp:" + this.rightEndPoint.toString() + ")";
        return "s" + str(this.getLineId());
    }
}

// util function
int getCCWTestValue(Point pointP, Point pointQ, Point pointR) {
    /*
        - desc:
            - -1: clock-wise
            - 0: co-linear
            - 1: counter-clock-wise
        - ref:
            - https://www.geeksforgeeks.org/orientation-3-ordered-points/
    */
    Point p1 = pointP;
    Point p2 = pointQ;
    Point p3 = pointR;

    //
    int val = int(
        (p2.y - p1.y) * (p3.x - p2.x) -
        (p2.x - p1.x) * (p3.y - p2.y)
    );
      
    if (val == 0) return 0;  // collinear
        // [todo:mn] whether to further sort them based on distance from Q
            // ie: it would depend on the definition of visibility
      
    // clock or counterclock wise
    return (val > 0)? -1: 1;

}

// [begin] [checking of two intersecting line]
// ref: https://www.geeksforgeeks.org/check-if-two-given-line-segments-intersect/#
// Given three collinear points p, q, r, the function checks if
// point q lies on line segment 'pr'
static boolean onSegment(Point p, Point q, Point r)
{
    if (
        q.x <= Math.max(p.x, r.x) && q.x >= Math.min(p.x, r.x)
        &&
        q.y <= Math.max(p.y, r.y) && q.y >= Math.min(p.y, r.y)
    ) {
        return true;
    }
  
    return false;
}
  
// To find orientation of ordered triplet (p, q, r).
// The function returns following values
// 0 --> p, q and r are collinear
// 1 --> Clockwise
// 2 --> Counterclockwise
static int orientation(Point p, Point q, Point r)
{
    // See https://www.geeksforgeeks.org/orientation-3-ordered-points/
    // for details of below formula.
    float val = (q.y - p.y) * (r.x - q.x) -
            (q.x - p.x) * (r.y - q.y);
    
    val = int(val);
        // [todo:mn]
  
    if (val == 0) return 0; // collinear
  
    return (val > 0)? 1: 2; // clock or counterclock wise
}
  
// The main function that returns true if line segment 'p1q1'
// and 'p2q2' intersect.
static boolean doIntersect(Point p1, Point q1, Point p2, Point q2)
{
    // Find the four orientations needed for general and
    // special cases
    int o1 = orientation(p1, q1, p2);
    int o2 = orientation(p1, q1, q2);
    int o3 = orientation(p2, q2, p1);
    int o4 = orientation(p2, q2, q1);
  
    // General case
    if (o1 != o2 && o3 != o4)
        return true;
  
    // Special Cases
    // p1, q1 and p2 are collinear and p2 lies on segment p1q1
    if (o1 == 0 && onSegment(p1, p2, q1)) return true;
  
    // p1, q1 and q2 are collinear and q2 lies on segment p1q1
    if (o2 == 0 && onSegment(p1, q2, q1)) return true;
  
    // p2, q2 and p1 are collinear and p1 lies on segment p2q2
    if (o3 == 0 && onSegment(p2, p1, q2)) return true;
  
    // p2, q2 and q1 are collinear and q1 lies on segment p2q2
    if (o4 == 0 && onSegment(p2, q1, q2)) return true;
  
    return false; // Doesn't fall in any of the above cases
}
// [end] [checking of two intersecting line]

// public Point getFirstEndPoint.getX(),(LineSegment lineSegmentAB, LineSegment lineSegmentCD) {
//     // [todo:mn]
//     return null;
// }

// ref: http://www.java2s.com/example/java-utility-method/line-intersect/intersection-line2d-a-line2d-b-94184.html
public Point intersection(LineSegment ls_a, LineSegment ls_b) {
        float x1 = ls_a.getFirstEndPoint().getX(),
               y1 = ls_a.getFirstEndPoint().getY(),
               x2 = ls_a.getSecondEndPoint().getX(),
               y2 = ls_a.getSecondEndPoint().getY(),
               x3 = ls_b.getFirstEndPoint().getX(),
               y3 = ls_b.getFirstEndPoint().getY(),
               x4 = ls_b.getSecondEndPoint().getX(),
               y4 = ls_b.getSecondEndPoint().getY();

        float d = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
        if (d == 0) {
            return null;
        }

        float xi = ((x3 - x4) * (x1 * y2 - y1 * x2) - (x1 - x2) * (x3 * y4 - y3 * x4)) / d;
        float yi = ((y3 - y4) * (x1 * y2 - y1 * x2) - (y1 - y2) * (x3 * y4 - y3 * x4)) / d;

        return new Point(xi, yi);
}


void testAngle() {
    float x1 = 100; // Replace these values with your desired point's x and y coordinates
    float y1 = 200;

    float x2 = 300; // Replace these values with the origin point's x and y coordinates
    float y2 = 200;

    float angle = computeAngle(x1 - x2, y1 - y2);
    println("Angle between 0 and 360 degrees: " + angle);
}

// Function to compute the angle between 0 and 360 degrees
float computeAngle(float x, float y) {
    float angleRad = atan2(y, x); // Step 1: Get angle in radians between -180 and 180
    float angleDeg = degrees(angleRad); // Step 2: Convert radians to degrees

    if (angleDeg < 0) {
        angleDeg += 360; // Step 3: Map the angle to the range 0 to 360 degrees
    }

  return angleDeg;
}