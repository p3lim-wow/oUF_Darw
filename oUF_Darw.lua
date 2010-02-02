--[[

  Adrian L Lange grants anyone the right to use this work for any purpose,
  without any conditions, unless such conditions are required by law.

--]]

local format = string.format

local FONT = [=[Interface\AddOns\oUF_Darw\media\semplice.ttf]=]
local TEXTURE = [=[Interface\AddOns\oUF_Darw\media\minimalist]=]
local BACKDROP = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	insets = {top = -1, bottom = -1, left = -1, right = -1}
}

oUF.Tags['[darwwild]'] = function(unit)
	return not oUF.Tags['[darwstatus]'](unit) and not UnitHasVehicleUI(unit) and not UnitAura(unit, 'Gift of the Wild') and not UnitAura(unit, 'Mark of the Wild') and '|cffff33ffM|r'
end

oUF.Tags['[darwhp]'] = function(unit)
	local perc = oUF.Tags['[perhp]'](unit)
	return not oUF.Tags['[darwstatus]'](unit) and perc and perc < 75 and format('|cffff8080%d%%|r', perc)
end

oUF.Tags['[darwmp]'] = function(unit)
	local perc = oUF.Tags['[perpp]'](unit)
	return UnitHasMana(unit) and not oUF.Tags['[darwstatus]'](unit) and perc and perc < 50 and format('|cff0090ff%d%%|r', perc)
end

oUF.Tags['[darwleader]'] = function(unit)
	return UnitIsPartyLeader(unit) and '|cffffff00!|r'
end

oUF.Tags['[darwstatus]'] = function(unit)
	return UnitIsDead(unit) and 'Dead' or UnitIsGhost(unit) and 'Ghost' or not UnitIsConnected(unit) and 'Offline'
end

oUF.Tags['[darwinfo]'] = function(unit)
	local status = oUF.Tags['[darwstatus]'](unit)
	return status and format('|cff707070%s|r', status) or oUF.Tags['[darwhp]'](unit)
end

oUF.Tags['[darwname]'] = function(unit, realUnit)
	local _, class = UnitClass(realUnit or unit)
	local colors = oUF.colors.class[class]
	return string.format('|cff%02x%02x%02x%s|r%s', colors[1] * 255, colors[2] * 255, colors[3] * 255, UnitName(realUnit or unit), realUnit and '*' or '')
end

local function Style(self, unit)
	self:RegisterForClicks('AnyUp')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

	self:SetAttribute('initial-height', 13)
	self:SetAttribute('initial-width', 126)

	self:SetBackdrop(BACKDROP)
	self:SetBackdropColor(0, 0, 0)

	local health = CreateFrame('StatusBar', nil, self)
	health:SetAllPoints(self)
	health:SetStatusBarTexture(TEXTURE)
	health:SetStatusBarColor(1/4, 1/4, 2/5)

	local healthBG = health:CreateTexture(nil, 'BACKGROUND')
	healthBG:SetAllPoints(health)
	healthBG:SetTexture(1/3, 1/3, 1/3)

	health.bg = healthBG
	self.Health = health

	local status = health:CreateFontString(nil, 'ARTWORK')
	status:SetPoint('RIGHT', -2, 0)
	status:SetFont(FONT, 8, 'OUTLINE')
	status:SetJustifyH('RIGHT')
	status.frequentUpdates = true
	self:Tag(status, '[darwmp][( )darwinfo]')

	local name = health:CreateFontString(nil, 'ARTWORK')
	name:SetPoint('LEFT', 2, 0)
	name:SetPoint('RIGHT', status, 'LEFT', -2, 0)
	name:SetFont(FONT, 8, 'OUTLINE')
	name:SetJustifyH('LEFT')
	name.frequentUpdates = true
	self:Tag(name, '[darwleader][darwname][( )darwwild]')

	local readycheck = self:CreateTexture(nil, 'OVERLAY')
	readycheck:SetPoint('RIGHT', self, 'LEFT', -2, 0)
	readycheck:SetHeight(16)
	readycheck:SetWidth(16)
	self.ReadyCheck = readycheck

	self.DebuffHighlightBackdrop = true
	self.DebuffHighlightFilter = true

	self.Range = true
	self.inRangeAlpha = 1
	self.outsideRangeAlpha = 0.25
end

oUF:RegisterStyle('Darw', Style)
oUF:SetActiveStyle('Darw')

oUF:SpawnHeader('oUF_Darw', nil, nil, true, true,
	'showPlayer', true,
	'showParty', true,
	'showRaid', true,
	'yOffset', -5,
	'point', 'TOP',
	'groupingOrder', '1,2,3,4,5',
	'groupBy', 'GROUP',
	'maxColumns', 5,
	'unitsPerColumn', 5,
	'columnSpacing', 81,
	'columnAnchorPoint', 'TOP'
):SetPoint('TOP', Minimap, 'BOTTOM', 0, -15)
