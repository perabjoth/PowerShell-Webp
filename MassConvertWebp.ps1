#ImageMagick Recursive Powershell Script with Progress display
#This script will execute a command recursively on all folders and subfolders
#This script will display the filename of every file processed
#set the source folder for the images
$srcfolder = "<SourceFolder>"
#set the destination folder for the images
$destfolder = "<DestinationFolder>"
#set the ImageMagick command
$im_convert_exe = "magick"
#Image Extensions to process
$src_ext = @(".png",".jpg")
#set the destination (output) image format
$dest_ext = "webp"
#ArrayList that will hold all the ImageMagick commands
$commands=[System.Collections.ArrayList]@()
foreach ($srcitem in $(Get-ChildItem $srcfolder -recurse | where {$_.extension -in $src_ext}))
{

$srcname = $srcitem.fullname
$partial = $srcitem.FullName.Substring( $srcfolder.Length )
$destname = $destfolder + $partial
$destname= [System.IO.Path]::ChangeExtension( $destname , $dest_ext )
$destpath = [System.IO.Path]::GetDirectoryName( $destname )

if (-not (test-path $destpath))
{
    New-Item $destpath -type directory | Out-Null
}
#the following line defines the contents of the convert command line
$cmdline =  "$($im_convert_exe) `"$($srcname)`" `"$($destname)`""
$commands.Add($cmdline)
} 

#the following line runs the commands in parallel
$commands | ForEach-Object -Parallel { echo "processing: ($_)"; invoke-expression -command "$_";} -ThrottleLimit 100