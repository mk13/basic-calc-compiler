import 'scanner.dart';
import 'token.dart';

int main(){
  StringScanner sc = new StringScanner("123+456");
  Token tokenChain = sc.tokenize();
}
