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
*   inc
*/

include( 'shared.lua' )

/*
*   ent
*/

ENT.AllowAdvancedMode 				= true
ENT.DefaultMatWidth 				= 32
ENT.DefaultMatHeight 				= 128
ENT.DefaultTextX 					= 11
ENT.DefaultTextY 					= 100
ENT.DefaultTextColor 				= Color( 150, 150, 150, 150 )
ENT.DefaultTextColorActive 			= Color( 80, 80, 80, 150 )
ENT.DefaultTextInfoColor 			= Color( 46, 20, 6, 255 )
ENT.MaterialDir						= 'gmod_tower/instruments/piano/piano_note_'

/*
*   key materials
*/

ENT.KeyMaterials =
{
    [ 'left' ] 				= ENT.MaterialDir .. 'left',
    [ 'leftmid' ] 			= ENT.MaterialDir .. 'leftmid',
    [ 'right' ] 			= ENT.MaterialDir .. 'right',
    [ 'rightmid' ] 			= ENT.MaterialDir .. 'rightmid',
    [ 'middle' ] 			= ENT.MaterialDir .. 'middle',
    [ 'top' ] 				= ENT.MaterialDir .. 'top',
    [ 'full' ] 				= ENT.MaterialDir .. 'full',
}

/*
*   hud > main
*/

ENT.MainHUD =
{
    Material                = 'gmod_tower/instruments/piano/piano',
    X                       = ( ScrW( ) / 2 ) - ( 313 / 2 ),
    Y                       = ScrH( ) - 316,
    TextureWidth            = 512,
    TextureHeight           = 256,
    Width                   = 313,
    Height                  = 195,
}

/*
*   hud > advanced
*/

ENT.AdvMainHUD =
{
    Material 				= 'gmod_tower/instruments/piano/piano_large',
    X 						= ( ScrW( ) / 2 ) - ( 940 / 2 ),
    Y 						= ScrH( ) - 316,
    TextureWidth 			= 1024,
    TextureHeight 			= 256,
    Width 					= 940,
    Height 					= 195,
}

/*
*   hud > browser
*/

ENT.BrowserHUD =
{
    X 						= ScrW( ) / 2,
    Y 						= ENT.MainHUD.Y - 290,
    Width 					= 450,
    Height 					= 350,
    AdvWidth 				= 600,
}

/*
*   mod > ctrl
*/

function ENT:CtrlMod( )
    self:ToggleAdvancedMode( )

    if self.OldKeys then
        self.Keys           = self.OldKeys
        self.OldKeys        = nil
    else
        self.OldKeys        = self.Keys
        self.Keys           = self.AdvancedKeys
    end
end

/*
*   mod > shift
*/

function ENT:ShiftMod( )
    self:ToggleShiftMode( )
end