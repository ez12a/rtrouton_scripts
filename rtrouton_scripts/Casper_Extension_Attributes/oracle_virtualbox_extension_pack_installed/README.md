This Jamf Pro Extension Attribute checks to see if Oracle VirtualBox's Extension Pack is installed. 

If the Extension Pack is installed:

`/Applications/VirtualBox.app/Contents/MacOS/ExtensionPacks` will be present and not an empty directory.

If Extension Pack is not installed:

`/Applications/VirtualBox.app/Contents/MacOS/ExtensionPacks` will not be found

Or

`/Applications/VirtualBox.app/Contents/MacOS/ExtensionPacks` will be an empty directory.

If Oracle Virtualbox's Extension Pack is installed, the following message is displayed:

`1`

Otherwise, the following result is returned:

`0`

See `Jamf_Pro_Extension_Attribute_Setup.png` for a screenshot of how the Extension Attribute should be configured.

![Jamf_Pro_Extension_Attribute_Setup.png](Jamf_Pro_Extension_Attribute_Setup.png)
