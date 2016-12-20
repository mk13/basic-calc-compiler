import 'dart:collection';
import 'token.dart';
import 'visitor.dart';

abstract class Expression {
  dynamic accept(Visitor v);
}

class LiteralExpression extends Expression {
  int value;

  dynamic accept(Visitor v){
    return v.visitLiteralExpression(this);
  }

  LiteralExpression(this.value);
}

class AdditionExpression extends Expression{
  Expression left;
  Expression right;

  @override
  dynamic accept(Visitor v){
    return v.visitAdditionExpression(this);
  }

  AdditionExpression(this.left, this.right);
}

class SubtractionExpression extends Expression{
  Expression left;
  Expression right;

  @override
  dynamic accept(Visitor v){
    return v.visitSubtractionExpression(this);
  }

  SubtractionExpression(this.left, this.right);
}

class MultiplicationExpression extends Expression{
  Expression left;
  Expression right;

  @override
  dynamic accept(Visitor v){
    return v.visitMultiplicationExpression(this);
  }

  MultiplicationExpression(this.left, this.right);
}

class DivisionExpression extends Expression{
  Expression left;
  Expression right;

  @override
  dynamic accept(Visitor v){
    return v.visitDivisionExpression(this);
  }

  DivisionExpression(this.left, this.right);
}

class Parser {
  Token currentToken;
  Parser(this.currentToken);


  Expression parseExpression(){
    Queue<Token> outputQueue = new Queue<Token>();
    List<Token> opStack = [];

    //Shunting-yard
    while (currentToken.type != TokenType.EOF){
      if (currentToken is NumberToken){
        outputQueue.add(currentToken);
      }
      else if (currentToken is OperatorToken){
        while (opStack.isNotEmpty &&
            currentToken is! BeginToken &&
            currentToken.type.precedence <= opStack.last.type.precedence){
          outputQueue.add(opStack.removeLast());
        }
        opStack.add(currentToken);
      }
      else if (currentToken is BeginToken){
        opStack.add(currentToken);
      }
      else if (currentToken is EndToken){
        Token topToken = opStack.removeLast();
        while (topToken is! BeginToken){
          outputQueue.add(topToken);
          topToken =  opStack.removeLast();
        }
      }
      currentToken = currentToken.next;
    }
    while (opStack.isNotEmpty){
      outputQueue.add(opStack.removeLast());
    }

    //right, then left
    List<Expression> eStack = [];
    Token currToken;
    while (outputQueue.isNotEmpty){
      currToken = outputQueue.removeFirst();
      if (currToken is NumberToken){
        eStack.add(new LiteralExpression(int.parse(currToken.numericalValue)));
      }
      else if (currToken is OperatorToken){
        Expression right = eStack.removeLast();
        Expression left = eStack.removeLast();
        Expression newExpression;

        if (currToken.type.isAdditionOperator){
          newExpression = new AdditionExpression(left,right);
        }
        else if (currToken.type.isSubtractionOperator){
          newExpression = new SubtractionExpression(left,right);
        }
        else if (currToken.type.isMultiplicationOperator){
          newExpression = new MultiplicationExpression(left,right);
        }
        else{
          newExpression = new DivisionExpression(left,right);
        }
        eStack.add(newExpression);
      }
    }
    return eStack.removeLast();
  }
}
