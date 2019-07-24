import java.lang.Math.*;
public class Perspective {
  private float[] coords = new float[3]; // X, Y, Z
  private float[] angles = new float[3]; // YZ,XZ,XY
  private int[] screen = new int[2];
  public Perspective(float[] coords, float angles[], int[] screen) {
    this.coords = coords;
    this.angles = angles;
    this.screen = screen;
  }
  public float[] pointTransform(Point point) {
    float xFromOrigin = point.getX() - coords[0];
    float yFromOrigin = point.getY() - coords[1];
    float zFromOrigin = point.getZ() - coords[2];
    float notNewZ = (float) (zFromOrigin * Math.cos(angles[0]) + yFromOrigin * Math.sin(angles[0]));
    float newX = (float) (xFromOrigin * Math.cos(angles[1]) + notNewZ * Math.sin(angles[1]));
    float newY = (float) (yFromOrigin * Math.cos(angles[0]) - zFromOrigin * Math.sin(angles[0])); //cpos
    float newZ = (float) (notNewZ * Math.cos(angles[1]) - xFromOrigin * Math.sin(angles[1]));
    float xAngle = (float) (Math.asin(newX/Math.sqrt(Math.pow(newX, 2) + Math.pow(newZ, 2))));
    float yAngle = (float) (Math.asin(newY/Math.sqrt(Math.pow(newY, 2) + Math.pow(newZ, 2))));
    if (newZ <= 0) {
      if (newX > 0) {
        xAngle = (float) (Math.PI - xAngle);
      }
      if (newX < 0) {
        xAngle = (float) (-1 * Math.PI - xAngle);
      }
      if (newY > 0) {
        yAngle = (float) (Math.PI - yAngle);
      }
      if (newY < 0) {
        yAngle = (float) (-1 * Math.PI - yAngle);
      }
    }
    float[] angles = {(float) (screen[0] * 0.5 + screen[0]/60 * 180/Math.PI * xAngle), (float) (screen[1] * 0.5 + screen[1]/(-60) * 180/Math.PI * yAngle)};
    return angles;
  }
}
