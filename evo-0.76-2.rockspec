package = "evo"
version = "0.76-2"
source = {
    url = "https://github.com/0xh7/evo.git",
    dir = "evo.lua"  -- 
}
description = {
    summary = "The evo library is a library for creating HTML element websites.",
    detailed = [[
       The evo library is an advanced library that aims to create websites using the Lua language and interprets it from HTML. It is easy to learn, smooth, and fast, and it develops day after day.
    ]],
    homepage = "https://evolir.neocities.org/evo/",
    license = "MIT"
}
dependencies = {
    "lua >= 5.1"
}
build = {
    type = "builtin",
    modules = {
        evo = "evo.lua"  
    }
}
