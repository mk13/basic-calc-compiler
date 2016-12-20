import 'syntactic_entity.dart';

class BeginToken extends SimpleToken {
  BeginToken(int offset) : super(TokenType.OPEN_PAREN, offset);

  @override
  Token copy() => new BeginToken(offset);
}

class EndToken extends SimpleToken {
  EndToken(int offset) : super(TokenType.CLOSE_PAREN, offset);

  @override
  Token copy() => new EndToken(offset);
}

class NumberToken extends SimpleToken {
  String numericalValue;

  NumberToken(int offset, this.numericalValue) : super(TokenType.NUMBER, offset);
}

class OperatorToken extends SimpleToken {
  OperatorToken(TokenType type, int offset) : super(type, offset);

  int get precedence => type.precedence;
}

class SimpleToken implements Token {
  @override
  final TokenType type;

  @override
  int offset = 0;

  @override
  Token previous;

  Token _next;

  SimpleToken(this.type, this.offset);

  @override
  int get end => offset + length;

  @override
  bool get isOperator => type.isOperator;

  @override
  bool get isSynthetic => length == 0;

  @override
  int get length => lexeme.length;

  String get lexeme => type.lexeme;

  @override
  Token get next => _next;

  @override
  Token copy() => new Token(type,offset);

  @override
  bool matchesAny(List<TokenType> types){
    for (TokenType type in types){
      if (this.type == type){
        return true;
      }
    }
    return false;
  }

  @override
  Token setNext(Token token){
    _next = token;
    token.previous = this;
    return token;
  }

  @override
  Token setNextWithoutSettingPrevious(Token token){
    _next = token;
    return token;
  }

  @override
  String toString() => lexeme;

  @override
  Object value() => type.lexeme;
}

abstract class Token implements SyntacticEntity{

  factory Token(TokenType type, int offset) = SimpleToken;

  bool get isOperator;

  bool get isSynthetic;

  Token get next;

  @override
  int get offset;

  void set offset(int offset);

  Token get previous;

  void set previous(Token token);

  TokenType get type;

  Token copy();

  bool matchesAny(List<TokenType> types);

  /**
   * Sets next token and returns that token. Also sets the previous of passed token.
   */
  Token setNext(Token token);

  /**
   * Sets next token but doesn't set its previous. Returns the passed token.
   */
  Token setNextWithoutSettingPrevious(Token token);

  Object value();
}

class TokenClass {
  static const TokenClass NO_CLASS = const TokenClass('NO_CLASS');

  static const TokenClass ADDITION_OPERATOR =
    const TokenClass('ADDITION_OPERATOR', 3);

  static const TokenClass SUBTRACTION_OPERATOR =
    const TokenClass('SUBTRACTION_OPERATOR', 3);

  static const TokenClass MULTIPLICATION_OPERATOR =
    const TokenClass('MULTIPLICATION_OPERATOR', 2);

  static const TokenClass DIVISION_OPERATOR =
    const TokenClass('DIVISION_OPERATOR', 2);

  static const TokenClass UNARY_POSTFIX_OPERATOR =
    const TokenClass('UNARY_POSTFIX_OPERATOR', 4);

  static const TokenClass NUMBER =
    const TokenClass('NUMBER', 1);


  final String name;

  final int precedence;

  const TokenClass(this.name, [this.precedence = 0]);

  @override
  String toString() => name;
}

class TokenType {
  static const TokenType EOF = const _EndOfFileTokenType();
  static const TokenType MINUS = const TokenType._('MINUS', TokenClass.SUBTRACTION_OPERATOR, '-', 1);
  static const TokenType OPEN_PAREN =
    const TokenType._('OPEN_PAREN', TokenClass.UNARY_POSTFIX_OPERATOR, '');
  static const TokenType CLOSE_PAREN =
    const TokenType._('CLOSE_PAREN', TokenClass.NO_CLASS, '');
  static const TokenType SLASH =
    const TokenType._('SLASH', TokenClass.DIVISION_OPERATOR, '/', 2);
  static const TokenType STAR =
    const TokenType._('STAR', TokenClass.MULTIPLICATION_OPERATOR, '*', 2);
  static const TokenType PLUS =
    const TokenType._('PLUS', TokenClass.ADDITION_OPERATOR, '+', 1);
  static const TokenType NUMBER =
    const TokenType._('NUMBER', TokenClass.NUMBER);

  bool get isMultiplicationOperator =>
    _tokenClass == TokenClass.MULTIPLICATION_OPERATOR;

  bool get isAdditionOperator =>
    _tokenClass == TokenClass.ADDITION_OPERATOR;

  bool get isSubtractionOperator =>
    _tokenClass == TokenClass.SUBTRACTION_OPERATOR;

  bool get isDivisionOperator =>
    _tokenClass == TokenClass.DIVISION_OPERATOR;

  bool get isUnaryPostfixOperator =>
    _tokenClass == TokenClass.UNARY_POSTFIX_OPERATOR;

  bool get isOperator =>
      _tokenClass != TokenClass.NO_CLASS &&
      this != OPEN_PAREN;


  final String name;
  final String lexeme;
  final int precedence;
  final TokenClass _tokenClass;

  const TokenType._(this.name,
      [this._tokenClass = TokenClass.NO_CLASS, this.lexeme = null, this.precedence = 0]);
}

class _EndOfFileTokenType extends TokenType {
  const _EndOfFileTokenType() : super._('EOF', TokenClass.NO_CLASS, '');

  @override
  String toString() => '-eof-';
}

