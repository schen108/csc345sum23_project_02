/*
Author: Md Moyeen Uddin
moyeen@arizona.edu
*/

//
int DEFAULT_H_VALUE = 5;
// DEFAULT_COLOR_FOR_INTERSECTING_LINES
RgbColor brownRgbColor = new RgbColor(150, 75, 16);
RgbColor redRgbColor = new RgbColor(255, 0, 0);
RgbColor reddishRgbColor = new RgbColor(200, 0, 0);
RgbColor greenishRgbColor = new RgbColor(0, 250, 0);
RgbColor bluishRgbColor = new RgbColor(0, 0, 245);
RgbColor blueRgbColor = new RgbColor(0, 0, 255);

RgbColor lineDefaultRgbColor = 
    // new RgbColor(220, 220, 220); // grey
    brownRgbColor; // grey

RgbColor armLineSegmentDefaultRgbColor = 
    greenishRgbColor;

RgbColor pointQDefaultRgbColor = 
    reddishRgbColor;
RgbColor endPointDefaultRgbColor = 
    greenishRgbColor;
RgbColor endPointIdTextDefaultRgbColor = 
    redRgbColor;


RgbColor intersectingLineRgbColor = new RgbColor(255, 000, 000);
RgbColor enclosingLineRgbColor = new RgbColor(000, 255, 000);
RgbColor lineIdTextRgbColor = brownRgbColor;

float CUSTOM_GRID_THICKNESS       = 0.02;
float CUSTOM_LINE_THICKNESS       = 0.3;
float CUSTOM_QUAD_RECTANGLE_THICKNESS  = 0.2;
float CUSTOM_QUERY_POINT_THICKNESS  = 0.2;
float CUSTOM_ENDPOINT_THICKNESS  = 0.3;
float CUSTOM_RECTANGLE_THICKNESS  = 0.3;
float CUSTOM_QUERY_RECTANGLE_THICKNESS  = 0.4;
float CUSTOM_DEFAULT_TEXT_SIZE  = 0.8;
float CUSTOM_DIAMATER_OF_CIRCLE_DRAWN_AROUND_MOUSE_CLICK = 1;
float CUSTOM_DIAMATER_OF_CIRCLE_DRAWN_AROUND_LINE_ENDPOINT = 0.5;

//
float ARM_LINE_SEGMENT_RIGHT_ENDPOINT_X = 100;

// flags
boolean FLAG_IS_INPUT_FILE_LOADED = false;

// some default values
static String DEFAULT_STATUS_BAR_TEXT_LINE_1 = "Animation Mode: OFF";
String ANIMATION_MODE_ON_TEXT = "Animation Mode: ON";
String ANIMATION_MODE_OFF_TEXT = "Animation Mode: OFF";

static String DEFAULT_STATUS_BAR_TEXT_LINE_2 = "Input Mode: u";
// static String DEFAULT_STATUS_BAR_TEXT_LINE_2 = "Input Mode: i"; // [todo:mn] make it 'u'?