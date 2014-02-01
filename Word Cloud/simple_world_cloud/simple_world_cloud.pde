/*
 * Renders a world cloud from an input text file.
 */
import java.util.*;

class WordWithFrequency implements Comparable<WordWithFrequency> {
  String word;
  Integer frequency = 0;
  PVector location = new PVector(0, 0);
  PVector scale = new PVector(1, 1);
  color tileColor = color(0, 0, 0);
  float fontSize = 24;

  WordWithFrequency(String w, Integer f) {
    word = w;
    frequency = f;
  }

  void incrementFrequency() {
    frequency += 1;
  }

  void calculateBounds() {
    fontSize = map(frequency, 1, 300, 10, 50);
    textSize(fontSize);
    scale.x = textWidth(word);
    scale.y = textAscent();
  }

  void draw() {
    fill(tileColor);
    textSize(fontSize);
    text(word, location.x, location.y);
  }

  boolean intersects(WordWithFrequency other) {
    float left = location.x;
    float right = left + scale.x;
    float top = location.y - scale.y;
    float bottom = location.y;

    float left2 = other.location.x;
    float right2 = left2 + other.scale.x;
    float top2 = other.location.y - other.scale.y;
    float bottom2 = other.location.y;

    return !(right < left2 
      || left > right2
      || bottom < top2
      || top > bottom2);
  }

  public boolean equals(Object other) {
    if (other instanceof WordWithFrequency) {
      WordWithFrequency otherWord = (WordWithFrequency) other;
      return this.word.equalsIgnoreCase(otherWord.word);
    }
    return false;
  }

  public int hashCode() {
    return word.hashCode();
  }

  public int compareTo(WordWithFrequency other) {
    return other.frequency.compareTo(frequency);
  }
}

String textFile = "iliad.txt";

Set<String> loadStopwords() {
  String[] stopwords = loadStrings("stopwords.txt");
  Set<String> sortedSet = new TreeSet<String>();
  for (String w : stopwords) {
    sortedSet.add(w);
  }  
  return sortedSet;
}

List<String> filterAndTokenizeInput() {
  String delimiters = " .,<>;:'\"[]{}()&$@!~";
  String[] lines = loadStrings(textFile);
  String allText = join(lines, " ");
  String lowercaseText = allText.toLowerCase();
  String[] tokens = splitTokens(lowercaseText, delimiters);

  Set<String> stopwords = loadStopwords();
  ArrayList<String> words = new ArrayList<String>();
  for (String t : tokens) {
    if (t.length() > 2 && !stopwords.contains(t)) {
      words.add(t);
    }
  }
  return words;
}

ArrayList<WordWithFrequency> sortWordsByFrequency(List<String> words) {
  for (String w : words) {
    if (wordFrequencies.containsKey(w)) {
      WordWithFrequency wf = wordFrequencies.get(w);
      wf.incrementFrequency();
    } 
    else {
      wordFrequencies.put(w, new WordWithFrequency(w, 1));
    }
  }
  ArrayList<WordWithFrequency> sortedWords = new ArrayList<WordWithFrequency>();
  sortedWords.addAll(wordFrequencies.values());
  java.util.Collections.sort(sortedWords);
  return sortedWords;
}

class WordsLayout {
  List<WordWithFrequency> words;

  public WordsLayout(List<WordWithFrequency> w) {
    words = w;
  }

  public void layoutWordsInRectangular(int limit, int maxX, int maxY) {
    for (int i = 0; i < limit; i++) {
      WordWithFrequency w = words.get(i);
      w.calculateBounds();

      int retries = 0;
      do {
        float xRange = random(maxX - w.scale.x);
        float yRange = random(w.scale.y, maxY);
        w.location = new PVector(xRange, yRange);
      } 
      while (retries++ < 100 && intersectsOthers (i));
    }
  }

  public void layoutWordsInSpiral(int limit, float dr, float dt) {
    PVector center = new PVector(width/2, height/2);
    for (int i = 0; i < limit; i++) {
      WordWithFrequency w = words.get(i);
      w.calculateBounds();
    }
    
    for (int i = 0; i < limit; i++) {
      WordWithFrequency w = words.get(i);
      int retries = 0;
      float theta = 0.0;
      float radius = 0.0;
      float cx = width/2-50, cy = height/2, px, py;
      float R = 0.0, dR = 0.2, dTheta = 0.5;
      do {
        //float x = center.x + radius*cos(theta);
        //float y = center.y + radius*sin(theta);
        float x = cx + R*cos(theta);
        float y = cy + R*sin(theta); 
        w.location = new PVector(x, y);

 //       theta += dt;
        radius += dr;
        theta+=dTheta;
        R += dR;
      } 
      while (retries++ < 100 && intersectsOthers (i));
    }
  }

  private boolean intersectsOthers(int index) {
    WordWithFrequency w = words.get(index);
    for (int i = 0; i < index; i++) {
      WordWithFrequency other = words.get(i);
      if (w.intersects(other)) {
        return true;
      }
    }
    return false;
  }
}

HashMap<String, WordWithFrequency> wordFrequencies = new HashMap<String, WordWithFrequency>();
ArrayList<WordWithFrequency> sorted;
final int N = 150;

void setup() {
  size(1200, 1000, OPENGL);
  background(255);
  fill(0);
  smooth();
  noLoop();

  PFont font = createFont("Verdana", 120);
  textFont(font);

  List<String> tokens = filterAndTokenizeInput();
  sorted = sortWordsByFrequency(tokens);
  println("Most popular word is: " + sorted.get(0).word);

  WordsLayout layout = new WordsLayout(sorted);
    //layout.layoutWordsInRectangular(N, width, height);
  layout.layoutWordsInSpiral(N, 0.2, 0.5);
}

void draw() {

  for (int i = 0; i < N; i++) {
    WordWithFrequency w = sorted.get(i);
    w.draw();
  }
}

