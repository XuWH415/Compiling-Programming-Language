We consider a very small subset of the Java language, which we call TinyJava. The appendix defines the syntax rules of this language, but you need to revise it into an LALR(1) equivalent so that the Yacc/Bison tool does not report any parsing conflicts. The lexical rules are the following.

Identifiers: An identifier is a sequence of letters, digits, and underscores, starting with a letter.
Uppercase letters are distinguished from lowercase. In this appendix the symbol id stands for an
identifier.

Integer literals: A sequence of decimal digits is an integer constant that denotes the corresponding
integer value. In this appendix the symbol INTEGER_LITERAL stands for an integer constant.

There are two Boolean constants: true and false, both in lower cases.

Binary operators: A binary operator is one of:
        && || < + ‐ *

Comments: A comment may appear between any two tokens. There are two forms of comments: One starts with /*, ends with */. Another kind of comments begins with // and goes to the end of the line.

White spaces (spaces, tabs, newlines) may be present in the input and should not be given to the parser.



Problem Description:
You are to write a lex/flex program and a yacc/bison program to parse a TinyJava program with no parsing conflicts reported. Do not use any precedence defining instructions as %left to resolve parsing conflicts. You then add semantic actions to find opportunities for constant folding as explained below.

Constant folding is performed by most compilers of today to find subexpressions that operate on known constants such that they do not need to be executed at run time. Such constant subexpressions exist often due to macro definitions made by the programmer.

For example, for a statement “a = (3+5)*7;” the compiler would recognize it to be “a = 56;” Your parser will not be required to modify the given statement. Instead, for each operation found to be operated n constants, your semantic actions must print out, in a separate line, the result of the operation. Hence for this example, your semantic action prints:
        8
        56

To simplify the requirement, we do not require your parser to reorder the operations in order to increase opportunities for constant folding. Instead you only report constant subexpressions according to the common operation precedence rules, as recited below.

If an expression contains a mixture of operators but it has no parentheses, then * is performed first, + and – are performed next, < comes next, followed by the && operation, and finally ||. Operators of the same precedence level are performed left to right. Parentheses override the above rules.

Hence, for the assignment statement “a = b+3*5;” Your semantic actions print
        15

However, for the assignment statement “a = “b*3*5;” your semantic actions print nothing, because by left associativity, b*3 is performed first, which is not a constant subexpression.

You do not need to remember variables that have constant values.

Other than constant folding, no other semantic actions are required. For instance, no type checking is required. Constant subexpressions given in the input will be assumed to be correct in terms of type rules.

You are responsible for finding arithmetic constant subexpressions and boolean constant subexpressions. However, you are not responsible for finding opportunities such as “1 < 2” being true.
