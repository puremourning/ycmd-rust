use autocxx::prelude::*;

include_cpp! {
  #include "rust.h"
  safety!(unsafe)
  generate!("YouCompleteMe::IdentifierCompleter")
}

fn main() {
  moveit! {
    let mut c = ffi::YouCompleteMe::IdentifierCompleter::new1()
  };
  let test = "test";
  let path = "/test";
  cxx::let_cxx_string!( ctest = test);
  c.as_mut().AddSingleIdentifierToDatabase( "vTest", test, path);
  c.as_mut().AddSingleIdentifierToDatabase( "vtaste", test, path);
  c.as_mut().AddSingleIdentifierToDatabase( "VeryTasty", test, path);
  c.as_mut().AddSingleIdentifierToDatabase( "VeryToasty", test, path);
  let candidates = c.CandidatesForQueryAndType("vt", &ctest, 0 );
  for candidate in candidates.as_ref().unwrap() {
    println!( "{}", candidate );
  }
}

