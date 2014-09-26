<#   
.SYNOPSIS
Script to split large text files into more managable files

.DESCRIPTION
This script will split large text files into more managable files

.PARAMETER filename
The file to split

.PARAMETER mbsize
The size of the split files in megabytes

.NOTES
Name: split-large-files.ps1
Author: Sean Creasy
Version: 1.0.0
DateUpdated: 2014-09-25

.LINK
http://www.seancreasy.com

.EXAMPLE
.\split-large-files.ps1 filename.txt 50

Description:
split the file filename.txt into 50 megabyte files named filename.#.txt

#>

##############################################
# INPUT PARAMETERS
##############################################

param(
	[Parameter(Mandatory=$true)] [string[]]$filename,
	[Parameter(Mandatory=$true)] [int]$mbsize
)


##############################################
# DOT SOURCED SCRIPT FUNCTIONS
##############################################

. "W:\batches\ps1\pause.ps1"								# this includes the Pause command for use throughout the script
. "W:\batches\ps1\ask-question.ps1"                         # this includes the Ask-Question command for asking yes/no questions throughout the script


##############################################
# FUNCTIONS START
##############################################

function main() {
	$bytesize = $mbsize * 1024 * 1024
	$intSeqno = 1
	$intFileBytes = 0
	
	$newfilename = $filename.SubString(0,$filename.LastIndexOf(".")) + "." + $intSeqno + $filename.SubString($filename.LastIndexOf("."))
	$stream = [System.IO.StreamWriter] $newfilename
	$reader = [System.IO.File]::OpenText($filename)
	try {
		for(;;) {
			$line = $reader.ReadLine()
			if ($line -eq $null) { break }
			$intFileBytes += $line.Length + 2
			$stream.WriteLine($line)
			if ($intFileBytes -ge $bytesize) {
				$intFileBytes = 0
				$intSeqno += 1
				$stream.close()
				$newfilename = $filename.SubString(0,$filename.LastIndexOf(".")) + "." + $intSeqno + $filename.SubString($filename.LastIndexOf("."))
				$stream = [System.IO.StreamWriter] $newfilename
			}
		}
	}
	finally {
		$reader.Close()
		$stream.Close()
	}
}


##############################################
# MAIN SCRIPT START
##############################################


main