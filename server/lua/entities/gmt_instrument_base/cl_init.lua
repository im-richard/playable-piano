/*
*   @package        piano
*   @author         MacDGuy [http://steamcommunity.com/profiles/76561197972354223]
*   @rewrite     	Richard [http://steamcommunity.com/profiles/76561198135875727]
*
*   LICENSOR HEREBY GRANTS LICENSEE PERMISSION TO MODIFY AND/OR CREATE DERIVATIVE WORKS BASED AROUND THE
*   SOFTWARE HEREIN, ALSO, AGREES AND UNDERSTANDS THAT THE LICENSEE DOES NOT HAVE PERMISSION TO SHARE,
*   DISTRIBUTE, PUBLISH, AND/OR SELL THE ORIGINAL SOFTWARE OR ANY DERIVATIVE WORKS. LICENSEE MUST ONLY
*   INSTALL AND USE THE SOFTWARE HEREIN AND/OR ANY DERIVATIVE WORKS ON PLATFORMS THAT ARE OWNED/OPERATED
*   BY ONLY THE LICENSEE.
*
*   YOU MAY REVIEW THE COMPLETE LICENSE FILE PROVIDED AND MARKED AS LICENSE.TXT
*
*   BY MODIFYING THIS FILE -- YOU UNDERSTAND THAT THE ABOVE MENTIONED AUTHORS CANNOT BE HELD RESPONSIBLE
*   FOR ANY ISSUES THAT ARISE FROM MAKING ANY ADJUSTMENTS TO THIS SCRIPT. YOU UNDERSTAND THAT THE ABOVE
*   MENTIONED AUTHOR CAN ALSO NOT BE HELD RESPONSIBLE FOR ANY DAMAGES THAT MAY OCCUR TO YOUR SERVER AS A
*   RESULT OF THIS SCRIPT AND ANY OTHER SCRIPT NOT BEING COMPATIBLE WITH ONE ANOTHER.
*/

/*
*   include
*/

include( 'shared.lua' )

/*
*   fonts
*/

surface.CreateFont( 'InstrumentKeyLabel', 	{ size = 22, weight = 400, antialias = true, font = 'Impact' } )
surface.CreateFont( 'InstrumentNotice', 	{ size = 30, weight = 400, antialias = true, font = 'Impact' } )

/*
*   ent
*/

ENT.KeysDown				= { }
ENT.KeysWasDown 			= { }
ENT.AllowAdvancedMode 		= false
ENT.AdvancedMode 			= false
ENT.ShiftMode 				= false
ENT.PageTurnSound 			= Sound( 'GModTower/inventory/move_paper.wav' )
ENT.DefaultMatWidth 		= 128
ENT.DefaultMatHeight 		= 128
ENT.DefaultTextX 			= 5
ENT.DefaultTextY 			= 10
ENT.DefaultTextColor 		= Color( 150, 150, 150, 255 )
ENT.DefaultTextColorActive 	= Color( 80, 80, 80, 255 )
ENT.DefaultTextInfoColor 	= Color( 120, 120, 120, 150 )
ENT.MaterialDir				= ''
ENT.KeyMaterials 			= { }

/*
*   hud > main
*/

ENT.MainHUD =
{
	Material 				= nil,
	X 						= 0,
	Y 						= 0,
	TextureWidth 			= 128,
	TextureHeight 			= 128,
	Width 					= 128,
	Height 					= 128,
}

/*
*   hud > advanced
*/

ENT.AdvMainHUD =
{
	Material 				= nil,
	X 						= 0,
	Y 						= 0,
	TextureWidth 			= 128,
	TextureHeight 			= 128,
	Width 					= 128,
	Height 					= 128,
}

/*
*   hud > browser
*/

ENT.BrowserHUD =
{
	X 						= 0,
	Y 						= 0,
	Width 					= 1024,
	Height 					= 768,
}

/*
*   initialize
*/

function ENT:Initialize( )
	self:PrecacheMaterials( )
end

/*
*   think
*/

function ENT:Think( )

	if !IsValid( LocalPlayer( ).Instrument ) or LocalPlayer( ).Instrument ~= self then return end

	if self.DelayKey and self.DelayKey > CurTime( ) then return end

	// Update last pressed
	for keylast, keyData in pairs( self.KeysDown ) do
		self.KeysWasDown[ keylast ] = self.KeysDown[ keylast ]
	end

	// Get keys
	for key, keyData in pairs( self.Keys ) do

		// Update key status
		self.KeysDown[ key ] = input.IsKeyDown( key )

		// Check for note keys
		if self:IsKeyTriggered( key ) then

			if self.ShiftMode and keyData.Shift then
				self:OnRegisteredKeyPlayed( keyData.Shift.Sound )
			elseif !self.ShiftMode then
				self:OnRegisteredKeyPlayed( keyData.Sound )
			end

		end

	end

	// Get control keys
	for key, keyData in pairs( self.ControlKeys ) do

		// Update key status
		self.KeysDown[ key ] = input.IsKeyDown( key )

		// Check for control keys
		if self:IsKeyTriggered( key ) then
			keyData( self, true )
		end

		// was a control key released?
		if self:IsKeyReleased( key ) then
			keyData( self, false )
		end

	end
end

/*
*   key > triggered
*/

function ENT:IsKeyTriggered( key )
	return self.KeysDown[ key ] and !self.KeysWasDown[ key ]
end

/*
*   key > released
*/

function ENT:IsKeyReleased( key )
	return self.KeysWasDown[ key ] and !self.KeysDown[ key ]
end

/*
*   key > played
*/

function ENT:OnRegisteredKeyPlayed( key )

	// Play on the client first
	local snd = self:GetSound( key )
	self:EmitSound( snd, 100 )

	net.Start				( 'InstrumentNetwork' )
	net.WriteEntity			( self )
	net.WriteInt			( INSTNET_PLAY, 3 )
	net.WriteString			( key )
	net.SendToServer		( )
end

/*
*   key > send
*/

function ENT:SendKeys( )
	if !self.KeysToSend then return end

	for _, key in ipairs( self.KeysToSend ) do
		local sound = self:GetSound( key )
		if sound then
			self:EmitSound( sound, 100 )
		end
	end

	self.KeysToSend = nil
end

/*
*   key > draw
*/

function ENT:DrawKey( mainX, mainY, key, keyData, bShiftMode )

	if keyData.Material then
		if ( self.ShiftMode and bShiftMode and input.IsKeyDown( key ) ) or
		   ( !self.ShiftMode and !bShiftMode and input.IsKeyDown( key ) ) then

			surface.SetTexture( self.KeyMaterialIDs[ keyData.Material ] )
			surface.DrawTexturedRect( mainX + keyData.X, mainY + keyData.Y, self.DefaultMatWidth, self.DefaultMatHeight )
		end

	end

	// Draw keys
	if keyData.Label then

		local offsetX 		= self.DefaultTextX
		local offsetY 		= self.DefaultTextY
		local color 		= self.DefaultTextColor

		if ( self.ShiftMode and bShiftMode and input.IsKeyDown( key ) ) or
		   ( !self.ShiftMode and !bShiftMode and input.IsKeyDown( key ) ) then

			color = self.DefaultTextColorActive
			if keyData.AColor then color = keyData.AColor end
		else
			if keyData.Color then color = keyData.Color end
		end

		// Override positions, if needed
		if keyData.TextX then offsetX = keyData.TextX end
		if keyData.TextY then offsetY = keyData.TextY end

		draw.DrawText( keyData.Label, 'InstrumentKeyLabel', mainX + keyData.X + offsetX, mainY + keyData.Y + offsetY, color, TEXT_ALIGN_CENTER )
	end
end

/*
*   hud > draw
*/

function ENT:DrawHUD( )

	surface.SetDrawColor( 255, 255, 255, 255 )

	local mainX, mainY, mainWidth, mainHeight

	// Draw main
	if self.MainHUD.Material and !self.AdvancedMode then
		mainX, mainY, mainWidth, mainHeight = self.MainHUD.X, self.MainHUD.Y, self.MainHUD.Width, self.MainHUD.Height

		surface.SetTexture( self.MainHUD.MatID )
		surface.DrawTexturedRect( mainX, mainY, self.MainHUD.TextureWidth, self.MainHUD.TextureHeight )
	end

	// Advanced main
	if self.AdvMainHUD.Material and self.AdvancedMode then
		mainX, mainY, mainWidth, mainHeight = self.AdvMainHUD.X, self.AdvMainHUD.Y, self.AdvMainHUD.Width, self.AdvMainHUD.Height

		surface.SetTexture( self.AdvMainHUD.MatID )
		surface.DrawTexturedRect( mainX, mainY, self.AdvMainHUD.TextureWidth, self.AdvMainHUD.TextureHeight )
	end

	// Draw keys (over top of main)
	for key, keyData in pairs( self.Keys ) do
		self:DrawKey( mainX, mainY, key, keyData, false )

		if keyData.Shift then
			self:DrawKey( mainX, mainY, key, keyData.Shift, true )
		end
	end

	// Sheet music help
	if !IsValid( self.Browser ) and self.cfg.bSheetMusic then

		draw.DrawText( 'SPACE FOR SHEET MUSIC', 'InstrumentKeyLabel',
						mainX + ( mainWidth / 2 ), mainY + 60,
						self.DefaultTextInfoColor, TEXT_ALIGN_CENTER )

	end

	// Advanced mode
	if self.AllowAdvancedMode and !self.AdvancedMode then
		draw.DrawText( 'CONTROL FOR ADVANCED MODE', 'InstrumentKeyLabel', mainX + ( mainWidth / 2 ), mainY + mainHeight + 30, self.DefaultTextInfoColor, TEXT_ALIGN_CENTER )
	elseif self.AllowAdvancedMode and self.AdvancedMode then
		draw.DrawText( 'CONTROL FOR BASIC MODE', 'InstrumentKeyLabel', mainX + ( mainWidth / 2 ), mainY + mainHeight + 30, self.DefaultTextInfoColor, TEXT_ALIGN_CENTER )
	end

end

/*
*   precache mats
*/

function ENT:PrecacheMaterials( )

	if !self.Keys then return end

	self.KeyMaterialIDs = {}

	for name, keyMaterial in pairs( self.KeyMaterials ) do
		if type( keyMaterial ) == 'string' then // TODO: what the fuck, this table is randomly created
			self.KeyMaterialIDs[name] = surface.GetTextureID( keyMaterial )
		end
	end

	if self.MainHUD.Material then
		self.MainHUD.MatID = surface.GetTextureID( self.MainHUD.Material )
	end

	if self.AdvMainHUD.Material then
		self.AdvMainHUD.MatID = surface.GetTextureID( self.AdvMainHUD.Material )
	end

end

/*
*   sheet music > open
*/

function ENT:OpenSheetMusic( )

	if IsValid( self.Browser ) or !self.cfg.bSheetMusic then return end

	self.Browser = vgui.Create( 'HTML' )
	self.Browser:SetVisible( false )

	local width = self.BrowserHUD.Width

	if self.BrowserHUD.AdvWidth and self.AdvancedMode then
		width = self.BrowserHUD.AdvWidth
	end

	local url = self.cfg.WebURL

	if self.AdvancedMode then
		url = self.cfg.WebURL .. self.cfg.WebURLAdv
	end

	local x = self.BrowserHUD.X - ( width / 2 )

	self.Browser:OpenURL( url )

	// This is delayed because otherwise it won't load at all
	// for some silly reason...
	timer.Simple( .1, function( )
		if IsValid( self.Browser ) then
			self.Browser:SetVisible( true )
			self.Browser:SetPos( x, self.BrowserHUD.Y )
			self.Browser:SetSize( width, self.BrowserHUD.Height )
		end
	end )

end

/*
*   sheet music > close
*/

function ENT:CloseSheetMusic( )
	if !IsValid( self.Browser ) then return end

	self.Browser:Remove( )
	self.Browser = nil
end

/*
*   sheet music > toggle
*/

function ENT:ToggleSheetMusic( )
	if IsValid( self.Browser ) then
		self:CloseSheetMusic( )
	else
		self:OpenSheetMusic( )
	end
end

/*
*   sheet music > forward
*/

function ENT:SheetMusicForward( )
	if !IsValid( self.Browser ) then return end

	self.Browser:Exec( 'pageForward( )' )
	self:EmitSound( self.PageTurnSound, 100, math.random( 120, 150 ) )
end

/*
*   sheet music > back
*/

function ENT:SheetMusicBack( )
	if !IsValid( self.Browser ) then return end

	self.Browser:Exec( 'pageBack( )' )
	self:EmitSound( self.PageTurnSound, 100, math.random( 100, 120 ) )
end

/*
*   ent > on remove
*/

function ENT:OnRemove( )
	self:CloseSheetMusic( )
end

/*
*   ent > shutdown
*/

function ENT:Shutdown( )
	self:CloseSheetMusic( )

	self.AdvancedMode 		= false
	self.ShiftMode 			= false

	if self.OldKeys then
		self.Keys 			= self.OldKeys
		self.OldKeys 		= nil
	end
end

/*
*   advanced mode > toggle
*/

function ENT:ToggleAdvancedMode( )
	self.AdvancedMode = !self.AdvancedMode

	if IsValid( self.Browser ) then
		self:CloseSheetMusic( )
		self:OpenSheetMusic( )
	end
end

/*
*   shift mode > toggle
*/

function ENT:ToggleShiftMode( )
	self.ShiftMode = !self.ShiftMode
end

/*
*   mod > shift
*/

function ENT:ShiftMod( ) end // Called when they press shift

/*
*   mod > ctrl
*/

function ENT:CtrlMod( ) end // Called when they press cntrl

/*
*   hook > hudpaint
*/

hook.Add( 'HUDPaint', 'InstrumentPaint', function( )
	if IsValid( LocalPlayer( ).Instrument ) then

		// HUD
		local inst 			= LocalPlayer( ).Instrument
		inst:DrawHUD( )

		// Notice bar
		local name 			= inst.PrintName or 'INSTRUMENT'
		name 				= string.upper( name )

		surface.SetDrawColor( 0, 0, 0, 180 )
		surface.DrawRect( 0, ScrH( ) - 60, ScrW( ), 60 )

		draw.SimpleText( 'PRESS TAB TO LEAVE THE ' .. name, 'InstrumentNotice', ScrW( ) / 2, ScrH( ) - 35, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1 )

	end

end )

/*
*   hook > player bind press
*/

hook.Add( 'PlayerBindPress', 'InstrumentHook', function( ply, bind, pressed )
	if IsValid( ply.Instrument ) then
		return true
	end
end )

/*
*   net
*/

net.Receive( 'InstrumentNetwork', function( length, client )
	local ent 			= net.ReadEntity( )
	local enum 			= net.ReadInt( 3 )

	// When the player uses it or leaves it
	if enum == INSTNET_USE then
		if IsValid( LocalPlayer( ).Instrument ) then
			LocalPlayer( ).Instrument:Shutdown( )
		end

		ent.DelayKey = CurTime( ) + .1 // delay to the key a bit so they don't play on use key
		LocalPlayer( ).Instrument = ent

	// Play the notes for everyone else
	elseif enum == INSTNET_HEAR then

		// Instrument doesn't exist
		if !IsValid( ent ) then return end

		// Don't play for the owner, they've already heard it!
		if IsValid( LocalPlayer( ).Instrument ) and LocalPlayer( ).Instrument == ent then return end

		// Gather note
		local key = net.ReadString( )
		local sound = ent:GetSound( key )

		if sound then
			ent:EmitSound( sound, 80 )
		end
	end
end )