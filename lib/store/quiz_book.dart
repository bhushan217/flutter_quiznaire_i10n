import './question.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuizBook {
  int _currentIndex = 0;
  bool _completed = false;
  List<Question> questionBank = [];

  void initQuestions(AppLocalizations appLocalizations){
    questionBank.add(Question(appLocalizations.question1, true));
    questionBank.add(Question(appLocalizations.question2, true));
    questionBank.add(Question(appLocalizations.question3, false));
  }
  void reset(){
    _currentIndex = 0;
    _completed = false;
  }

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
    if(_currentIndex < getTotalQuestions() - 1) {
      _currentIndex++;
    }else{
      _completed = true;
    }
  }

  int getTotalQuestions() { return questionBank.length;}

}