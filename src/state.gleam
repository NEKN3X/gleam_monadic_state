import functor
import monad

/// State monad - 状態を持つ計算を表現します
pub type State(s, a) {
  State(run: fn(s) -> #(a, s))
}

/// StateをMonadとして扱うためのラッパー
pub fn to_monad(state: State(s, a)) -> monad.Monad(State(s, a)) {
  monad.pure(state)
}

/// Stateの計算を実行します
pub fn run_state(state: State(s, a), initial_state: s) -> #(a, s) {
  case state {
    State(run: f) -> f(initial_state)
  }
}

/// 値をStateモナドでラップします
pub fn pure(value: a) -> State(s, a) {
  State(run: fn(state) { #(value, state) })
}

/// Stateモナドのbindオペレーション
pub fn bind(state: State(s, a), f: fn(a) -> State(s, b)) -> State(s, b) {
  State(run: fn(initial_state) {
    let #(value, new_state) = run_state(state, initial_state)
    let next_state = f(value)
    run_state(next_state, new_state)
  })
}

/// Stateモナドのmapオペレーション
pub fn map(state: State(s, a), f: fn(a) -> b) -> State(s, b) {
  bind(state, fn(value) { pure(f(value)) })
}

/// 現在の状態を取得します
pub fn get() -> State(s, s) {
  State(run: fn(state) { #(state, state) })
}

/// 状態を設定します
pub fn put(new_state: s) -> State(s, Nil) {
  State(run: fn(_) { #(Nil, new_state) })
}

/// 状態を変更します
pub fn modify(f: fn(s) -> s) -> State(s, Nil) {
  State(run: fn(state) { #(Nil, f(state)) })
}

/// 状態から値を取得します
pub fn gets(f: fn(s) -> a) -> State(s, a) {
  State(run: fn(state) { #(f(state), state) })
}

/// StateをFunctorとして扱います
pub fn to_functor(self: State(s, a)) -> functor.Functor(State(s, a)) {
  functor.Functor(self)
}
