import java.io.File;
import java.io.FileNotFoundException;
import java.util.Arrays;
import java.util.Scanner;

public class Container {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        System.out.println("Enter the name of the data file:");
        String file = input.next();
        System.out.println("Enter the bounding rectangle (bottom left x y and top right x y):");
        input.nextLine();
        String rec = input.nextLine();
        String[] recToks = rec.split(" ");
        try {
            Scanner fileIn = new Scanner(new File(file));
            String line;
            while(fileIn.hasNextLine()){
                line=fileIn.nextLine();
                String[] toks = line.split(" ");
                int x1 = Integer.parseInt(toks[0])+Integer.parseInt(toks[2]);
                int x2 = Integer.parseInt(toks[0])-Integer.parseInt(toks[2]);
                int y1 = Integer.parseInt(toks[1])+Integer.parseInt(toks[2]);
                int y2 = Integer.parseInt(toks[1])-Integer.parseInt(toks[2]);
                String msg=null;
                if(Integer.parseInt(recToks[0]) < x2 && x1 < Integer.parseInt(recToks[2]) && Integer.parseInt(recToks[1])<y2 && y1<Integer.parseInt(recToks[3])) {msg = "Yes";}
                else{
                    msg="No";
                }
                System.out.println("Testing circle: "+toks[0]+" "+toks[1]+" "+toks[2]+".\n"+msg);
        }
        fileIn.close();
        System.out.println("Done");

    } catch (
    FileNotFoundException e) {
        e.fillInStackTrace();
    }
}
}
