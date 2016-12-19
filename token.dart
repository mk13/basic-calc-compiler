import 'dart:collection';
import 'syntactic_entity.dart';

abstract class Token implements SyntacticEntity{

  factory Token(TokenType type, int offset) = SimpleToken;

  @override
  int get end;

  bool get isOperator;

  bool get isSynthetic;
  
  @override
  int get length;

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

  static const TokenClass ADDITIVE_OPERATOR = 
    const TokenClass('ADDITIVE_OPERATOR', 13);

  static const TokenClass ASSIGNMENT_OPERATOR = 
    const TokenClass("ASSIGNMENT_OPERATOR", 1);
  
  static const TokenClass MULTIPLICATIVE_OPERATOR = 
    const TokenClass('MULTIPLICATIVE_OPERATOR', 8);

  static const TokenClass UNARY_POSTFIX_OPERATOR = 
    const TokenClass('UNARY_POSTFIX_OPERATOR', 16);

  final String name;

  final int precedence;

  const TokenClass(this.name, [this.precedence = 0]);

  @override
  String toString() => name;
}

class TokenType {
  static const TokenType EOF = const _EndOfFileTokenType();
  static const TokenType INT = const TokenType._('INT');
  static const TokenType MINUS = const TokenType._('MINUS', TokenClass.ADDITIVE_OPERATOR, '-');
  static const TokenType OPEN_PAREN = 
    const TokenType._('OPEN_PAREN', TokenClass.UNARY_POSTFIX_OPERATOR, '');
  static const TokenType CLOSE_PAREN =
    const TokenType._('CLOSE_PAREN', TokenClass.NO_CLASS, '');
  static const TokenType SLASH = 
    const TokenType._('SLASH', TokenClass.MULTIPLICATIVE_OPERATOR, '/');
  static const TokenType STAR = 
    const TokenType._('STAR', TokenClass.MULTIPLICATIVE_OPERATOR, '*');
  static const TokenType PLUS = 
    const TokenType._('PLUS', TokenClass.ADDITIVE_OPERATOR, '+');

}

class _EndOfFileTokenType extends TokenType {
  const _EndOfFileTokenType() : super._('EOF', TokenClass.NO_CLASS, '');

  @override
  String toString() => '-eof-';
}
