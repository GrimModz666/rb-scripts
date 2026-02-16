-- script to mane an auto farm or to find stuff to tinker and mess with

local keywords = {"buy", "sell", "shop", "purchase", "trade"}

local function containsKeyword(text)
    text = string.lower(text)
    for _, word in ipairs(keywords) do
        if string.find(text, word) then
            return true
        end
    end
    return false
end

print("🔍 Scanning game for Buy/Sell systems...\n")

for _, obj in ipairs(game:GetDescendants()) do
    
    
    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
        if containsKeyword(obj.Name) then
            print("📡 Remote Found:", obj:GetFullName())
        end
    end
    
   
    if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
        if containsKeyword(obj.Name) then
            print("📜 Script Found:", obj:GetFullName())
        end
    end
    
    
    if obj:IsA("TextButton") or obj:IsA("ImageButton") then
        if containsKeyword(obj.Name) then
            print("🖱️ GUI Button Found:", obj:GetFullName())
        end
    end
end

print("\n✅ Scan complete. Made By FrostedFlakes666")
