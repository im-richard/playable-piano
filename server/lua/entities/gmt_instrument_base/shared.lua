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
*   ent
*/

ENT.Base					= 'base_anim'
ENT.Type					= 'anim'
ENT.PrintName				= 'Instrument Base'
ENT.Model					= Model( 'models/fishy/furniture/piano.mdl' )
ENT.ChairModel				= Model( 'models/fishy/furniture/piano_seat.mdl' )
ENT.SoundDir				= 'GModTower/lobby/piano/note_'
ENT.SoundExt 				= '.wav'

/*
*   cfg
*
*   only the things below should be modified ( if you know what youre doing )
*
*   :   ENT.cfg.WebURL
*       the web url to use which displays the sheet music
*
*   :   ENT.cfg.WebURLAdv
*       parameter to use when player goes into advanced mode
*
*   :   ENT.cfg.bSheetMusic
*       enables / disables the sheet music for a player to see when they sit
*       on the piano and activate it
*/

ENT.cfg 					= { }
ENT.cfg.WebURL 				= 'http://cdn.rlib.io/gmod/piano/index.php'
ENT.cfg.WebURLAdv           = '?&adv=1'
ENT.cfg.bSheetMusic         = true

/*
*   state enums
*/

INSTNET_USE					= 1
INSTNET_HEAR				= 2
INSTNET_PLAY				= 3

/*
*   keys
*/

ENT.ControlKeys =
{
    [KEY_TAB] =	function( inst, bPressed )
        if ( !bPressed ) then return end
        RunConsoleCommand( 'piano_leave', inst:EntIndex( ) )
    end,

    [KEY_SPACE] = function( inst, bPressed )
        if ( !bPressed ) then return end
        inst:ToggleSheetMusic( )
    end,

    [KEY_LEFT] = function( inst, bPressed )
        if ( !bPressed ) then return end
        inst:SheetMusicBack( )
    end,
    [KEY_RIGHT] = function( inst, bPressed )
        if ( !bPressed ) then return end
        inst:SheetMusicForward( )
    end,

    [KEY_LCONTROL] = function( inst, bPressed )
        if ( !bPressed ) then return end
        inst:CtrlMod( )
    end,
    [KEY_RCONTROL] = function( inst, bPressed )
        if ( !bPressed ) then return end
        inst:CtrlMod( )
    end,

    [KEY_LSHIFT] = function( inst, bPressed )
        inst:ShiftMod( )
    end,
}

/*
*   ent > get sound
*/

function ENT:GetSound( snd )
    if ( snd == nil || snd == '' ) then
        return nil
    end

    return self.SoundDir .. snd .. self.SoundExt
end

/*
*   SERVER
*/

if SERVER then

    /*
    *   initialized
    */

    function ENT:Intiailize( )
        self:PrecacheSounds( )
    end

    function ENT:PrecacheSounds( )

        if !self.Keys then return end

        for _, keyData in pairs( self.Keys ) do
            util.PrecacheSound( self:GetSound( keyData.Sound ) )
        end

    end
end

/*
*   key > send
*/

local function hook_physgun_pickup( ply, ent )
    local inst = ent:GetOwner( )

    if IsValid( inst ) && inst.Base == 'gmt_instrument_base' then
        return false
    end
end
hook.Add( 'PhysgunPickup', 'NoPickupInsturmentChair', hook_physgun_pickup )