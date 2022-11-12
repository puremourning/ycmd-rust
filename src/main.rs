use autocxx::prelude::*;

include_cpp! {
  #include "rust.h"
  safety!(unsafe)
  generate!("YouCompleteMe::IdentifierCompleter")
}

fn main() {
  let mut c = ffi::YouCompleteMe::IdentifierCompleter::new1().within_unique_ptr();
  c.pin_mut().AddSingleIdentifierToDatabase( "Test", "test", "/test" );
  c.pin_mut().AddSingleIdentifierToDatabase( "taste", "test", "/test" );
  c.pin_mut().AddSingleIdentifierToDatabase( "VeryTasty", "test", "/test" );
  c.pin_mut().AddSingleIdentifierToDatabase( "VeryToasty", "test", "/test" );
  cxx::let_cxx_string! ( t = "test" );
  let candidates = c.CandidatesForQueryAndType("VT", &t, 0 );
  for candidate in candidates.as_ref().unwrap() {
    println!( "{}", candidate );
  }
}

