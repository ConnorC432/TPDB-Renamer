Display_help()
{
	echo "TPDB to Plex renamer options"
	echo "Usage: $0 [OPTIONS] [ARGUMENTS]"
	echo
	echo
	echo "Options:"
	echo
	echo "[-h|--help]"
	echo
	echo
	echo "[-t|-tv]	[TV Directory]		[Second TV Directory...]"
	echo "		Specify the root TV directory(s) to rename"
	echo "		Leave empty to rename files in current directory"
	echo
	echo "[-f|-film]	[Film Directory]	[Second Film Directory...]"
	echo "		Specify the root Film directory(s) to rename"
	echo "		Leave empty to rename files in current directory"
	echo
	echo "[-d|-default]"
	echo "		Rename both TV and Film default directory(s)"
	echo
	echo "[-dt|-defaulttv]"
	echo "		Rename TV default directory(s)"
	echo
	echo "[-df|-defaultfilm]"
	echo "		Rename Film default directory(s)"
	echo
	echo
}