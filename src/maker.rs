use hlua::{self, Lua};

use board::*;
use canvas;
use point::*;
use terrain::*;

pub fn print_result() {
    instance::with(|b| canvas::print(b));
}

// hlua can't use references to structs inside the lua stack or even read
// userdata. So the best we can do is use a static global instance variable
// (there will only ever be one) and make changes to it.
make_global!(BOARD, Board, Board::new(1, 1, Terrain::Floor));

#[derive(Debug)]
pub enum MakerError {
    TerrainNotFound(String),
    OutOfBounds(i32, i32),
    BadRange(i32, i32),
}

use self::MakerError::*;

pub type MakerResult<T> = Result<T, MakerError>;

pub fn lua_new(x: i32, y: i32, fill: String) -> MakerResult<()> {
    let terrain = match fill.parse::<Terrain>() {
        Ok(t)     => t,
        Err(_)    => return Err(TerrainNotFound(fill)),
    };

    instance::with_mut(|b| *b = Board::new(x, y, terrain));
    canvas::set_size(x, y);
    Ok(())
}

pub fn lua_get(x: i32, y: i32) -> MakerResult<String> {
    instance::with(|b| {
        let pt = Point::new(x, y);
        if !b.in_bounds(&pt) {
            return Err(OutOfBounds(x, y));
        }
        Ok(format!("{:?}", b.get(&pt)))
    })
}

pub fn lua_set(x: i32, y: i32, name: String) -> MakerResult<()> {
    let terrain = match name.parse::<Terrain>() {
        Ok(t)     => t,
        Err(_)    => return Err(TerrainNotFound(name)),
    };

    instance::with_mut(|b| b.set(&Point::new(x, y), terrain));
    Ok(())
}

pub fn lua_blocked(x: i32, y: i32) -> bool {
    instance::with(|b| {
        let pt = Point::new(x, y);
        if !b.in_bounds(&pt) {
            return true
        }
        b.get(&pt).is_blocking()
    })
}

pub fn lua_in_bounds(x: i32, y: i32) -> bool {
    instance::with(|b| {
        let pt = Point::new(x, y);
        b.in_bounds(&pt)
    })
}

pub fn lua_width() -> i32 {
    instance::with(|b| b.width())
}

pub fn lua_height() -> i32 {
    instance::with(|b| b.height())
}

pub fn add_lua_interop(lua: &mut Lua) {
    let mut board_namespace = lua.empty_array("wrl");

    board_namespace.set("print_result", hlua::function0(print_result));
    board_namespace.set("new", hlua::function3(lua_new));
    board_namespace.set("set_raw", hlua::function3(lua_set));
    board_namespace.set("get_raw", hlua::function2(lua_get));
    board_namespace.set("blocked_raw", hlua::function2(lua_blocked));
    board_namespace.set("in_bounds_raw", hlua::function2(lua_in_bounds));
    board_namespace.set("width", hlua::function0(lua_width));
    board_namespace.set("height", hlua::function0(lua_height));
}
