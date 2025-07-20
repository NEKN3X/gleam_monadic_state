pub type Functor(a) {
  Functor(a)
}

pub fn fmap(functor: Functor(a), f: fn(a) -> b) -> Functor(b) {
  case functor {
    Functor(a) -> Functor(f(a))
  }
}
