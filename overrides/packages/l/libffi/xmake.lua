package("libffi")
    set_homepage("https://sourceware.org/libffi/")
    set_description("Portable Foreign Function Interface library.")
    set_license("MIT")

    set_urls("https://github.com/blade-lang/ffi.git")

    add_versions("latest", "main")

    add_patches("latest", "patches/mingw_build.patch", "b4c8eebfce3031457875940eb3c5518f5ab787c99b25bb8f6cb17a0dfd975a42")

    add_deps("cmake")

    on_install(function (package)
        local configs = {
            "-DINSTALL_DIRECTORY=" .. package:installdir()
        }
        
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        table.insert(configs, "-DFFI_USE_SHARED_LIBS=" .. (package:config("shared") and "ON" or "OFF"))
        import("package.tools.cmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("ffi_closure_alloc", {includes = "ffi.h"}))
    end)