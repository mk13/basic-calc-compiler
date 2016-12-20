import 'scanner.dart';
import 'token.dart';
import 'ast.dart';
import 'visitor.dart';

void main(){
  StringScanner sc = new StringScanner("1 + 2 * (2 + 5) - 4 * (3 + 2)");
  Token tokenChain = sc.tokenize();
  Parser p = new Parser(tokenChain);
  Expression e = p.parseExpression();
  Visitor eVisitor = new EvaluationVisitor();
  Visitor pVisitor = new PrintVisitor();
  int sol = e.accept(eVisitor);
  print(sol);
  print(e.accept(pVisitor));
  print("DONE");
}
