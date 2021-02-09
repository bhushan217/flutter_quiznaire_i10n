import './question.dart';

class QuizBook {
  int _currentIndex = 0;
  bool _completed = false;
  List<Question> questionBank = [
    Question('Is Mumbai in Maharashtra?', true),
    Question('Is 1+1 equals 2?', true),
    Question('Can Tomcat give milk?', false),
  ];

  String getQuestionText() {
    return questionBank[_currentIndex].text;
  }
  bool getCorrectAnswer() {
    return questionBank[_currentIndex].answer;
  }
  bool isCompleted() {
    return _completed == true;
  }
  int getCurrentIndex() {
    return _currentIndex;
  }
  void nextQuestion() {
    if(_currentIndex < questionBank.length - 1) {
      _currentIndex++;
    }else{
      _completed = true;
    }
  }

}