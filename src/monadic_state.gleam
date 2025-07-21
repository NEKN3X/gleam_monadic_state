/// 状態の型sと返り値の型aを取る
/// run: 実行前の状態を受け取り、実行後の状態と実行結果を返す
pub type State(s, a) {
  St(run: fn(s) -> #(a, s))
}

pub fn run(st: State(s, a), input: s) -> #(a, s) {
  st.run(input)
}

// Functor
pub fn map(st: State(_, a), g: fn(a) -> b) -> State(_, b) {
  St(fn(input) {
    case run(st, input) {
      #(v, out) -> #(g(v), out)
    }
  })
}

// Applicative
pub fn pure(a) -> State(_, a) {
  St(fn(input) { #(a, input) })
}

// Apply
pub fn apply(sg: State(_, fn(a) -> b), sx: State(_, a)) -> State(_, b) {
  St(fn(input) {
    case run(sg, input) {
      #(g, out) -> run(map(sx, g), out)
    }
  })
}

/// Bind(Monad)
pub fn bind(st: State(_, a), f: fn(a) -> State(_, b)) -> State(_, b) {
  St(fn(input) {
    case run(st, input) {
      #(v, out) -> run(f(v), out)
    }
  })
}

pub fn get() -> State(s, s) {
  St(fn(s) { #(s, s) })
}

pub fn gets(f: fn(s) -> a) {
  St(fn(s) { #(f(s), s) })
}

pub fn put(x: s) -> State(s, Nil) {
  St(fn(_) { #(Nil, x) })
}

pub fn modify(f: fn(s) -> s) -> State(s, Nil) {
  St(fn(s) { #(Nil, f(s)) })
}

pub fn eval(st: State(s, a), x: s) -> a {
  run(st, x).0
}

pub fn exec(st: State(s, a), x: s) -> s {
  run(st, x).1
}
