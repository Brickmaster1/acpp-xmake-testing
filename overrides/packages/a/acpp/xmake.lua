package("acpp")
    set_homepage("https://adaptivecpp.github.io/")
    set_description("The independent, community-driven platform for heterogeneous programming in C++")

    add_urls("https://github.com/AdaptiveCpp/AdaptiveCpp.git")
    add_versions("latest", "feature/link-into-llvm")

    add_deps("zlib-ng", {configs = {zlib_compat = true}})

    add_deps("llvm", {system = false, configs = {shared = true}})
    add_deps("openmp", "spirv-headers", "spirv-tools", "cmake")

    add_patches("latest", "patches/llvm_spirv_cmake.patch", "f6135dc338bb924625999850311930fa7ffb30e2767cd09f205a3f632b8f644d")
    add_patches("latest", "patches/mingw_lowest_bit.patch", "89cc710c1a7bd25b53c6582d851abce75169a700b74b5368667ca03b6866bb71")
    add_patches("latest", "patches/llvm_version_hack.patch", "d2f2e09f7d2e09c23dae5289f02dc382ea3c1d5091f802b19269e573255ed866")

    on_install(function (package)
        -- On Windows, auto-detect HIP_PLATFORM with a workaround, ROCm doesn't like you trying to do this when not in it's bin dir for some reason.
        if is_host("windows") then
            if not os.getenv("HIP_PLATFORM") then
                local hip_path = os.getenv("HIP_PATH")
                if hip_path then
                    local bin_dir = path.join(hip_path, "bin")
                    local old_dir = os.curdir()
                    os.cd(bin_dir)
                    local hipconfig_exe = "hipconfig"
                    if os.isfile("hipconfig.bin.exe") then
                        hipconfig_exe = "hipconfig.bin.exe"
                    elseif os.isfile("hipconfig.bat") then
                        hipconfig_exe = "hipconfig.bat"
                    end
                    local output = os.iorun(hipconfig_exe .. " --platform")
                    output = output:trim()
                    os.setenv("HIP_PLATFORM", output)
                    os.cd(old_dir)
                    cprint("Set HIP_PLATFORM to: " .. output)
                else
                    cprint("HIP_PATH is not set; cannot auto-detect HIP_PLATFORM.")
                end
            end
        end

        local zig_env = os.iorun("zig env")
        local zig_lib_dir = zig_env:match('"lib_dir"%s*:%s*"([^"]+)"'):gsub("\\\\", "/")

        -- if not zig_lib_dir then
        --     error("Could not determine Zig's lib directory from `zig env`")
        -- end

        cprint("Detected zig include path: " .. zig_lib_dir)

        -- Make sure LLVM_DIR is set (it must point to an LLVM 18.1.6 CMake configuration directory)
        -- if not os.getenv("LLVM_DIR") then
        --     error("LLVM_DIR environment variable is not set. Please set it to a valid LLVM installation.")
        -- end

        local configs = {}

        local script_suffix = is_host("windows") and ".cmd" or ""
        local wrapper_path = path.join(os.tmpdir(), "zigcc", "cc") .. script_suffix
        table.insert(configs, "-DCLANG_EXECUTABLE_PATH=" .. wrapper_path)
        table.insert(configs, "-DCLANG_INCLUDE_PATH=" .. zig_lib_dir)

        -- table.insert(configs, "-DLLVM_ROOT=" .. path.join(package:dep("llvm"):installdir(), "llvm", "cmake", "modules"))
        table.insert(configs, "-DLLVM_DIR=" .. path.join(package:dep("llvm"):installdir(), "llvm", "cmake", "modules"))

        table.insert(configs, "-DLLVM_VERSION_SHIM=" .. "18")

        table.insert(configs, "-DLLVM_VERSION_MAJOR=" .. "18")
        table.insert(configs, "-DPLUGIN_LLVM_VERSION_MAJOR=" .. "18")
        table.insert(configs, "-DLLVM_VERSION_MINOR=" .. "1")
        table.insert(configs, "-DLLVM_VERSION_PATCH=" .. "6")

        table.insert(configs, "-DOpenMP_libomp_LIBRARY=" .. package:dep("libomp"):installdir("lib"))
        table.insert(configs, "-DOpenMP_C_FLAGS=-fopenmp")
        table.insert(configs, "-DOpenMP_C_LIB_NAMES=libomp")
        table.insert(configs, "-DOpenMP_CXX_FLAGS=-fopenmp")
        table.insert(configs, "-DOpenMP_CXX_LIB_NAMES=libomp")
        table.insert(configs, "-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=" .. package:dep("spirv-headers"):installdir("include"))
        table.insert(configs, "-DACPP_COMPILER_FEATURE_PROFILE=full")

        import("package.tools.cmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("add", {includes = "foo.h"}))
    -- end)
