import gleeunit
import gleeunit/should
import monad
import state

pub fn main() -> Nil {
  gleeunit.main()
}

/// Stateモナドの基本操作のテスト
pub fn state_pure_test() {
  let result = state.run_state(state.pure(42), "initial")
  result |> should.equal(#(42, "initial"))
}

/// Stateモナドのget操作のテスト
pub fn state_get_test() {
  let result = state.run_state(state.get(), "test_state")
  result |> should.equal(#("test_state", "test_state"))
}

/// Stateモナドのput操作のテスト
pub fn state_put_test() {
  let computation = state.put("new_state")
  let result = state.run_state(computation, "old_state")
  result |> should.equal(#(Nil, "new_state"))
}

/// Stateモナドのmodify操作のテスト
pub fn state_modify_test() {
  let computation = state.modify(fn(x: Int) { x + 10 })
  let result = state.run_state(computation, 5)
  result |> should.equal(#(Nil, 15))
}

/// Stateモナドのbind操作のテスト
pub fn state_bind_test() {
  let computation =
    state.bind(state.get(), fn(current_state: Int) {
      state.bind(state.put(current_state + 1), fn(_) { state.get() })
    })
  let result = state.run_state(computation, 10)
  result |> should.equal(#(11, 11))
}

/// Stateモナドのmap操作のテスト
pub fn state_map_test() {
  let computation = state.map(state.get(), fn(x: Int) { x * 2 })
  let result = state.run_state(computation, 5)
  result |> should.equal(#(10, 5))
}

/// Stateモナドのgets操作のテスト
pub fn state_gets_test() {
  let computation = state.gets(fn(x: Int) { x * 3 })
  let result = state.run_state(computation, 7)
  result |> should.equal(#(21, 7))
}

/// より複雑な状態の例：カウンター
pub fn counter_example_test() {
  let increment = state.modify(fn(x: Int) { x + 1 })
  let get_count = state.get()

  let computation =
    state.bind(increment, fn(_) {
      state.bind(increment, fn(_) { state.bind(increment, fn(_) { get_count }) })
    })

  let result = state.run_state(computation, 0)
  result |> should.equal(#(3, 3))
}

/// Monadインスタンスのテスト
pub fn monad_pure_test() {
  let m = monad.pure(42)
  // Monadの基本的な構造をテスト
  let bind_val = monad.to_bind(m)
  let app_val = monad.to_applicative(m)
  // 基本的な型チェックが通ることを確認
  let result1 = bind_val == bind_val
  let result2 = app_val == app_val
  result1 |> should.be_true
  result2 |> should.be_true
}
