PFont font;

ArrayList words = new ArrayList();

void setup() {
  size(800, 600);
  
  font = loadFont("Arial-Black-48.vlw");
  textFont(font, 48);
  
  //initialize the speech recognition
  voce.SpeechInterface.init(dataPath("voce-0.9.1/lib"), false, true, dataPath("grammars"), "");
}

void draw() {
  background(128, 128, 128);
  
  if (voce.SpeechInterface.getRecognizerQueueSize() > 0) {
    String spoken = voce.SpeechInterface.popRecognizedString();
    Word recognizedWord = new Word(spoken);
    words.add(recognizedWord);
    
    if (recognizedWord.getRisk() == Risk.HIGH) {
      background(255, 255, 255);
    }
  }
  
  for (int i = 0; i < words.size(); i++) {
    if (((Word)words.get(i)).isOffscreen()) {
      words.remove(i);
    } else {
      ((Word)words.get(i)).update();
    }
  }
}


static class Risk {
  public static int LOW = 0;
  public static int MEDIUM = 1;
  public static int HIGH = 2;
}

class Word {
  String value;
  
  int x = 32;
  int y = 0;
  
  Word(String value) {
    this.value = value;
  }
  
  void update() {
    
    //Color the word based on risk
    switch(getRisk()) {
      case 0:
        //fill with green
        fill(0, 255, 0);
        break;
      case 1:
        //fill with yellow
        fill(255, 255, 0);
        break;
      case 2:
        fill(255, 0, 0);
        x = 100;
        break;
      default:
        fill(0, 0, 0);
    }
    
    //print the text and move it down the screen
    text(value, x, y);
    y += 2;
  }
  
  boolean isOffscreen() {
    return y > (height + 48);
  }
  
  //What makes a word interesting?
  int getRisk() {    
    if (value.contains("dangerous")) {
      return Risk.HIGH;
    }
    return Risk.LOW;
  }
}
