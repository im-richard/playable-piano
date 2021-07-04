# Playable Piano > Web

## Install
- Download files from this repo on Github.
- Extract the downloaded zip to your computer
- Connect to your webhost S/FTP (contact your host if you are unsure).
- Within your webhosts FTP; create a new sub-folder in your websites parent folder (sometimes called public_html) called **piano**
  - Example: /home/username/public_html/piano
- Enter the newly created subfolder in FTP.
- Upload the contents of the downloaded zip's **web** folder to the new subfolder created on your web server.
- Once uploaded; test your website by going to:
  - https://yourdomain.com/piano/
  - https://yourdomain.com/piano/index.php
- If you see the new webpage; you did it correctly.

## Change Site URL in Piano Addon
In order for players to use your newly hosted website, you need to edit default URL used by the piano addon.
- Open **server\lua\entities\gmt_instrument_base\shared.lua**
- Locate the line **ENT.cfg.WebURL**
- Change the string for the URL to your own website.
-   Note: Do NOT change **ENT.cfg.WebURLAdv** unless you know what you are doing.
