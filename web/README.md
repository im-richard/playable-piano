# Playable Piano > Web

## Install
- Download files from this repo on Github.
- Extract the downloaded zip to your computer
- Connect to your webhost S/FTP (contact your host if you are unsure).
- Within your webhosts FTP; create a new sub-folder named **piano**
  - Ex: /home/username/public_html/piano
  - Ex: /var/www/html/piano
- Enter the newly created subfolder in FTP.
- Upload the contents of the downloaded zip's **web** folder to the new subfolder created.
- Once uploaded; test your website by going to:
  - https://yourdomain.com/piano/
  - https://yourdomain.com/piano/index.php
- Complete
  - If you see the new webpage; you did it correctly.
  - If not, ensure you are uploading to the correct folder on your webserver. If you have issues, contact your hosting provider for further instructions.

## In-Game Keys
| Key   | Desc                           |
|-------|--------------------------------|
| E     | Activate Piano                 |
| TAB   | Leave Piano                    |
| Space | Open / Close sheet music       |
| CTRL  | Toggle Basic and Advanced mode |

## Change Site URL in Piano Addon
In order for players to view sheet music on your newly hosted website, you need to edit default URL used by the piano addon.
- Open **server\lua\entities\gmt_instrument_base\shared.lua**
- Locate the line **ENT.cfg.WebURL**
- Change the string for the URL to your own website.
  - Ex: https://yourdomain.com/piano/
- Note: Do NOT change **ENT.cfg.WebURLAdv** unless you know what you are doing.

## Adding More Sheet Music
You can find a wide variety of music by visiting https://virtualpiano.net/.
- Connect to your web host's FTP.
- Navigate to the folder **notes** folder where you uploaded the piano web files.
- Enter either the **basic** or **adv** folder depending on how complicated the new song is. 
  - Adv = Advanced
- In the basic or adv folder, you will see **.txt** files with numerical names.
- Create a new .txt file, name it the next available number not yet used.
  - Ex: 4.txt
- On the website with the sheet music, copy the characters provided.
- Open the newly created **.txt** file and paste your copied sheet music, save.
- Go in-game, activate the piano, and cycle through the pages until you find your new song.
  - You can switch pages by pressing your **left** / **right** arrow keys.
  - Switch to advanced mode by pressing **CTRL**.
