import 'token.dart';
import 'dart:core';

abstract class Scanner {
  Token tokenize();

  factory Scanner(String string){
    return new StringScanner(string);
  }
}

//Really bad scanner that probably shouldn't see the light of day
class StringScanner implements Scanner {

  String string;

  StringScanner(this.string);

  Token firstToken = new SimpleToken(TokenType.EOF, -1);
  Token currentToken;

  Token tokenize(){
    String seen = '';

    for (int i = 0; i < string.length; i++){
      String currString = string[i];
      if (currString == ' '){
        _interpretStringAndAppendToken(seen, i - seen.length);
        seen = '';
      }
      else if (_isOperator(currString)){
        _interpretStringAndAppendToken(seen, i - seen.length);
        seen = '';
        _interpretStringAndAppendToken(currString, i);
      }
      else{
        seen += string[i];
      }
    }
    _interpretStringAndAppendToken(seen, string.length-seen.length);
    currentToken.setNext(new Token(TokenType.EOF, -1));
    return firstToken;
  }

  void _interpretStringAndAppendToken(String s, int offset){
    if (s == null || s.isEmpty) return;
    try{
      int.parse(s);
      _appendToken(new NumberToken(offset, s));
    }on FormatException{
      if (s == "+"){
        _appendToken(new OperatorToken(TokenType.PLUS, offset));
      }
      else if (s == "-"){
        _appendToken(new OperatorToken(TokenType.MINUS, offset));
      }
      else if (s == "*"){
        _appendToken(new OperatorToken(TokenType.STAR, offset));
      }
      else if (s == '/') {
        _appendToken(new OperatorToken(TokenType.SLASH, offset));
      }
      else if (s == "(") {
        _appendToken(new BeginToken(offset));
      }
      else if (s == ")") {
        _appendToken(new EndToken(offset));
      }
      else{
        throw new UnsupportedError("Value of '$s' is not a valid operator token");
      }
    }
  }

  void _appendToken(Token newToken){
    if (currentToken == null){
      firstToken = newToken;
      currentToken = firstToken.setNext(newToken);
    }
    else{
      currentToken = currentToken.setNext(newToken);
    }
  }

  bool _isOperator(String s) => (s == "+")
      || (s == "-") || (s == "-") || (s == "/") || (s == "(") || (s == ")");
}
