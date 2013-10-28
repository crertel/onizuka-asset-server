onizuka-asset-server
====================

Asset and file server for the Onizuka VR system.

Each asset is made of:
* A unique ID for the asset
* A display name
* A filename
* A file of the asset (a .png, .json, etc.)
* A description (possibly empty)
* One or more tags (possibly none)
* An asset type
* A MIME type
* Timestamps (created, updated)

Asset types are:
* Script (.lua, .js, .rb)
* Sound (.wav, .mp3, .ogg)
* Image (.bmp, .png, .tga, .jpg)
* Model (.obj)
* Material (.mtl)
* Manifest (.json)

The server provides a web page which lists all active assets in a tabular form,
showing their name, filename, and type. Clicking on an entry brings you to a
page showing all of the fields for the asset, allowing you to update the file
and set other fields.

The server also provides routes for interacting with assets.

GET /assets
Returns a JSON blob with an array of all asset names, types, and IDs.

GET /asssets/:id
Returns a JSON blob of the asset fields (the metadata from above).

GET /files/:id
Returns the actual asset content.

