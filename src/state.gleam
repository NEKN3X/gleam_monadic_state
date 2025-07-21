// 状態の型sと返り値の型a
pub type State(s, a) {
  State(run: fn(s) -> #(a, s))
}
