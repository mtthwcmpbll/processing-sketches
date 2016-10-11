PFont font;

ArrayList words = new ArrayList();

void setup() {
  size(800, 600);
  
  font = createFont(PFont.list()[0], 48);
  textFont(font, 48);
  
  //initialize the speech recognition
  voce.SpeechInterface.init(dataPath("voce-0.9.1/lib"), false, true, dataPath("grammars"), "keywords");
}

void draw() {
  background(128, 128, 128);
  
  if (voce.SpeechInterface.getRecognizerQueueSize() > 0) {
    //add the word we recognized...
    String spoken = voce.SpeechInterface.popRecognizedString();
    Word recognizedWord = new Word(spoken);
    words.add(recognizedWord);
    
    //...and ask all words to scroll down the new height
    for (int i = 0; i < words.size(); i++) {
      ((Word)words.get(i)).scrollToY(48);
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


class Word {
  String value;
  
  int x = 32;
  int y = 48;
  
  int yScroll = 0;
  
  Word(String value) {
    this.value = value;
  }
  
  void update() {
    
    //Do any modification (stroke, fill, other drawing, etc) based on features here...
    
    //Color the word based on interestingness
    switch(getLength()) {
      case 0:  //short words...
        //fill with green
        fill(0, 255, 0);
        break;
      case 1:  //medium words...
        //fill with yellow
        fill(255, 255, 0);
        break;
      case 2:  //long words...
        fill(255, 0, 0);
        break;
      default:  //catch anything else, color white (but we shouldn't ever get this)
        fill(0, 0, 0);
    }
    
    //print the text and move it down the screen
    text(value, x, y);
    if (yScroll > 0) {
      y += 2;
      yScroll -= 2;
    }
  }
  
  /**
   * Used to check if a word is visible so it can be removed if desired
   */
  boolean isOffscreen() {
    return y > (height + 48);
  }
  
  void scrollToY(int y) {
    yScroll = y;
  }
  
  /**
   * an example feature 'length' - add more features methods and use them in update()
   */
  int getLength() {
    if (value.length() > 8) {
      return 2;
    } else if(value.length() > 4) {
      return 1;
    } else {
      return 0;
    }
  }
}