/*
Author: Md Moyeen Uddin
moyeen@arizona.edu
*/

// Global variables (fixed)
int WINDOW_SIDE_LEN = 1024;
//
// int DRAW_DELAY_AMOUNT = 0; //0s
int DRAW_DELAY_AMOUNT = 100; //100ms
// int DRAW_DELAY_AMOUNT = 1000; //1s
int DRAW_DELAY_AMOUNT_FOR_ANIMATION = 1000; //1s
//
float EPS = 0.07; // [note] change if needed
int CUSTOM_SCALE_FACTOR = 3 * 10;
//float CUSTOM_SCALE_FACTOR_PERCENTAGE = 10.0;


// Global variables loaded from input file
int h = -1;
int grid_side_length = -1;

ArrayList<String> queryStringsList = new ArrayList<String>();

// global variables
PrintWriter output;
VisibilityChecker visibilityChecker = new VisibilityChecker();
//
ArrayList<LineSegment> inputLSList = new ArrayList<LineSegment>();
ArrayList<EndPoint> allEndPointsList = new ArrayList<EndPoint>();
//
Set<Integer> currentLineIdsSet = new HashSet();

// runtime temp variables
Point currentQueryPointQ = null;
LineSegment armLineSegment = null;
List<EndPoint> currentVisibleEndPoints = null;

String currentStatusBarTextLine1 = DEFAULT_STATUS_BAR_TEXT_LINE_1;
String currentStatusBarTextLine2 = DEFAULT_STATUS_BAR_TEXT_LINE_2;

// animation mode
boolean isDrawnTempCircleOnMouseClickPosition = false;
int savedMouseX, savedMouseY;
HorizontalLineSegment hlsFromMouseClick = null;
//
int MODE_R_MOUSE_CLICK_COUNT = 0;
Point clickedBottomLeftPoint;
Point clickedTopRightPoint;
int MODE_I_MOUSE_CLICK_COUNT = 0;
Point clickedFirstPointOfLineSegment;
Point clickedSecondPointOfLineSegment;
// ArrayList<Rectangle> toBeAnimatedRectList = new ArrayList();

void settings() {
    //fullScreen();
    size(WINDOW_SIDE_LEN, WINDOW_SIDE_LEN);
    
    customInitialization();
}

void customInitialization() {
    // task: create a new output log file in the sketch directory
    output = createWriter("output.txt");
    // output.println("test output");
    
    FLAG_IS_INPUT_FILE_LOADED = false;
}

void finputFileSelected(File selection) {
    if (selection == null) {
        println("Window was closed or the user hit cancel.");
    } else {
        println("User selected " + selection.getAbsolutePath());
    }
    // task: read the input file
    //     read FULL file line by line and save the queries for offline processing
    readInputFile(selection);

    FLAG_IS_INPUT_FILE_LOADED = true;
    
    fsetup();
}

void fsetup() {
    
    // setting a default value for h
    h = int(DEFAULT_H_VALUE);
    grid_side_length = int(pow(2.0, h * 1.0));
    
    // task: build qaud tree
    
    // task: process the queries from input file
    processQueries();    
}

void setup() {
    // task: choose an input file
    //     [todo:mn] uncomment
    // selectInput("Select an input file to process:", "finputFileSelected");
    
    // [todo:mn] comment out
    finputFileSelected(null);
}

void draw() {
    if (!FLAG_IS_INPUT_FILE_LOADED) {
        return;
    }
    customDraw();
    output.flush();
}

void customDraw() {
    //
    background(255, 255, 255);
    
    // task: refresh some gui variables
    refreshGuiVariables();

    // task: draw the status bar
    drawStatusBar();
    
    // task: drawing the 2^h x 2^h grid
    draw2dGrid();
    
    // task: clear color of ALL inserted lines
    // to be able to re-color them as needed
    // clearLineColors();
    
    
    // task: update quad tree retrieve graphics data
    // updateQuadTreeRelatedGraphicsData();
    
    // // task: draw all the rectangles corresponding to various quad tree regions
    // drawAllQTRectangles();
    //     // [todo:mn] comment out the above
    
    // task: draw and color all the hls ever inserted
    drawLSs();
    
    // task: draw the arm segment (from q to the right)
    drawTheArmSegment();
    
    
    // task: draw current query point if any
    drawCurrentQueryPoint();
    
    // task: draw current visible points from the query point if any
    drawLinesFromQtoCurrentVisilePoints();

    //
    if (mousePressed) {
        ellipse(
            mouseX,
            mouseY,
            s(CUSTOM_DIAMATER_OF_CIRCLE_DRAWN_AROUND_MOUSE_CLICK),
            s(CUSTOM_DIAMATER_OF_CIRCLE_DRAWN_AROUND_MOUSE_CLICK)
       );
    }

    // task: animate report() touched qt node rectangles
    if (CUR_ANIMATION_MODE == 1) {
        // toBeAnimatedRectList should be filled up by now
        // showReportAnimation();
    }

    //
    drawAllEndPoints();
    
    
    delay(DRAW_DELAY_AMOUNT);
    output.flush();
}

void refreshGuiVariables() {
    // if(CUR_ANIMATION_MODE == 0) {
    //     currentStatusBarTextLine1 = ANIMATION_MODE_OFF_TEXT;
    // } else if(CUR_ANIMATION_MODE == 1) {
    //     currentStatusBarTextLine1 = ANIMATION_MODE_ON_TEXT;
    // }
    //
    currentStatusBarTextLine1 = "";
}

// void updateQuadTreeRelatedGraphicsData() {
//     currentRectList = qt.getAllRegionRectangles();
//     // output.println("currentRectList.size(): " + currentRectList.size());
    
//     currentLineIdsSet = qt.getAllLineSegmentIds();
//     // output.println("currentLineIdsSet.size(): " + currentLineIdsSet.size());
// }

void drawStatusBar() {
    textAlign(LEFT, BOTTOM);
    text(
        // currentStatusBarTextLine1 + ", " + currentStatusBarTextLine2,
        currentStatusBarTextLine2,
        s(0),
        s(grid_side_length)
       );
}
//void updateStatusBarText(String statusBarText) {
//    currentStatusBarText = statusBarText;
//}

void clearLineColors() {
    // RgbColor defaultRgbColor = new RgbColor();
    for (LineSegment lineSegment : inputLSList) {
        lineSegment.setRgbColor(lineDefaultRgbColor);
    }
}

void draw2dGrid() {
    stroke(0); // black
    strokeWeight(s(CUSTOM_GRID_THICKNESS));
    
    for (int row = 0; row < grid_side_length; row++) {
        line(s(0), s(row), s(grid_side_length - 1), s(row));
    }
    for (int col = 0; col < grid_side_length; col++) {
        line(s(col), s(0), s(col), s(grid_side_length - 1));
    }
    // strokeWeight(0);
}

int animatedRectIdx = 0;

void drawAllEndPoints() {
    for(EndPoint ep : allEndPointsList) {
        drawSingleEndPoint(ep);
    }
}

void drawSingleEndPoint(EndPoint ep) {

    strokeWeight(s(CUSTOM_ENDPOINT_THICKNESS));


    fill(
        endPointDefaultRgbColor.getR(),
        endPointDefaultRgbColor.getG(),
        endPointDefaultRgbColor.getB()
    );

    ellipse(
            s(ep.getX()),
            s(ep.getY()),
            s(CUSTOM_DIAMATER_OF_CIRCLE_DRAWN_AROUND_LINE_ENDPOINT),
            s(CUSTOM_DIAMATER_OF_CIRCLE_DRAWN_AROUND_LINE_ENDPOINT)
    );

    fill(
        endPointIdTextDefaultRgbColor.getR(),
        endPointIdTextDefaultRgbColor.getG(),
        endPointIdTextDefaultRgbColor.getB()
    );
    // also, marking it as eg: "10.1" (ie: s10, 2nd endpoint)
    text(
        ep.getFullIdString(),
        s(ep.getX() + 6*EPS),
        s(ep.getY() - 6*EPS)
       );
}

void drawCurrentQueryPoint() {
    if(currentQueryPointQ == null) {
        return;
    }


    strokeWeight(s(CUSTOM_QUERY_POINT_THICKNESS));


    stroke(
        pointQDefaultRgbColor.getR(),
        pointQDefaultRgbColor.getG(),
        pointQDefaultRgbColor.getB()
    );

    ellipse(
            s(currentQueryPointQ.getX()),
            s(currentQueryPointQ.getY()),
            s(CUSTOM_DIAMATER_OF_CIRCLE_DRAWN_AROUND_MOUSE_CLICK),
            s(CUSTOM_DIAMATER_OF_CIRCLE_DRAWN_AROUND_MOUSE_CLICK)
    );

    // also, marking it as Q
    text(
        "Q",
        s(currentQueryPointQ.getX() + EPS),
        s(currentQueryPointQ.getY() - EPS)
       );
}

void drawLinesFromQtoCurrentVisilePoints() {
    if(currentQueryPointQ == null || currentVisibleEndPoints == null) {
        return;
    }

    strokeWeight(s(CUSTOM_LINE_THICKNESS));
    
    for (EndPoint visibleEndPoint : currentVisibleEndPoints) {
        if (visibleEndPoint == null) {
            println("visibleEndPoint == null");
            exit();
        } else {
            // println(lineSegment.toString());
        }
        
        // println("" + lineSegment.getLineId());
        
        // task: get the assigned color for this HLS drawing
        RgbColor rgbColor = blueRgbColor;
        float r = rgbColor.getR();
        float g = rgbColor.getG();
        float b = rgbColor.getB();
        stroke(r, g, b);
        
        
        // task: draw 1 line
        line(
            s(currentQueryPointQ.getX()), s(currentQueryPointQ.getY()),  
            s(visibleEndPoint.getX()), s(visibleEndPoint.getY())
           );
    }
}

void drawTheArmSegment() {
    strokeWeight(s(CUSTOM_LINE_THICKNESS));

    // task: get the assigned color for this HLS drawing
    RgbColor rgbColor = armLineSegmentDefaultRgbColor;
    float r = rgbColor.getR();
    float g = rgbColor.getG();
    float b = rgbColor.getB();
    stroke(r, g, b);
    
    // task: draw the arm line segment
    line(
        s(armLineSegment.getFirstEndPoint().getX()), s(armLineSegment.getFirstEndPoint().getY()),
        s(armLineSegment.getSecondEndPoint().getX()), s(armLineSegment.getSecondEndPoint().getY())
    );
        
    // task: draw/write the line id beside the line (eg: "s1")
    textSize(s(CUSTOM_DEFAULT_TEXT_SIZE));
    // text color
    fill(lineIdTextRgbColor.getR(), lineIdTextRgbColor.getG(), lineIdTextRgbColor.getB()); // brown
    text(
        "s" + armLineSegment.getLineId(),
        s(armLineSegment.getFirstEndPoint().getX()), s(armLineSegment.getSecondEndPoint().getY())
    );
}

void drawLSs() {
    strokeWeight(s(CUSTOM_LINE_THICKNESS));
    
    for (LineSegment lineSegment : inputLSList) {
        if (lineSegment == null) {
            println("lineSegment == null");
            exit();
        } else {
            // println(lineSegment.toString());
        }
        
        // println("" + lineSegment.getLineId());
        
        // task: get the assigned color for this HLS drawing
        RgbColor rgbColor = lineSegment.getRgbColor();
        float r = rgbColor.getR();
        float g = rgbColor.getG();
        float b = rgbColor.getB();
        stroke(r, g, b);
        
        
        // task: draw 1 line
        line(
            s(lineSegment.getFirstEndPoint().getX()), s(lineSegment.getFirstEndPoint().getY()),  
            s(lineSegment.getSecondEndPoint().getX()), s(lineSegment.getSecondEndPoint().getY())
           );
        
        // task: draw/write the line id beside the line (eg: "s1")
        textSize(s(CUSTOM_DEFAULT_TEXT_SIZE));
        // text color
        fill(lineIdTextRgbColor.getR(), lineIdTextRgbColor.getG(), lineIdTextRgbColor.getB()); // brown
        text(
            "s" + lineSegment.getLineId(),
            s(lineSegment.getFirstEndPoint().getX() + 15*EPS),
            s(lineSegment.getFirstEndPoint().getY() + 15*EPS)
        );
    }
}

void readInputFile(File file) {
    String filePath = "./input.txt"; // default
    if (file != null) {
        // task: read the selected input file
        filePath = file.getAbsolutePath();
    }
    // output.println("filePath: " + filePath);
    
    // task: reading the default input file
    String[] lines = loadStrings(filePath);
    // println("there are " + lines.length + " lines");
    for (int i = 0; i < lines.length; i++) {
        // output.println("q: " + lines[i]);
        String str = lines[i];
        queryStringsList.add(str);
    }
    output.flush();
}

//
float s(float x) {
    return x * CUSTOM_SCALE_FACTOR;
}
int sr(int x) {
    // s() reversed
    return(int)(x / CUSTOM_SCALE_FACTOR);
}

void processQueries() {
    output.println("processQueries(): ");

    int lineId = 0;
    for (int qid = 0; qid < queryStringsList.size(); qid++) {
        String str = queryStringsList.get(qid);
        
        // process the query
        if (str.charAt(0) == '%') {
            output.println("q: " + str);
            output.flush();
            continue;
        }
        
        if (str.charAt(0) == 'i') {
            output.println("q: " + str);
            output.flush();
            
            str = str.substring(2);
            
            int[] nums = int(split(str, ' '));
            int x1 = nums[0];
            int y1 = nums[1];
            int x2 = nums[2];
            int y2 = nums[3];
            
            EndPoint firstEndPoint = new EndPoint(inputLSList.size(), 0, x1, y1);
            EndPoint secondEndPoint = new EndPoint(inputLSList.size(), 1, x2, y2);
            
            //
            allEndPointsList.add(firstEndPoint);
            allEndPointsList.add(secondEndPoint);
            
            LineSegment lineSegment = new LineSegment(
                inputLSList.size(),
                firstEndPoint,
                secondEndPoint
            );
            //
            inputLSList.add(lineSegment);
            lineId += 1;

            // visibilityChecker.setInputEndpointsList(allEndPointsList);
            visibilityChecker.addToInputEndpointsList(firstEndPoint);
            visibilityChecker.addToInputEndpointsList(secondEndPoint);
            //
            visibilityChecker.addToInputLineSegmentList(lineSegment);
            
            continue;
        }
        

        if (str.charAt(0) == 'Q') {
            output.println("q: " + str);
            output.flush();            
            // task: output: all the end points that q sees
            
            str = str.substring(2);
            
            int[] nums = int(split(str, ' '));
                // [todo:mn] real? int?
            int x = nums[0];
            int y = nums[1];
            
            Point pointQ = new Point(x, y);
            currentQueryPointQ = pointQ;

            // creating the horizontal arm line segment
            EndPoint firstEndPoint =
                new EndPoint(
                    -1,
                    0,
                    x,
                    y
                );
            EndPoint secondEndPoint =
                new EndPoint(
                    -1,
                    1,
                    ARM_LINE_SEGMENT_RIGHT_ENDPOINT_X,
                    y
                );

            // must not add these points with the input end points
            // allEndPointsList.add(firstEndPoint);
            // allEndPointsList.add(secondEndPoint);

            armLineSegment = new LineSegment(
                -1,
                firstEndPoint,
                secondEndPoint
            );
            
            visibilityChecker.setInputEndpointsList(allEndPointsList);
            // naive query
            //List<EndPoint> visibleEndPoints = visibilityChecker.naiveVisibilityQuery(currentQueryPointQ);
            
            // actual query
            List<EndPoint> visibleEndPoints = visibilityChecker.query(currentQueryPointQ);

            outputVisibleEndPoints(visibleEndPoints);

            // task: showing the visible points by drawing some blue lines from Q to those points
            currentVisibleEndPoints = visibleEndPoints;
            
            


            
            
            continue;
        }
    }
}

void outputVisibleEndPoints(List<EndPoint> visibleEndPoints) {

    output.println(visibleEndPoints.size() + " visibleEndPoints: ");
    for(EndPoint visibleEndpoint : visibleEndPoints) {
        output.println(visibleEndpoint.toString());
    }
}

// void keyPressed() {
//     output.flush();  // Writes the remaining data to the file
//     output.close();  // Finishes the file
//     // exit();  // Stops the program


// }

String changeModeString(String str, char mode) {
    StringBuilder sb = new StringBuilder(str);
    sb.setCharAt(str.length() - 1, mode);
    str = sb.toString();
    return str;
}
void keyPressed() {
    println("Key Pressed: " + key);
    //
    if (key == 'a') {


        // println("Key Pressed: " + "a");
        CUR_ANIMATION_MODE = 1 - CUR_ANIMATION_MODE;
        if (CUR_ANIMATION_MODE == 1) {
            currentStatusBarTextLine1 = ANIMATION_MODE_ON_TEXT;
        } else {
            currentStatusBarTextLine1 = ANIMATION_MODE_OFF_TEXT;
        }


        // task: clean up
        // toBeAnimatedRectList = new ArrayList();

    } else if (key == 'l') {
        CUR_INPUT_MODE = 'l';
        currentStatusBarTextLine2 = changeModeString(currentStatusBarTextLine2, 'l');
    } else if (key == 'q') {
        CUR_INPUT_MODE = 'q';
        currentStatusBarTextLine2 = changeModeString(currentStatusBarTextLine2, 'q');
    }
    println("CUR_INPUT_MODE: " + CUR_INPUT_MODE);
}

void drawTempCircleOnMouseClickPosition() {
    if (!isDrawnTempCircleOnMouseClickPosition) {
        
    } else {
        isDrawnTempCircleOnMouseClickPosition = true;
    }
}

// void mouseClicked() {
void mousePressed() {
    println("f(): mousePressed(): " + "CUR_INPUT_MODE: " + CUR_INPUT_MODE);
    println("mouseX: " + mouseX + ", mouseY: " + mouseY);
    println("sr(mouseX): " + sr(mouseX) + ", sr(mouseY): " + sr(mouseY));
    
    
    
    // println("\n\n");
    
    // common tasks
    savedMouseX = (int) sr(mouseX);
    savedMouseY = (int) sr(mouseY);
    
    if (CUR_INPUT_MODE == 'l') {
        // line insertion

        // task: take two mouse clicks as input
        if (MODE_I_MOUSE_CLICK_COUNT == 0) {
            MODE_I_MOUSE_CLICK_COUNT += 1;
            
            // task: read the 1st end point of a new gui based input line segment
            clickedFirstPointOfLineSegment = new Point(savedMouseX, savedMouseY);
        }
        else if (MODE_I_MOUSE_CLICK_COUNT == 1) {
            // task: read the 2nd end point of a new gui based input line segment
            clickedSecondPointOfLineSegment = new Point(savedMouseX, savedMouseY);
            
            MODE_I_MOUSE_CLICK_COUNT = 0;


            EndPoint endpoint0 = new EndPoint(
                    inputLSList.size(),
                    0,
                    clickedFirstPointOfLineSegment.getX(),
                    clickedFirstPointOfLineSegment.getY()
            );
            EndPoint endpoint1 = new EndPoint(
                    inputLSList.size(),
                    1,
                    clickedSecondPointOfLineSegment.getX(),
                    clickedSecondPointOfLineSegment.getY()
            );

            // Output mouse inputted line segments
            output.println("Mouse inputted line segment: " + clickedFirstPointOfLineSegment.getX() +" " + clickedFirstPointOfLineSegment.getY() + " " + 
                            clickedSecondPointOfLineSegment.getX() + " " +
                            clickedSecondPointOfLineSegment.getY());
            output.flush();
            
            // creating and adding this line segment
            LineSegment lineSegment = new LineSegment(
                inputLSList.size(),
                endpoint0,
                endpoint1
            );

            allEndPointsList.add(endpoint0);
            allEndPointsList.add(endpoint1);

            inputLSList.add(lineSegment);
            visibilityChecker.addToInputLineSegmentList(lineSegment);
            // println("inputLSList.size(): " + inputLSList.size());
            
            visibilityChecker.setInputEndpointsList(allEndPointsList);
            // using old/current Q
            //List<EndPoint> visibleEndPoints = visibilityChecker.naiveVisibilityQuery(currentQueryPointQ);
            List<EndPoint> visibleEndPoints = visibilityChecker.query(currentQueryPointQ);
            
            outputVisibleEndPoints(visibleEndPoints);

            // task: showing the visible points by drawing some blue lines from Q to those points
            currentVisibleEndPoints = visibleEndPoints;
        }
    }  else if (CUR_INPUT_MODE == 'q') {        
        currentQueryPointQ = new Point(savedMouseX, savedMouseY);

        output.println("Q " + currentQueryPointQ.getX() + " " + currentQueryPointQ.getY());

        visibilityChecker.setInputEndpointsList(allEndPointsList);
        
        //List<EndPoint> visibleEndPoints = visibilityChecker.naiveVisibilityQuery(currentQueryPointQ);
        List<EndPoint> visibleEndPoints = visibilityChecker.query(currentQueryPointQ);
        
        outputVisibleEndPoints(visibleEndPoints);

        currentVisibleEndPoints = visibleEndPoints;
    }
}
