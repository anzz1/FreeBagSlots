---------------------------
--                       --
--  FreeBagSlots 1.12.1  --
--     by kebabstorm     --
--                       --
---------------------------


local function isRegularBag(bag)
	if( bag < 0 ) then return false end
	if( bag == 0 ) then return true end -- bag 0 = backpack
	local _, _, id = strfind(GetInventoryItemLink("player", ContainerIDToInventoryID(bag)) or "", "item:(%d+)")
	if id then
		local _, _, _, _, _, subType = GetItemInfo(id)
		return (subType == "Bag" or subType == "Beh\195\164lter" or subType == "Sac" or subType == "容器" or subType == "背包" or subType == "가방" or subType == "Bolsa" or subType == "Сумка" or false)
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
	local f = CreateFrame('Frame')
	f:RegisterEvent('PLAYER_LOGIN')
	f:RegisterEvent('BAG_UPDATE')
	f:SetScript('OnEvent', function()
		MainMenuBarBackpackButton_UpdateFreeSlots()
	end)
end
---------------------------------------------------
