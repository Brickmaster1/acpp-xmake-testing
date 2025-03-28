set_languages("c++20")

-- local script_suffix = is_host("windows") and ".cmd" or ""
-- local wrapper_path = path.join(os.tmpdir(), "zigcc", "cc") .. script_suffix
-- set_toolset("clang", wrapper_path)
-- -- set_toolset("clangxx", "C:/msys64/mingw64/bin/clang++")

add_repositories("overrides overrides")

add_requires("llvm", {system = false, configs = {clang = false}})
-- add_requires("libffi", {system = false, toolchain = "cross"})
-- add_requires("libxml2", {system = false})
add_requires("acpp")

target("acpp")
    set_kind("phony")
    on_run(function (target)
        add_packages("acpp")
    end)
target_end()