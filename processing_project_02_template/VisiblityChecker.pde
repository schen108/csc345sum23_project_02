/*
Author: Md Moyeen Uddin
moyeen@arizona.edu

- note:
    - 

*/

import java.util.*;

// [constants]
String DEBUG_MSG_PRFX = "DEBUG_MSG: ";
void debug_print(String debug_msg) {
    println(DEBUG_MSG_PRFX + debug_msg);
}
//

class VisibilityChecker {
    //
    // the below two are related
        // ie: each segments corresponds to two endpoints
    List<LineSegment> allLineSegmentsList = new ArrayList();
    List<EndPoint> allEndPointsList = new ArrayList();
    //
    
    VisibilityChecker() {
        
    }

   
    //
    public List<EndPoint> naiveVisibilityQuery(Point pointQ) {
        /*
            - desc:
                - the O(n^2) algorithm described in the project_02 overleaf
                - returns the list of endpoints that Q sees
        */
        // [todo:mn] implement

        ArrayList<EndPoint> visibleEndpointsList = new ArrayList<EndPoint>();
        // task: traversing throgh ALL the endpoints
        for(EndPoint endpointP : this.allEndPointsList) {
            if(doesQSeeP(pointQ, endpointP)) {
                visibleEndpointsList.add(endpointP);
            }
        }

        return visibleEndpointsList;
    }

    boolean doesQSeeP(Point pointQ, EndPoint endPointP) {
        /*
            - O(n^2) naively checking all segments
        */
        // output.println();
        // output.println("doesQSeeP(): ");
        boolean result = true;

        //
        EndPoint endPointQ = 
            new EndPoint(
                -1,
                -1,
                pointQ.getX(),
                pointQ.getY()
            );
        LineSegment lineSegmentQP = 
            new LineSegment(
                -1,
                endPointQ,
                endPointP
            );
        // task: traversing through ALL the line segments
            // to see if that line segment crosses the Q-P line segment
        for(LineSegment lineSegmentAB : this.allLineSegmentsList) {
            // if the endPointP is one of the endpoints of line AB
                // then skip
            if(
                endPointP.getLineId()
                ==
                lineSegmentAB.getLineId()
            ) {
                continue;
            }
            
            if(
                doLinesIntersect(
                    lineSegmentQP,
                    lineSegmentAB
                )
            ) {
                // output.println("line: [Q-" + endPointP.toString() + "] crosses: line: " + lineSegmentAB.toString());

                result = false;
                break;
            }
        }

        return result;
    }

    private boolean doLinesIntersect(
        LineSegment lineSegmentA,
        LineSegment lineSegmentB
    ) {
        if(
            doIntersect(
                lineSegmentA.getFirstEndPoint(),
                lineSegmentA.getSecondEndPoint(),
                lineSegmentB.getFirstEndPoint(),
                lineSegmentB.getSecondEndPoint()
            )
        ) {
            return true;
        }
        return false;
    }

    public List<EndPoint> query(Point pointQ) {
        // [todo:mn] implement
        /*
            O ( n log n )
        */ 
        ArrayList<EndPoint> visibleEndpointsList = new ArrayList<EndPoint>();

        VisibilityHeap eventsHeap = new VisibilityHeap(allEndPointsList, pointQ);
        
        testAngle();
        
        return visibleEndpointsList;
    }

    //
    public void setInputEndpointsList(List<EndPoint> allEndPointsList) {
        this.allEndPointsList = allEndPointsList;
    }
    public void addToInputEndpointsList(EndPoint endPoint) {
        this.allEndPointsList.add(endPoint);
    }
    public void addToInputLineSegmentList(LineSegment lineSegment) {
        this.allLineSegmentsList.add(lineSegment);
    }

    //
    public String toString() {
        String str = "";
        str += "VisibilityChecker{}:";
        str += "\n";
        return str;
    }
}

class VisibilityHeap {
    Event[] eventsHeap;
    int size = 0;
    
    Set<Integer> lsIds = new HashSet();
    
    class Event {
        
        // birth event is true, death event is false
        boolean isBirth;
        float angleWithQ;
        EndPoint endpoint;
        
        Event(EndPoint endpoint, float angleWithQ) {
            
            this.endpoint = endpoint;
            this.angleWithQ = angleWithQ;
            if (!lsIds.contains(endpoint.getLineId())) {
                isBirth = true;    
            } else {
                isBirth = false;
            }
            lsIds.add(endpoint.getLineId());
        }
        
        public String toString() {
            String isBirth = this.isBirth ? "birth" : "death";
            
            return  endpoint.toString() + ", " + angleWithQ + ", " + isBirth;
        }
    }
    
    VisibilityHeap(List<EndPoint> allEndPointsList, Point pointQ) {
        
        eventsHeap = new Event[allEndPointsList.size()];
        
        for (EndPoint ep : allEndPointsList) {
            float angleWithQ = computeAngle(ep.getX() - pointQ.getX(), pointQ.getY() - ep.getY());
            Point nep = (Point) ep;
            insertIntoHeap(new Event(ep, angleWithQ));
        }
    }
    
    private void insertIntoHeap(Event event) {
            
    }
}
