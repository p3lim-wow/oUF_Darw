--[[

  Adrian L Lange grants anyone the right to use this work for any purpose,
  without any conditions, unless such conditions are required by law.

--]]

local gsub = string.gsub
local format = string.format

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

local function style(self, unit)
	self:RegisterForClicks('AnyUp')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

	self:SetAttribute('initial-height', 14)
	self:SetAttribute('initial-width', 126)
	self:SetAttribute('toggleForVehicle', true)

	self:SetBackdrop({bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=], insets = {top = -1, bottom = -1, left = -1, right = -1}})
	self:SetBackdropColor(0, 0, 0)

	self.Health = CreateFrame('StatusBar', nil, self)
	self.Health:SetAllPoints(self)
	self.Health:SetStatusBarTexture([=[Interface\AddOns\oUF_Darw\media\minimalist]=])
	self.Health:SetStatusBarColor(0.25, 0.25, 0.25)

	self.Health.bg = self.Health:CreateTexture(nil, 'BACKGROUND')
	self.Health.bg:SetAllPoints(self.Health)
	self.Health.bg:SetTexture(0.3, 0.3, 0.3)

	local status = self.Health:CreateFontString(nil, 'ARTWORK', 'pfont')
	status:SetPoint('RIGHT', -2, 0)
	status:SetJustifyH('RIGHT')
	status.frequentUpdates = true
	self:Tag(status, '[darwmp][( )darwinfo]')

	local name = self.Health:CreateFontString(nil, 'ARTWORK', 'pfont')
	name:SetPoint('LEFT', 2, 0)
	name:SetPoint('RIGHT', status, 'LEFT', -2, 0)
	name:SetJustifyH('LEFT')
	name.frequentUpdates = true
	self:Tag(name, '[darwleader][raidcolor][name]|r[( )darwwild]')

	self.ReadyCheck = self:CreateTexture(nil, 'OVERLAY')
	self.ReadyCheck:SetPoint('RIGHT', self, 'LEFT', -2, 0)
	self.ReadyCheck:SetHeight(16)
	self.ReadyCheck:SetWidth(16)

	self.DebuffHighlightBackdrop = true
	self.DebuffHighlightFilter = true

	self.Range = true
	self.inRangeAlpha = 1
	self.outsideRangeAlpha = 0.25
end

oUF:RegisterStyle('Darw', style)
oUF:SetActiveStyle('Darw')

local group = oUF:Spawn('header', 'oUF_Darw')
group:SetPoint('TOP', Minimap, 'BOTTOM', 0, -15)
group:SetManyAttributes(
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
)
group:Show()
