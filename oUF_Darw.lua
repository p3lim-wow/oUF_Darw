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

oUF.Tags['darw:wild'] = function(unit)
	return not _TAGS['darw:status'](unit) and not UnitHasVehicleUI(unit) and not UnitAura(unit, 'Gift of the Wild') and not UnitAura(unit, 'Mark of the Wild') and '|cffff33ffM|r'
end

oUF.Tags['darw:health'] = function(unit)
	local perc = _TAGS['perhp'](unit)
	return not _TAGS['darw:status'](unit) and perc and perc < 75 and format('|cffff8080%d%%|r', perc)
end

oUF.Tags['darw:power'] = function(unit)
	local perc = _TAGS['perpp'](unit)
	return UnitHasMana(unit) and not _TAGS['darw:status'](unit) and perc and perc < 50 and format('|cff0090ff%d%%|r', perc)
end

oUF.Tags['darw:leader'] = function(unit)
	return UnitIsPartyLeader(unit) and '|cffffff00!|r'
end

oUF.Tags['darw:status'] = function(unit)
	return UnitIsDead(unit) and 'Dead' or UnitIsGhost(unit) and 'Ghost' or not UnitIsConnected(unit) and 'Offline'
end

oUF.Tags['darw:info'] = function(unit)
	local status = _TAGS['darw:status'](unit)
	return status and format('|cff707070%s|r', status) or _TAGS['darw:health'](unit)
end

oUF.Tags['darw:name'] = function(unit, realUnit)
	local _, class = UnitClass(realUnit or unit)
	local colors = _COLORS.class
	return string.format('%s%s|r', Hex(colors[class] or colors['WARRIOR']), UnitName(realUnit or unit))
end

oUF.Tags['darw:vehicle'] = function(unit, realUnit)
	return realUnit and '*'
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
	self:Tag(status, '[darw:power][ >darw:info]')

	local name = health:CreateFontString(nil, 'ARTWORK')
	name:SetPoint('LEFT', 2, 0)
	name:SetPoint('RIGHT', status, 'LEFT', -2, 0)
	name:SetFont(FONT, 8, 'OUTLINE')
	name:SetJustifyH('LEFT')
	name.frequentUpdates = true
	self:Tag(name, '[darw:leader][darw:name][ >darw:vehicle][ >darw:wild]')

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

oUF:SpawnHeader(nil, nil, 'party,raid', 
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
