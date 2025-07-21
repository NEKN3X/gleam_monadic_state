import gleeunit
import gleeunit/should
import monadic_state as s

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn run_test() {
  s.St(fn(s) { #(s + 1, s + 2) })
  |> s.run(1)
  |> should.equal(#(2, 3))
}

pub fn eval_test() {
  s.St(fn(s) { #(s + 1, s + 2) })
  |> s.eval(1)
  |> should.equal(2)
}

pub fn exec_test() {
  s.St(fn(s) { #(s + 1, s + 2) })
  |> s.exec(1)
  |> should.equal(3)
}

pub fn pure_test() {
  s.pure(42)
  |> s.run(0)
  |> should.equal(#(42, 0))
}

fn tick() {
  use x <- s.bind(s.get())
  s.put(x + 1)
}

pub fn tick_test() {
  tick()
  |> s.run(0)
  |> should.equal(#(Nil, 1))
}

pub fn get_test() {
  s.get()
  |> s.run(42)
  |> should.equal(#(42, 42))
}

pub fn put_test() {
  s.put(42)
  |> s.run(0)
  |> should.equal(#(Nil, 42))
}

pub fn modify_test() {
  s.modify(fn(x) { x + 1 })
  |> s.run(2)
  |> should.equal(#(Nil, 3))
}

pub fn map_test() {
  s.St(fn(s) { #(1, s) })
  |> s.map(fn(n) { n + 1 })
  |> s.run(1)
  |> should.equal(#(2, 1))
}
