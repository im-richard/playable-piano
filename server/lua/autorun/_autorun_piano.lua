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
*   define
*/

local ws_id                 = '2290446815'

/*
*   workshop
*/

if SERVER then
    resource.AddWorkshop( ws_id )
    MsgC( Color( 255, 255, 0 ), '[ Playable Piano ] ', Color( 255, 255, 255 ), '+ workshop ' .. tostring( ws_id ) .. '\n' )
elseif CLIENT then
    steamworks.FileInfo( ws_id, function( res )
        if res and res.id then
            steamworks.DownloadUGC( tostring( res.id ), function( name, f )
                game.MountGMA( name or '' )
                local size = res.size / 1024
                MsgC( Color( 255, 255, 0 ), '[ Playable Piano ] ', Color( 0, 255, 0 ), '+ ws ' .. tostring( res.id ) .. ' | ', Color( 255, 255, 255 ), res.title .. ' ( ' .. math.Round( size ) .. 'kb )' .. '\n' )
            end )
        end
    end )
end