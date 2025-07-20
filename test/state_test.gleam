import functor
import gleeunit
import state

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn state_test() {
  let a = state.State(5)
  let b = a |> state.to_functor |> functor.fmap(fn(x) { x + 1 })
  assert b == functor.Functor(6)
}
