
<?php

    /**
    *   @package        : playable piano ( web )
    *   @author         : Richard
    *   @author         : MacDGuy [ https://steamcommunity.com/id/MacDGuy ]
    *
    *   This web package was released in order to correct issues with the original
    *   website used to host these files.
    *
    *   All credit goes to the original owner ( MacDGuy ). I simply updated it to
    *   fix the page issue which stopped people from switching pages.
    */

    $adv            = $_GET[ 'adv' ];
    $mode           = ($adv == '1') ? 'adv' : 'basic';
?>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>Notes</title>
		<style media="screen">
			body {
				background: url( images/1.jpg ) no-repeat fixed;;
				background-position: center;
				color: white;
				text-align: center;
				text-shadow:1px 1px 2px #000000;
			}
			#title {
				font-family: serif;
				font-weight: 800;
				font-size: 22px;
				height: 30px;

				background-color: rgba(1, 1, 1, 0.3);
				margin-bottom: 4px;
			}
			#notes {
				font-family: monospace;
				font-weight: 800;
				font-size: 14px;

				width: 100%;
			}
			#notes > span {
				padding: 2px;
				width: 100%;
			}
			.note-0 {
				background-color: #131313;
                opacity: 0.9;
			}
			.note-1 {
				background-color: #1d1d1d;
                opacity: 0.9;
			}
		</style>
	</head>
	<body>
		<div id="title"></div>
		<div id="notes"></div>

		<script type="text/javascript">
			var level       = '<?php echo $mode ?>';
			var page        = 0;

			function load( )
            {
				document.getElementById( "notes" ).innerText = "Please wait ...";

				var oReq = new XMLHttpRequest( );
				oReq.addEventListener( "load", function( )
                {
					// if page was not found we probably overflowed; in that case return back to zero
					if (this.status == 404)
                    {
						page = 0;
						load( );
						return;
					}

					var lines = this.responseText.split( "\n" );
					var title = lines[ 0 ];

					document.getElementById( "title" ).innerText = title;
					document.getElementById( "notes" ).innerText = "";

					var notes = lines.slice( 2 );
					for ( var i in notes )
                    {
						var note = notes[ i ];
						if (note == "") continue;

						var el = document.createElement("div");
						el.setAttribute( "class", "note-" + ( i % 2 ) );
						el.innerText = note;
						document.getElementById( "notes" ).appendChild( el );
					}
				});
				oReq.open( "GET", "notes" + "/" + level + "/" + page + ".txt" );
				oReq.send( );
			}

			function pageBack( )
            {
				page = Math.max(page - 1, 0);
				load( );
			}

			function pageForward( )
            {
				page++;
				load( );
			}

			window.onload = load;
		</script>
	</body>
</html>