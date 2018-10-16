import java.util.*;
float leftRight = 0;
float upDown = 0;
float forwardBack = -20;
float LRAngle = 0;
float UDAngle = 0;
float initialMouseX = 0;
float initialMouseY = 0;
float speed = 5;
boolean mouseDetectorOn = false;
boolean solids = false;
void setup() {
  size(1000, 1000);
  background(0, 0, 0);
  stroke(254);
  strokeWeight(0);
}
void draw() {
  background(0, 0, 0);
  float[] coords = {leftRight,upDown,forwardBack};
  float[] angles = {(UDAngle),(LRAngle),0};
  int[] screen = {width, height};
  float xMouse = (mouseX - width * 0.5) * 60/width;
  float yMouse = (mouseY - height * 0.5) * 60/height;
  Perspective User = new Perspective(coords, angles, screen);
  if (mouseDetectorOn) {
    float diffX = xMouse * (float) Math.PI/180 - initialMouseX;
    float diffY = yMouse * (float) Math.PI/180 - initialMouseY;
    initialMouseX = xMouse * (float) Math.PI/180;
    initialMouseY = yMouse * (float) Math.PI/180;
    LRAngle -= diffX * 2;
    UDAngle -= diffY * 2;
  }
  if (!(solids)) {
    String[] points = loadStrings("./points.txt");
    String[] lines = loadStrings("./lines.txt");
    for (int i = 0; i < lines.length; i++) {
      if (!(lines[i].split(" ")[0].equals("-"))) { 
        String[] point1Coords = points[Integer.parseInt(lines[i].split(" ")[1])-1].split(" ");
        String[] point2Coords = points[Integer.parseInt(lines[i].split(" ")[2])-1].split(" ");
        drawLine(Float.parseFloat(point1Coords[0]), Float.parseFloat(point1Coords[1]), Float.parseFloat(point1Coords[2]), Float.parseFloat(point2Coords[0]), Float.parseFloat(point2Coords[1]), Float.parseFloat(point2Coords[2]), User, 0, 0);
      }
    }
  } else {  
    String[] points = loadStrings("./points.txt");
    String[] surfaces = loadStrings("./surfaces.txt");
    String[] lights = loadStrings("./lights.txt");
    float[][] centroids = associateLight(surfaces, lights, points);
    float[] lightLevels = centroids[surfaces.length];
    float[] distances = new float[surfaces.length];
    for (int i = 0; i < surfaces.length; i++) {
      distances[i] = (sqrt((centroids[i][0] - coords[0]) * (centroids[i][0] - coords[0]) + (centroids[i][1] - coords[1]) * (centroids[i][1] - coords[1]) + (centroids[i][2] - coords[2]) * (centroids[i][2] - coords[2])));
    }
    int[] sortedKeys = doubleDescendSort(distances);
    for (int i : sortedKeys) {
      String[] point1Coords = points[Integer.parseInt(surfaces[i].split(" ")[1])-1].split(" ");
      String[] point2Coords = points[Integer.parseInt(surfaces[i].split(" ")[2])-1].split(" ");
      String[] point3Coords = points[Integer.parseInt(surfaces[i].split(" ")[3])-1].split(" ");
      drawSurface(Float.parseFloat(point1Coords[0]), Float.parseFloat(point1Coords[1]), Float.parseFloat(point1Coords[2]), Float.parseFloat(point2Coords[0]), Float.parseFloat(point2Coords[1]), Float.parseFloat(point2Coords[2]), Float.parseFloat(point3Coords[0]), Float.parseFloat(point3Coords[1]), Float.parseFloat(point3Coords[2]), User, 0, 0, lightLevels[i]);
    }
  }
}
int[] doubleDescendSort(float[] values) {
  int[] iValues = new int[values.length];
  for (int i = 0; i < values.length; i++) {
    iValues[i] = i;
  }
  int count = 0;
  do {
    for (int i = 0; i < values.length - 1; i++) {
      if (values[i] < values[i+1]) {
        float temp = values[i];
        values[i] = values[i+1];
        values[i+1] = temp;
        int tempi = iValues[i];
        iValues[i] = iValues[i+1];
        iValues[i+1] = tempi;
        count++;
      }
    }
  } while (count == 0);
  return iValues;
}
float[][] associateLight(String[] surfaces, String[] lights, String[] points) {
  float[][] centroids = new float[surfaces.length + 1][surfaces.length];
   for (int i = 0; i < surfaces.length; i++) {
    if (!(surfaces[i].split(" ")[0].equals("-"))) { 
      String[] point1Coords = points[Integer.parseInt(surfaces[i].split(" ")[1])-1].split(" ");
      String[] point2Coords = points[Integer.parseInt(surfaces[i].split(" ")[2])-1].split(" ");
      String[] point3Coords = points[Integer.parseInt(surfaces[i].split(" ")[3])-1].split(" ");
      float[][] triangle = {{Float.parseFloat(point1Coords[0]), Float.parseFloat(point1Coords[1]), Float.parseFloat(point1Coords[2])}, {Float.parseFloat(point2Coords[0]), Float.parseFloat(point2Coords[1]), Float.parseFloat(point2Coords[2])}, {Float.parseFloat(point3Coords[0]), Float.parseFloat(point3Coords[1]), Float.parseFloat(point3Coords[2])}};
      float[] midpoint = {(triangle[0][0] + triangle[1][0])/2, (triangle[0][1] + triangle[1][1])/2, (triangle[0][2] + triangle[1][2])/2};
      float[] centroid = {(midpoint[0] + 2 * triangle[2][0])/3, (midpoint[1] + 2 * triangle[2][1])/3, (midpoint[2] + 2 * triangle[2][2])/3};
      centroids[i] = centroid;
    }
  }
  for (int i = 0; i < lights.length; i++) {
    if (!(lights[i].split(" ")[0].equals("-"))) {
      float[] lightCoords = {Float.parseFloat(lights[i].split(" ")[2]), Float.parseFloat(lights[i].split(" ")[3]), Float.parseFloat(lights[i].split(" ")[4])};
      float lightIntensity = Float.parseFloat(lights[i].split(" ")[1]);
      for (int j = 0; j < surfaces.length; j++) {
        float[] centroid = centroids[j];
        float distance = sqrt((centroid[0]-lightCoords[0]) * (centroid[0]-lightCoords[0]) + (centroid[1]-lightCoords[1]) * (centroid[1]-lightCoords[1]) + (centroid[2]-lightCoords[2]) * (centroid[2]-lightCoords[2]));
        float lightAmount = lightIntensity/(distance * distance);
        centroids[surfaces.length][j] += lightAmount;
        centroids[surfaces.length][j] = min(centroids[surfaces.length][j], 255);
      }
    }
  }
  return centroids;
}
float[] drawPoint(float x3D, float y3D, float z3D, Perspective User, float xRadius, float yRadius) {
  Point point = new Point(new float[] {x3D,y3D,z3D});
  float[] newCoords = User.pointTransform(point);
  ellipse(newCoords[0], newCoords[1], xRadius, yRadius);
  return newCoords;
}
void drawLine(float x13D, float y13D, float z13D, float x23D, float y23D, float z23D, Perspective User, float xRadius, float yRadius) {
  float[] point1Loc = drawPoint(x13D, y13D, z13D, User, xRadius, yRadius);
  float[] point2Loc = drawPoint(x23D, y23D, z23D, User, xRadius, yRadius);
  //if ((!((abs(point1Loc[0]) > width) && (abs(point2Loc[0]) > width))) && (!((abs(point1Loc[1]) > height) && (abs(point2Loc[1]) > height))))  {
    line(point1Loc[0], point1Loc[1], point2Loc[0], point2Loc[1]);
  //}
}
void drawSurface(float x13D, float y13D, float z13D, float x23D, float y23D, float z23D, float x33D, float y33D, float z33D, Perspective User, float xRadius, float yRadius, float colorValue) {
  float[] point1Loc = drawPoint(x13D, y13D, z13D, User, xRadius, yRadius);
  float[] point2Loc = drawPoint(x23D, y23D, z23D, User, xRadius, yRadius);
  float[] point3Loc = drawPoint(x33D, y33D, z33D, User, xRadius, yRadius);
  //if ((!((abs(point1Loc[0]) > width) && (abs(point2Loc[0]) > width))) && (!((abs(point1Loc[1]) > height) && (abs(point2Loc[1]) > height))))  {
    fill(colorValue);
    triangle(point1Loc[0], point1Loc[1], point2Loc[0], point2Loc[1], point3Loc[0], point3Loc[1]);
  //}
}
void keyPressed() {
  if (key == 'd') {
    leftRight += .1 * speed;
  }
  if (key == 'a') {
    leftRight -= .1 * speed;
  }
  if (key == 'w') {
    upDown += .1 * speed;
  }
  if (key == 's') {
    upDown -= .1 * speed;
   }
  if (key == 'z') {
    forwardBack += .1 * speed;
  }
  if (key == 'x') {
    forwardBack -= .1 * speed;
  }
  if (key == 'l') {
    LRAngle -= PI/1000 * speed;
  }
  if (key == 'j') {
    LRAngle += PI/1000 * speed;
  }
  if (key == 'i') {
    UDAngle += PI/1000 * speed;
  }
  if (key == 'k') {
    UDAngle -= PI/1000 * speed;
  } 
  if (key == ',') {
    mouseDetectorOn = true;
  }  
  if (key == '.') {
    mouseDetectorOn = false;
  }
  if (key == ' ') {
    if (solids == true) {
      solids = false;
    } else {
      solids = true;
    }
  }
  if ((48 <= key) && (key <= 57)) {
    speed = (key - 48) * (key - 48);
  }
}
