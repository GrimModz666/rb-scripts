print("=== UNC & SUNC TESTER ===")
print("Starting detection...")


local unc_total, unc_pass = 0, 0
local sunc_total, sunc_pass = 0, 0


local function addResult(name, passed, category)
    unc_total = unc_total + 1
    sunc_total = sunc_total + (category == "SUNC" and 1 or 0)
    
    if passed then
        if category == "UNC" then unc_pass = unc_pass + 1 end
        if category == "SUNC" then sunc_pass = sunc_pass + 1 end
        print("✅ [OK] [" .. category .. "] " .. name)
    else
        print("❌ [FAIL] [" .. category .. "] " .. name)
    end
end


local function runTests()
    print("\n--- UNC BYPASS TESTS (17 tests) ---")
    
    
    addResult("getgenv()", type(getgenv) == "function", "UNC")
    addResult("getfenv()", type(getfenv) == "function", "UNC")
    addResult("setfenv()", type(setfenv) == "function", "UNC")
    addResult("getmetatable()", type(getmetatable) == "function", "UNC")
    addResult("setmetatable()", type(setmetatable) == "function", "UNC")
    addResult("loadstring()", type(loadstring) == "function", "UNC")
    addResult("unpack()", type(unpack) == "function", "UNC")
    addResult("identifyexecutor()", pcall(function() return identifyexecutor and identifyexecutor() end), "UNC")
    addResult("writefile()", pcall(function() writefile("unc_test.txt", "test") end), "UNC")
    addResult("readfile()", pcall(function() readfile("unc_test.txt") end), "UNC")
    addResult("isfile()", type(isfile) == "function", "UNC")
    addResult("makefolder()", type(makefolder) == "function", "UNC")
    addResult("delfile()", pcall(function() delfile("unc_test.txt") end), "UNC")
    addResult("isfolder()", type(isfolder) == "function", "UNC")
    addResult("listfiles()", type(listfiles) == "function", "UNC")
    addResult("setclipboard()", pcall(function() setclipboard("hello") end), "UNC")
    addResult("getclipboard()", pcall(function() return getclipboard and getclipboard() end), "UNC")
    addResult("CoreGui Injection", pcall(function() 
        local CoreGui = game:GetService("CoreGui")
        local g = Instance.new("ScreenGui") 
        g.Parent = CoreGui 
        g:Destroy() -- Clean up
    end), "UNC")

    print("\n--- SUNC BYPASS TESTS (14 tests) ---")
    
    
    addResult("hookfunction()", pcall(function()
        local f = function() return 1 end
        hookfunction(f, function() return 2 end)
    end), "SUNC")
    addResult("getrawmetatable()", pcall(function() getrawmetatable(game) end), "SUNC")
    addResult("setreadonly()", pcall(function()
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
    end), "SUNC")
    addResult("debug.getinfo()", pcall(function() debug.getinfo(1) end), "SUNC")
    addResult("debug.setupvalue()", pcall(function()
        local a = function() end
        debug.setupvalue(a, 1, "test")
    end), "SUNC")
    addResult("debug.getupvalue()", type(debug.getupvalue) == "function", "SUNC")
    addResult("debug.getlocal()", type(debug.getlocal) == "function", "SUNC")
    addResult("debug.setlocal()", type(debug.setlocal) == "function", "SUNC")
    addResult("debug.traceback()", type(debug.traceback) == "function", "SUNC")
    addResult("debug.getregistry()", type(debug.getregistry) == "function", "SUNC")
    addResult("is_synapse_function()", type(is_synapse_function) == "function", "SUNC")
    addResult("setnamecallmethod()", pcall(function() setnamecallmethod("Name") end), "SUNC")
    addResult("getgc()", type(getgc) == "function", "SUNC")
    addResult("getupvalue()", type(getupvalue) == "function", "SUNC")

    
    local unc_percent = math.floor((unc_pass / 17) * 100)
    local sunc_percent = math.floor((sunc_pass / 14) * 100)
    
    print("\n" .. string.rep("=", 50))
    print("FINAL RESULTS")
    print(string.rep("=", 50))
    print("UNC Support:  " .. unc_percent .. "% (" .. unc_pass .. "/17)")
    print("SUNC Support: " .. sunc_percent .. "% (" .. sunc_pass .. "/14)")
    print(string.rep("=", 50))
    
    
    if unc_percent >= 90 then
        print("✅ UNC: FULL BYPASS - Perfect for basic scripts!")
    elseif unc_percent >= 70 then
        print("⚠️  UNC: GOOD BYPASS - Most scripts will work")
    else
        print("❌ UNC: WEAK BYPASS - Limited functionality")
    end
    
    if sunc_percent >= 80 then
        print("✅ SUNC: FULL BYPASS - Advanced scripts supported!")
    elseif sunc_percent >= 60 then
        print("⚠️  SUNC: PARTIAL BYPASS - Some advanced features")
    else
        print("❌ SUNC: NO BYPASS - Basic UNC only")
    end
    
    print(string.rep("=", 50))
end


runTests()
print("\n✅ Tester completed successfully! Made By FrostedFlakes666")
