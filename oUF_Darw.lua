--[[

  Adrian L Lange grants anyone the right to use this work for any purpose,
  without any conditions, unless such conditions are required by law.

--]]

local gsub = string.gsub
local format = string.format

local minimalist = [=[Interface\AddOns\oUF_Darw\media\minimalist]=]

local function shortVal(value)
	if(value <= -1e3) then
		return ('%.1fk'):format(value / 1e3):gsub('%.?0+([km])$', '%1')
	else
		return value
	end
end

oUF.TagEvents['[darwwild]'] = 'UNIT_AURA'
oUF.Tags['[darwwild]'] = function(unit)
	return not oUF.Tags['[status]'](unit) and not UnitAura(unit, 'Gift of the Wild') and not UnitAura(unit, 'Mark of the Wild') and '|cffff33ffM|r'
end

oUF.TagEvents['[darwhp]'] = oUF.TagEvents['[curhp]']
oUF.Tags['[darwhp]'] = function(unit)
	local perc = oUF.Tags['[perhp]'](unit)
	return not oUF.Tags['[status]'](unit) and perc and perc < 75 and format('|cffff8080%d%%|r', perc)
end

oUF.TagEvents['[darwmp]'] = oUF.TagEvents['[curpp]']
oUF.Tags['[darwmp]'] = function(unit)
	local perc = oUF.Tags['[perpp]'](unit)
	return UnitHasMana(unit) and not oUF.Tags['[status]'](unit) and perc and perc < 50 and format('|cff0090ff%d%%|r', perc)
end

oUF.TagEvents['[darwstatus]'] = oUF.TagEvents['[status]']
oUF.Tags['[darwstatus]'] = function(unit)
	local status = oUF.Tags['[status]'](unit)
	return status and format('|cff707070%s|r', status) or oUF.Tags['[darwhp]'](unit)
end

local function style(self, unit)
	self:RegisterForClicks('AnyUp')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

	self:SetAttribute('initial-height', 14)
	self:SetAttribute('initial-width', 126)

	self:SetBackdrop({bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=], insets = {top = -1, bottom = -1, left = -1, right = -1}})
	self:SetBackdropColor(0, 0, 0)

	self.Health = CreateFrame('StatusBar', nil, self)
	self.Health:SetPoint('TOPRIGHT')
	self.Health:SetPoint('TOPLEFT')
	self.Health:SetStatusBarTexture(minimalist)
	self.Health:SetStatusBarColor(0.25, 0.25, 0.25)
	self.Health:SetHeight(14)

	self.Health.bg = self.Health:CreateTexture(nil, 'BACKGROUND')
	self.Health.bg:SetAllPoints(self.Health)
	self.Health.bg:SetTexture(0.3, 0.3, 0.3)

	local status = self.Health:CreateFontString(nil, 'ARTWORK', 'pfont')
	status:SetPoint('RIGHT', -2, 0)
	status:SetJustifyH('RIGHT')
	self:Tag(status, '[darwmp][( )darwstatus]')

	local name = self.Health:CreateFontString(nil, 'ARTWORK', 'pfont')
	name:SetPoint('LEFT', 2, 0)
	name:SetPoint('RIGHT', status, 'LEFT', -2, 0)
	name:SetJustifyH('LEFT')
	self:Tag(name, '[raidcolor][name]|r[( )darwwild]')

	self.ReadyCheck = self:CreateTexture(nil, 'OVERLAY')
	self.ReadyCheck:SetPoint('RIGHT', self, 'LEFT', -2, 0)
	self.ReadyCheck:SetHeight(16)
	self.ReadyCheck:SetWidth(16)

	self.DebuffHighlightBackdrop = true
	self.DebuffHighlightFilter = true
end

oUF:RegisterStyle('Darw', style)
oUF:SetActiveStyle('Darw')

local group = oUF:Spawn('header', 'oUF_Darw', nil, '')
group:SetPoint('TOP', Minimap, 'BOTTOM', 0, -15)
group:SetManyAttributes(
	'showPlayer', true,
	'showParty', true,
	'showRaid', true,
	'yOffset', -5,
	'point', 'TOP',
	'groupingOrder', '1,2',
	'groupBy', 'GROUP',
	'maxColumns', 2,
	'unitsPerColumn', 5,
	'columnSpacing', 81,
	'columnAnchorPoint', 'TOP'
)
group:Show()
