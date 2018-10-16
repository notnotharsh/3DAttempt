import java.util.*;
import java.io.*;
public class sphereWriter {
  public static void writeOutput(String[] data, String filename) {
    try {
      File output = new File(filename);
      FileWriter fw = new FileWriter(output);
      String str = "";
      for (int i = 0; i < data.length; i++) {
        str += data[i];
        str += "\n";
      }
      fw.write(str);
      fw.flush();
    } catch (IOException ex) {
      System.out.println(ex);
    }
  }
  private static float sine(float theta) {
    return (float) Math.sin(Math.PI * theta/180);
  }
  private static float cosine(float theta) {
    return (float) Math.cos(Math.PI * theta/180);
  }
  public static void main(String[] args) {
    int r = 100;
    String[] points = new String[685];
    String[] lines = new String[1296];
    String[] surfaces = new String[1296];
    int count = 0;
    for (int yAngle = -90; yAngle <= 90; yAngle += 10) {
      for (int xzAngle = 0; xzAngle < 360; xzAngle += 10) {
        if (yAngle == -90) {
          String point = "0 " + Integer.toString(-1 * r) + " 150";
          points[count] = point;
          lines[count] = ". " + Integer.toString(count + 1) + " 685";
          count++;
        } else {
          if (yAngle == 90) {
          String point = "0 " + Integer.toString(r) + " 150";
            points[count] = point;
            lines[count] = ". " + Integer.toString(count + 1) + " 685";
            count++;
          } else {
          float x = r * cosine(yAngle) * cosine(xzAngle);
          float y = r * sine(yAngle);
          float z = r * cosine(yAngle) * sine(xzAngle) + 150;
          String point = Float.toString(x) + " " + Float.toString(y) + " " + Float.toString(z);
          points[count] = point;
          lines[count] = ". " + Integer.toString(count + 1) + " 685";
          count++;
        }
      }
    }
  }
  points[684] = "0 0 0";
  for (int i = 0; i < 648; i++) {
    lines[2*i+1] = ". " + Integer.toString(i + 1) + " " + Integer.toString(i + 37);
    if (i % 36 != 35) {
      lines[2*i] = ". " + Integer.toString(i + 1) + " " + Integer.toString(i + 2);
      surfaces[2*i+1] = ". " + Integer.toString(i + 1) + " " + Integer.toString(i + 37) + " " + Integer.toString(i + 38);
      surfaces[2*i] = ". " + Integer.toString(i + 1) + " " + Integer.toString(i + 2) + " " + Integer.toString(i + 38);
    } else {
      lines[2*i] = ". " + Integer.toString(i + 1) + " " + Integer.toString(i - 34);
      surfaces[2*i+1] = ". " + Integer.toString(i + 1) + " " + Integer.toString(i + 37) + " " + Integer.toString(i + 2);
      surfaces[2*i] = ". " + Integer.toString(i + 1) + " " + Integer.toString(i - 34) + " " + Integer.toString(i + 2);
    }
  }
  writeOutput(points, "points.txt");
  writeOutput(lines, "lines.txt");
  writeOutput(surfaces, "surfaces.txt");
  }
}
