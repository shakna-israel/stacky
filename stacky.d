static import std.stdio;
static import std.conv;
static import std.string;
static import std.range.primitives;
static import std.algorithm.mutation;
static import std.file;

struct Primitive {
  void function() proc;
  int kind;
  double number;
  string str;
}

Primitive[] stack;

void std_add() {
  auto a = stack[0];
  auto b = stack[1];
  std.range.primitives.popFrontN(stack, 2);
  Primitive tmp;
  tmp.kind = 0;
  tmp.number = a.number + b.number;
  stack ~= tmp;
  return;
}

void std_minus() {
  auto a = stack[0];
  auto b = stack[1];
  std.range.primitives.popFrontN(stack, 2);
  Primitive tmp;
  tmp.kind = 0;
  tmp.number = a.number - b.number;
  stack ~= tmp;
  return;
}

void std_multiply() {
  auto a = stack[0];
  auto b = stack[1];
  std.range.primitives.popFrontN(stack, 2);
  Primitive tmp;
  tmp.kind = 0;
  tmp.number = a.number * b.number;
  stack ~= tmp;
  return;
}

void std_divide() {
  auto a = stack[0];
  auto b = stack[1];
  if(b.number == 0) {
    std.range.primitives.popFrontN(stack, 2);
    Primitive tmp;
    tmp.kind = 0;
    tmp.number = 0;
    stack ~= tmp;
  } else {
    std.range.primitives.popFrontN(stack, 2);
    Primitive tmp;
    tmp.kind = 0;
    tmp.number = a.number / b.number;
    stack ~= tmp;
  }
  return;
}

void std_print() {
  auto token = stack[0];
  if(token.kind == 0) {
    std.stdio.writeln(token.number);
  } else if(token.kind == 1) {
    std.stdio.writeln(token.str);
  } else {
    std.stdio.writefln("<function: %s>", token.proc);
  }
}

auto tokenise(string s)
{
  s ~= ' ';
  string[] ret;
  string token = "";
  auto inString = false;
  foreach(ix, c; s) {
    if(inString) {
      if(c == ']') {
        inString = false;
        token ~= c;
        ret ~= token;
        token = "";
      } else {
        token ~= c;
      }
    } else if(c == '[') {
      inString = true;
      token ~= '[';
    } else if(c == ' ' || c == '\n') {
      ret ~= token;
      token = "";
    } else if(c == '\r') {
      // Ignore the carriage return.
    } else {
      token ~= c;
    }
  }
  std.algorithm.mutation.reverse(ret);
  return ret;
}

auto parse(string[] ast)
{
  Primitive[] ret;
  
  foreach(ix, i; ast) {
    if(i.length > 0) {
    if(std.string.isNumeric(i)) {
      Primitive tmp;
      tmp.kind = 0;
      tmp.number = std.conv.to!double(i);
      ret ~= tmp;
    } else if(i[0] == '[' && i[i.length - 1] == ']') {
      Primitive tmp;
      tmp.kind = 1;
      auto a = i.length - 1;
      tmp.str = i[1..a];
      ret ~= tmp;
    } else {
      if(i == "+" || i == "add") {
        Primitive tmp;
        tmp.kind = 2;
        tmp.proc = &std_add;
        ret ~= tmp;
      } else if(i == "-" || i == "minus") {
        Primitive tmp;
        tmp.kind = 2;
        tmp.proc = &std_minus;
        ret ~= tmp;
      } else if(i == "*" || i == "multiply") {
        Primitive tmp;
        tmp.kind = 2;
        tmp.proc = &std_multiply;
        ret ~= tmp;
      } else if(i == "/" || i == "divide") {
        Primitive tmp;
        tmp.kind = 2;
        tmp.proc = &std_divide;
        ret ~= tmp;
      } else if(i == "|>" || i == "print") {
        Primitive tmp;
        tmp.kind = 2;
        tmp.proc = &std_print;
        ret ~= tmp;
      } else {
        std.stdio.writefln("Could not parse type of: <%s>", i);
        throw new std.string.StringException("Fatal Error: Failed to finish parsing.");
      }
    }
    }
  }
  return ret;
}

void eval(Primitive[] ast)
{
  foreach(ix, i; ast) {
    if(i.kind == 0 || i.kind == 1) {
      stack ~= i;
    } else {
      i.proc();
    }
  }
}

void help() {
  std.stdio.writeln("stacky - Help\n");
  std.stdio.writeln("stacky [options]");
  std.stdio.writeln("stacky [filename]");
  std.stdio.writeln("stacky --repl");
  std.stdio.writeln("stacky --help");
  std.stdio.writeln("stacky --version");
}

void main(string[] args)
{ 
  if(args.length > 1) {
    if(args[1] == "--help") {
      help();
    } else if(args[1] == "--version") {
      std.stdio.writeln("v0.0.0");
    } else if(args[1] == "--repl") {
      std.stdio.writeln("NOT YET IMPLEMENTED");
    } else {
      foreach(ix, i; args[1..args.length]) {
        if(std.file.exists(i) != true) {
          std.stdio.writefln("File not accessible: %s", i);
          throw new std.string.StringException("Fatal Error: Some files were not able to be accessed.");
        }
      }
      foreach(ix, i; args[1..args.length]) {
        auto file = std.stdio.File(i);
        auto range = file.byLine();
        foreach(line; range) {
          eval(parse(tokenise(std.conv.to!string(line))));
        }
      }
    }
  } else {
    help();
  }
}
