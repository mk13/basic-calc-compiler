import 'ast.dart';

abstract class Visitor<R>{
  R visitLiteralExpression(LiteralExpression expr);
  R visitAdditionExpression(AdditionExpression expr);
  R visitSubtractionExpression(SubtractionExpression expr);
  R visitMultiplicationExpression(MultiplicationExpression expr);
  R visitDivisionExpression(DivisionExpression expr);
}

class EvaluationVisitor extends Visitor<int>{
  int visitLiteralExpression(LiteralExpression expr){
    return expr.value;
  }

  int visitAdditionExpression(AdditionExpression expr){
    return expr.left.accept(this) + expr.right.accept(this);
  }

  int visitSubtractionExpression(SubtractionExpression expr){
    return expr.left.accept(this) - expr.right.accept(this);
  }

  int visitMultiplicationExpression(MultiplicationExpression expr){
    return expr.left.accept(this) * expr.right.accept(this);
  }

  int visitDivisionExpression(DivisionExpression expr){
    return expr.left.accept(this) ~/ expr.right.accept(this);
  }
}

class PrintVisitor extends Visitor<String>{
  String visitLiteralExpression(LiteralExpression expr){
    return expr.value.toString();
  }

  String visitAdditionExpression(AdditionExpression expr){
    return expr.left.accept(this) + " + " + expr.right.accept(this);
  }

  String visitSubtractionExpression(SubtractionExpression expr){
    return expr.left.accept(this) + " - " + expr.right.accept(this);
  }

  String visitMultiplicationExpression(MultiplicationExpression expr){
    return
        ((expr.left is LiteralExpression) ?
        (expr.left.accept(this)):
        ("(" + expr.left.accept(this) + ")")) +
        ((expr.right is LiteralExpression) ?
          (" * " + expr.right.accept(this) + ""):
          (" * (" + expr.right.accept(this) + ")"));
  }

  String visitDivisionExpression(DivisionExpression expr) {
    return
      ((expr.left is LiteralExpression) ?
      (expr.left.accept(this)):
      ("(" + expr.left.accept(this) + ")")) +
          ((expr.right is LiteralExpression) ?
          (" / " + expr.right.accept(this) + ""):
          (" / (" + expr.right.accept(this) + ")"));
  }
}