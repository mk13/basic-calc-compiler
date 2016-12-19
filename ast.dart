import 'syntactic_entity.dart';
import 'token.dart';

abstract class AstNode implements SyntacticEntity{
  static const List<AstNode> EMPTY_LIST = const <AstNode>[];
  
  /**
   * Lexical comparator: 
   *  Return <0 if the first node comes before the second node.
   *  Returns >0 if the first node comes after the second.
   *  Returns 0 if same offset-position.  
   */ 
  static Comparator<AstNode> LEXICAL_ORDER = 
    (AstNode first, AstNode second) => first.offset - second.offset;


  /**
   * Return the first token included in this node's source range.
   */
  Token get beginToken;
  
  /**
   * Return an iterator that can be used to iterate through all 
   * the entities (either AST nodes or tokens) that make up the contents
   * of this node.
   */
  Iterable<SyntacticEntity> get childEntities;

  @override
  int get end;

  Token get endToken;

  /**
   * Returns 'true' if this node is a SYNTEHTIC NODE. A synthetic node is a
   * node that was introduced by the parser in order to recover from an error
   * in the code. Synthetic nodes always have a length of ZERO ('0').
   */
  bool get isSynthetic;

  @override
  int get length;

  @override
  int get offset;

  /**
   * Returns the node's parent node, or 'null' if this node is the root of 
   * an AST structure. 
   * Node that the relationship between an AST node and its parent node
   * may change over the lifetime of a node. 
   */
  AstNode get parent;

  /**
   * Return the node at the root of this node's AST structure. Note that this
   * method's performance is LINEAR with respect to the depth of the node in the
   * AST structure (O(depth))
   */
  AstNode get root;

  dynamic accept(AstVisitor visitor);
  
  void visitChildren(AstVisitor visitor);
}
