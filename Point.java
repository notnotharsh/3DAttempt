public class Point {
  private float[] coords = new float[3];
  public Point(float[] coords) {
    this.coords = coords;
  }
  public float getX() {
    return coords[0];
  }
  public float getY() {
    return coords[1];
  }
  public float getZ() {
    return coords[2];
  }
}
