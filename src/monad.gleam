import applicative
import apply
import bind
import functor

/// Monad型は、ApplicativeとBindの組み合わせとして定義されます
pub type Monad(a) {
  Monad(applicative: applicative.Applicative(a), bind: bind.Bind(a))
}

pub fn to_bind(m: Monad(a)) -> bind.Bind(a) {
  case m {
    Monad(applicative: _, bind: b) -> b
  }
}

pub fn to_applicative(m: Monad(a)) -> applicative.Applicative(a) {
  case m {
    Monad(applicative: a, bind: _) -> a
  }
}

pub fn pure(value: a) -> Monad(a) {
  let app = applicative.pure(value)
  let bind_val = bind.pure(value)
  Monad(applicative: app, bind: bind_val)
}

pub fn bind(m: Monad(a), f: fn(a) -> Monad(b)) -> Monad(b) {
  case m {
    Monad(applicative: _, bind: b) -> {
      let bind_result =
        bind.bind(b, fn(x) {
          let new_monad = f(x)
          to_bind(new_monad)
        })
      // 新しいApplicativeをBindから作成
      let apply_val = bind.to_apply(bind_result)
      let new_app = applicative.from_bind(apply_val)
      Monad(applicative: new_app, bind: bind_result)
    }
  }
}

pub fn map(m: Monad(a), f: fn(a) -> b) -> Monad(b) {
  bind(m, fn(x) { pure(f(x)) })
}

pub fn flat_map(m: Monad(a), f: fn(a) -> Monad(b)) -> Monad(b) {
  bind(m, f)
}

pub fn compose(f: fn(a) -> Monad(b), g: fn(b) -> Monad(c)) -> fn(a) -> Monad(c) {
  fn(x) { bind(f(x), g) }
}

pub fn to_functor(m: Monad(a)) -> functor.Functor(a) {
  let app = to_applicative(m)
  let apply_val = applicative.to_apply(app)
  apply.to_functor(apply_val)
}

pub fn to_apply(m: Monad(a)) -> apply.Apply(a) {
  let app = to_applicative(m)
  applicative.to_apply(app)
}
