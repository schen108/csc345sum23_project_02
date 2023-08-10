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

        EventsHeap eHeap = new EventsHeap(allLineSegmentsList, pointQ);
        SegmentsHeap sHeap = new SegmentsHeap(pointQ);
        
        while (!eHeap.isEmpty()) {
            EventsHeap.Event event = eHeap.extractMin();   
            EndPoint visibleEndPoint = sHeap.processEvent(event);
            if (visibleEndPoint != null) {
                visibleEndpointsList.add(visibleEndPoint);    
            }
        }
        
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

class EventsHeap {
    private ArrayList<Event> heap = new ArrayList<>();
    
    //Set<Integer> lsIds = new HashSet();
    
    class Event {
        
        // birth event is true, death event is false
        private boolean isBirth;
        private float angleWithQ;
        private EndPoint endpoint;
        
        Event(EndPoint endpoint, float angleWithQ, boolean isBirth) {
            
            this.endpoint = endpoint;
            this.angleWithQ = angleWithQ;
            this.isBirth = isBirth;
            //isBirth = 
            //if (!lsIds.contains(endpoint.getLineId())) {
            //    isBirth = true;    
            //} else {
            //    isBirth = false;
            //}
            //lsIds.add(endpoint.getLineId());
        }
        
        public boolean isBirth() {
            return isBirth;    
        }
        
        public float angleWithQ() {
            return angleWithQ;    
        }
        
        public EndPoint getEndPoint() {
            return endpoint;    
        }
        
        public String toString() {
            String isBirth = this.isBirth ? "birth" : "death";
            
            return  endpoint.toString() + ", " + angleWithQ + ", " + isBirth;
        }
    }
    
    EventsHeap(List<LineSegment> allLineSegmentsList, Point pointQ) {
        
        for (LineSegment ls : allLineSegmentsList) {
            EndPoint ep1 = ls.getFirstEndPoint();
            EndPoint ep2 = ls.getSecondEndPoint();
            float angleWithQ1 = computeAngle(ep1.getX() - pointQ.getX(), pointQ.getY() - ep1.getY());
            float angleWithQ2 = computeAngle(ep2.getX() - pointQ.getX(), pointQ.getY() - ep2.getY());
            Event event1;
            Event event2;
            if (angleWithQ1 < angleWithQ2) {
                event1 = new Event(ep1, angleWithQ1, true);
                event2 = new Event(ep2, angleWithQ2, false);
            } else {
                event2 = new Event(ep2, angleWithQ2, true);
                event1 = new Event(ep1, angleWithQ1, false);
            }
            insertIntoHeap(event1);
            insertIntoHeap(event2);
        }
        println(this.toString());
    }
    
    void insertIntoHeap(Event event) {
        // Add the event to the heap
        heap.add(event);
    
        // Restore the heap property by moving the new event to its correct position
        heapifyUp(heap.size() - 1);
    }

    private void heapifyUp(int index) {
        while (index > 0) {
            int parentIndex = (index - 1) / 2;
            if (heap.get(index).angleWithQ < heap.get(parentIndex).angleWithQ) {
                // Swap the current event with its parent
                Event temp = heap.get(index);
                heap.set(index, heap.get(parentIndex));
                heap.set(parentIndex, temp);
    
                // Move to the parent index
                index = parentIndex;
            } else {
                break;
            }
        }
    }
    
    Event extractMin() {
        if (heap.size() == 0) {
            return null; // Heap is empty
        }
    
        // Take the root (smallest angle event)
        Event root = heap.get(0);
    
        // Replace the root with the last event in the heap
        Event lastEvent = heap.remove(heap.size() - 1);
        if (heap.size() > 0) {
            heap.set(0, lastEvent);
            heapifyDown(0);
        }
    
        return root;
    }

    private void heapifyDown(int index) {
        int leftChildIndex = 2 * index + 1;
        int rightChildIndex = 2 * index + 2;
        int smallestIndex = index;
    
        if (leftChildIndex < heap.size() && heap.get(leftChildIndex).angleWithQ < heap.get(smallestIndex).angleWithQ) {
            smallestIndex = leftChildIndex;
        }
    
        if (rightChildIndex < heap.size() && heap.get(rightChildIndex).angleWithQ < heap.get(smallestIndex).angleWithQ) {
            smallestIndex = rightChildIndex;
        }
    
        if (smallestIndex != index) {
            // Swap the current event with the smallest of its children
            Event temp = heap.get(index);
            heap.set(index, heap.get(smallestIndex));
            heap.set(smallestIndex, temp);
    
            // Recursively heapify the affected sub-tree
            heapifyDown(smallestIndex);
        }
    }
    
    public boolean isEmpty() {
        return heap.size() == 0;    
    }

    public String toString() {
        String s = "";
        for (Event e : heap) {
            s += e.toString() + "\n";    
        }
        return s;
    }
}

class SegmentsHeap {
    private ArrayList<LineSegment> heap = new ArrayList<>();
    private Point pointQ;
    private LineSegment rayQ;
    
    SegmentsHeap(Point pointQ) {
        this.pointQ = pointQ;
    }
    
    EndPoint processEvent(EventsHeap.Event event) {
        
        rayQ = createRayQ(event);
        
        if (event.isBirth()) {
                
        }
        int topLsId = heap.get(0).getLineId();
        EndPoint ep = event.endpoint;
        if (topLsId == ep.getLineId()) {
            return ep;    
        }
        return null;
    }
    
    
}
