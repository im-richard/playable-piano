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
*   eff > init
*/

function EFFECT:Init( data )

	local pos 				= data:GetOrigin( )
	local grav 				= Vector( 0, 0, math.random( 50, 60 ) )
	local offset 			= Vector( 0, 0, 10 )
	local emitter 			= ParticleEmitter( pos )

	local particle 			= emitter:Add( 'sprites/music', pos + offset )
	particle:SetVelocity	( ( Vector( 0, 0, 1 ) + ( VectorRand( ) * 0.1 ) ) * math.random( 15, 30 ) )
	particle:SetDieTime		( math.random( 0.5, 0.8 ) )
	particle:SetStartAlpha	( 255 )
	particle:SetEndAlpha	( 0 )
	particle:SetStartSize	( 3 )
	particle:SetEndSize		( 1.5 )
	particle:SetRoll		( math.random( 0.5, 10 ) )
	particle:SetRollDelta	( math.Rand( -0.2, 0.2 ) )
	particle:SetColor		( 255, 255, 255 )
	particle:SetCollide		( false )
	particle:SetGravity		( grav )

	grav 					= grav + Vector( 0, 0, math.random( -10, -5 ) )
	offset 					= offset + Vector(  math.random( 1, 5 ), math.random( .5, 5 ), math.random( 1.5, 6 ) )

	emitter:Finish( )
end

/*
*   eff > think
*/

function EFFECT:Think( )
	return false
end

/*
*   eff > render
*/

function EFFECT:Render( )
end