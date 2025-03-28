package("libomp")

    set_homepage("https://openmp.llvm.org/")
    set_description("LLVM's OpenMP runtime library.")

    set_urls("https://github.com/llvm/llvm-project/releases/download/llvmorg-$(version)/openmp-$(version).src.tar.xz")
    add_versions("10.0.1", "d19f728c8e04fb1e94566c8d76aef50ec926cd2f95ef3bf1e0a5de4909b28b44")
    add_versions("11.1.0", "d187483b75b39acb3ff8ea1b7d98524d95322e3cb148842957e9b0fbb866052e")
    add_versions("12.0.1", "60fe79440eaa9ebf583a6ea7f81501310388c02754dbe7dc210776014d06b091")
    add_versions("18.1.6", "24ffd900fc7b707fda3a2d3b4aa011289d5a5fedff19c348dfdc4351f7063aae")
    -- add_versions("19.1.0", "c036fd95c8eeea8d7bce4196ee20cc5c5a99702d6ec7f0bb19828e315bc3a9ac")

    add_resources("18.1.6", "llvm_cmake", "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.6/cmake-18.1.6.src.tar.xz", "a643261ed98ff76ab10f1a7039291fa841c292435ba1cfe11e235c2231b95cdb")
    -- add_resources("19.1.0", "llvm_cmake", "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.0/cmake-19.1.0.src.tar.xz", "dc78b6a9ac8a097ca6ac0f23c06821d65e6ea3bf666026f529994c1d01056ae7")

    add_configs("shared", {description = "Build shared library.", default = true, type = "boolean"})

    add_deps("cmake")

    on_load(function (package)
        if package:version():ge("18.0") and package:is_built() then
            package:add("deps", "python 3.x", {kind = "binary"})
        end
    end)

    on_install(function (package)
        local version = package:version()
        if version:ge("18.0") then
            local llvm_cmake = package:resourcedir("llvm_cmake")
            local cmake = os.dirs(path.join(llvm_cmake, "*.src"))
            if #cmake > 0 then
                local cmake_util_dir = cmake[1]
                cmake_util_dir = cmake_util_dir:gsub("\\", "/")
                io.gsub("CMakeLists.txt", "set%(LLVM_COMMON_CMAKE_UTILS .-%)", "set(LLVM_COMMON_CMAKE_UTILS \"" .. cmake_util_dir .. "\")")
            end
            io.replace("CMakeLists.txt", "include(OpenMPTesting)", "function(add_openmp_testsuite target comment)\nreturn()\nendfunction()", {plain = true})
            io.replace("CMakeLists.txt", "construct_check_openmp_target()", "", {plain = true})
            io.replace("runtime/test/CMakeLists.txt", "update_test_compiler_features", "#update_test_compiler_features", {plain = true})
        end

        local configs = {"-DOPENMP_STANDALONE_BUILD=ON", "-DOPENMP_ENABLE_LIBOMPTARGET=OFF", "-DLIBOMP_INSTALL_ALIASES=OFF"}
        local shared = package:config("shared")
        table.insert(configs, "-DBUILD_SHARED_LIBS=" .. (shared and "ON" or "OFF"))
        table.insert(configs, "-DLIBOMP_ENABLE_SHARED=" .. (shared and "ON" or "OFF"))
        table.insert(configs, "-DLIBOMP_OMPD_GDB_SUPPORT=" .. (package:is_cross() and "OFF" or "ON"))

        
        import("package.tools.cmake").install(package, configs)

        if package:config("shared") then
            os.mv(path.join(package:installdir("lib"), "libomp.dll.a"), path.join(package:installdir("lib"), "libomp.a"))
        end
    end)

    on_test(function (package)
        assert(package:has_cfuncs("omp_get_thread_num", {includes = "omp.h"}))
    end)