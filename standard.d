static import std.stdio;
static import std.conv;
static import core.stdc.stdlib;
static import std.range.primitives;

struct Primitive {
  void function() proc;
  int kind;
  real number;
  string str;
}

Primitive[] stack;

void std_dump() {
  if(stack.length > 0) {
    auto msg = "[ ";
    foreach(ix, i; stack) {
      if(i.kind == 0) {
        msg ~= "<number>(" ~ std.conv.to!string(i.number) ~ "), ";
      } else if(i.kind == 1) {
        msg ~= "<string>(" ~ i.str ~ "), ";
      } else {
        msg ~= "<procedure>(" ~ std.conv.to!string(i.proc) ~ "), ";
      }
    }
    std.stdio.writeln(msg ~ " ]");
  } else {
    std.stdio.writeln("[ ]");
  }
}

void std_append() {
  if(stack.length > 1) {
    auto a = stack[0];
    auto b = stack[1];
    std.range.primitives.popFrontN(stack, 2);
    Primitive tmp;
    tmp.kind = 1;
    tmp.str = a.str ~= b.str;
    stack ~= tmp;
    return;
  } else if(stack.length == 1) {
  } else {
    Primitive tmp;
    tmp.kind = 1;
    tmp.str = "";
    stack ~= tmp;
  }
}

void std_add() {
  if(stack.length > 1) {
    auto a = stack[0];
    auto b = stack[1];
    std.range.primitives.popFrontN(stack, 2);
    Primitive tmp;
    tmp.kind = 0;
    tmp.number = a.number + b.number;
    stack ~= tmp;
    return;
  } else if(stack.length == 1) {
  } else {
    Primitive tmp;
    tmp.kind = 0;
    tmp.number = 0;
    stack ~= tmp;
  }
}

void std_minus() {
  if(stack.length > 1) {
    auto a = stack[0];
    auto b = stack[1];
    std.range.primitives.popFrontN(stack, 2);
    Primitive tmp;
    tmp.kind = 0;
    tmp.number = a.number - b.number;
    stack ~= tmp;
    return;
  } else if(stack.length == 1) {
  } else {
    Primitive tmp;
    tmp.kind = 0;
    tmp.number = 0;
    stack ~= tmp;
  }
}

void std_multiply() {
  if(stack.length > 1) {
    auto a = stack[0];
    auto b = stack[1];
    std.range.primitives.popFrontN(stack, 2);
    Primitive tmp;
    tmp.kind = 0;
    tmp.number = a.number * b.number;
    stack ~= tmp;
    return;
  } else if(stack.length == 1) {
  } else {
    Primitive tmp;
    tmp.kind = 0;
    tmp.number = 0;
    stack ~= tmp;
  }
}

void std_divide() {
  if(stack.length > 1) {
    auto a = stack[0];
    auto b = stack[1];
    if(b.number == 0) {
      std.range.primitives.popFrontN(stack, 2);
      Primitive tmp;
      tmp.kind = 0;
      tmp.number = real.infinity;
      stack ~= tmp;
    } else {
      std.range.primitives.popFrontN(stack, 2);
      Primitive tmp;
      tmp.kind = 0;
      tmp.number = a.number / b.number;
      stack ~= tmp;
    }
    return;
  } else if(stack.length == 1) {
  } else {
    Primitive tmp;
    tmp.kind = 0;
    tmp.number = 0;
    stack ~= tmp;
  }
}

void std_print() {
  if(stack.length > 0) {
    auto token = stack[0];
    if(token.kind == 0) {
      std.stdio.writeln(token.number);
    } else if(token.kind == 1) {
      std.stdio.writeln(token.str);
    } else {
      std.stdio.writefln("<function: %s>", token.proc);
    }
  } else {
    std.stdio.write("");
  }
}

void std_exit() {
  core.stdc.stdlib.exit(0);
}