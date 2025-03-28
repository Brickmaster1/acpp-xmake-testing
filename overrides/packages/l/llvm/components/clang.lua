function get_links(package)
    local links = {
        "clang-cpp",
        "clang",
        "clangAPINotes",
        "clangARCMigrate",
        "clangAST",
        "clangASTMatchers",
        "clangAnalysis",
        "clangAnalysisFlowSensitive",
        "clangApplyReplacements",
        "clangBasic",
        "clangChangeNamespace",
        "clangCodeGen",
        "clangCrossTU",
        "clangDaemon",
        "clangDaemonTweaks",
        "clangDependencyScanning",
        "clangDirectoryWatcher",
        "clangDoc",
        "clangDriver",
        "clangDynamicASTMatchers",
        "clangEdit",
        "clangFormat",
        "clangFrontend",
        "clangFrontendTool",
        "clangHandleCXX",
        "clangHandleLLVM",
        "clangIncludeFixer",
        "clangIncludeFixerPlugin",
        "clangIndex",
        "clangIndexSerialization",
        "clangInterpreter",
        "clangLex",
        "clangMove",
        "clangParse",
        "clangQuery",
        "clangReorderFields",
        "clangRewrite",
        "clangRewriteFrontend",
        "clangSema",
        "clangSerialization",
        "clangStaticAnalyzerCheckers",
        "clangStaticAnalyzerCore",
        "clangStaticAnalyzerFrontend",
        "clangTesting",
        "clangTidy",
        "clangTidyAbseilModule",
        "clangTidyAlteraModule",
        "clangTidyAndroidModule",
        "clangTidyBoostModule",
        "clangTidyBugproneModule",
        "clangTidyCERTModule",
        "clangTidyConcurrencyModule",
        "clangTidyCppCoreGuidelinesModule",
        "clangTidyDarwinModule",
        "clangTidyFuchsiaModule",
        "clangTidyGoogleModule",
        "clangTidyHICPPModule",
        "clangTidyLLVMLibcModule",
        "clangTidyLLVMModule",
        "clangTidyLinuxKernelModule",
        "clangTidyMPIModule",
        "clangTidyMain",
        "clangTidyMiscModule",
        "clangTidyModernizeModule",
        "clangTidyObjCModule",
        "clangTidyOpenMPModule",
        "clangTidyPerformanceModule",
        "clangTidyPlugin",
        "clangTidyPortabilityModule",
        "clangTidyReadabilityModule",
        "clangTidyUtils",
        "clangTidyZirconModule",
        "clangTooling",
        "clangToolingASTDiff",
        "clangToolingCore",
        "clangToolingInclusions",
        "clangToolingRefactoring",
        "clangToolingSyntax",
        "clangTransformer",
        "clangdRemoteIndex",
        "clangdSupport",
        "clangdXpcJsonConversions",
        "clangdXpcTransport"
    }
    return links
end

function main(package, component)
    component:add("links", get_links(package))
end

