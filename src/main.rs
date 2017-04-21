extern crate caca;
#[macro_use] extern crate enum_derive;
#[macro_use] extern crate hlua;
#[macro_use] extern crate macro_attr;
extern crate rand;

#[macro_use] mod macros;
mod board;
mod canvas;
mod logging;
mod maker;
mod point;
mod random;
mod terrain;

use std::fs::File;
use std::io;
use std::io::prelude::*;

use caca::Event;
use hlua::Lua;

fn pause() {
    let mut stdin = io::stdin();
    let mut stdout = io::stdout();

    // We want the cursor to stay at the end of the line, so we print without a newline and flush manually.
    write!(stdout, "Press Enter to continue...").unwrap();
    stdout.flush().unwrap();

    // Read a single byte and discard
    let _ = stdin.read(&mut [0u8]).unwrap();
}

fn run_script(lua: &mut Lua, filename: &str) -> Result<(), hlua::LuaError> {
    let mut script = String::new();
    File::open(filename).expect("No script file").read_to_string(&mut script).unwrap();
    lua.execute::<()>(&script)
}

fn open_libs(lua: &mut Lua) -> Result<(), hlua::LuaError> {
    lua.openlibs();
    logging::add_lua_interop(lua);
    random::add_lua_interop(lua);
    maker::add_lua_interop(lua);
    run_script(lua, "lib/lib.lua")
}

fn main() {
    let mut lua = Lua::new();
    match open_libs(&mut lua) {
        Ok(_) => (),
        Err(err) => panic!("Lib open error! {:?}", err),
    }

    loop {
        match run_script(&mut lua, "scripts/test.lua") {
            Ok(_) => (),
            Err(err) => println!("Script error! {:?}", err),
        };
        println!("Ok.");
        loop {
            let event = canvas::get_event().unwrap();
            match event {
                Event::KeyPress(key) => match key {
                    caca::Key::Escape => return,
                    caca::Key::Return => break,
                    _           => (),
                },
                _ => (),
            }
        }
    }
}
