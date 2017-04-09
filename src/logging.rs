use hlua::{self, Lua};

fn lua_println(arg: String) {
    println!("{}", arg)
}

pub fn add_lua_interop(lua: &mut Lua) {
    let mut log_namespace = lua.empty_array("log");

    log_namespace.set("println", hlua::function1(lua_println));
}
