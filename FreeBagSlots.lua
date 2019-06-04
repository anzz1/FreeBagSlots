---------------------------
--                       --
--  FreeBagSlots 1.12.1  --
--     by kebabstorm     --
--                       --
---------------------------


-- TODO: localizations, currently only works on enUS client
-- itemType and subType are localized, so a list of what GetItemInfo() returns in every language would be needed
local function isRegularBag(bag)
	if( bag < 0 ) then return false end
	if( bag == 0 ) then return true end -- bag 0 = backpack
	local _, _, id = strfind(GetInventoryItemLink("player", ContainerIDToInventoryID(bag)) or "", "item:(%d+)")
	if id then
		local _, _, _, _, _, subType = GetItemInfo(id)
		return (subType == "Bag" or false)
	end
	return false
end

function MainMenuBarBackpackButton_UpdateFreeSlots()
	if not MainMenuBarBackpackButton then return end
	if not MainMenuBarBackpackButton.text then
		MainMenuBarBackpackButton.text = MainMenuBarBackpackButton:CreateFontString(nil, 'OVERLAY', 'NumberFontNormal')
		MainMenuBarBackpackButton.text:SetTextColor(1, 1, 1)
		MainMenuBarBackpackButton.text:SetPoint('BOTTOMRIGHT', MainMenuBarBackpackButton, 'BOTTOMRIGHT', -5, 2)
		MainMenuBarBackpackButton.text:SetDrawLayer('OVERLAY', 2)
	end

	local totalFree, freeSlots = 0
	for i = 0, NUM_BAG_SLOTS do
		if(isRegularBag(i)) then
			freeSlots = 0
			for slot = 1, GetContainerNumSlots(i) do
				local texture = GetContainerItemInfo(i, slot)
				if not (texture) then 
					freeSlots = freeSlots + 1 
				end
			end
			totalFree = totalFree + freeSlots
		end
	end

	MainMenuBarBackpackButton.freeSlots = totalFree
	MainMenuBarBackpackButton.text:SetText(string.format('(%s)', totalFree))
end

---------------------------------------------------
do
	if (GetLocale() == "enUS" or GetLocale() == "enGB") then
		local f = CreateFrame('Frame')
		f:RegisterEvent('PLAYER_LOGIN')
		f:RegisterEvent('BAG_UPDATE')
		f:SetScript('OnEvent', function()
			MainMenuBarBackpackButton_UpdateFreeSlots()
		end)
	else
		DEFAULT_CHAT_FRAME:AddMessage("|c000066FFFreeBagSlots:|c00FF0000 Could not load addon. Currently only enUS locale is supported :(")
	end
end
---------------------------------------------------
