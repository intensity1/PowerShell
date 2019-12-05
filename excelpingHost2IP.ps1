###################################################################
##           Script to check the status of machines              
##           Author: Vikas Sukhija   http://SysCloudPro.com           		          
##           Date: 01-28-2016 
##			 Update: 12/12/2017
##           Update:  Converted from VBscript
##	     	 Modified: Host Name to IP(orignal : IP to hostanme)
##https://gallery.technet.microsoft.com/scriptcenter/Ping-Machines-and-report-19d590ce          
###################################################################

$path = ".\results.xls"

$objExcel = new-object -comobject excel.application 

if (Test-Path $path) 
{ 
$objWorkbook = $objExcel.WorkBooks.Open($path) 
$objWorksheet = $objWorkbook.Worksheets.Item(1) 
}

else { 
$objWorkbook = $objExcel.Workbooks.Add() 
$objWorksheet = $objWorkbook.Worksheets.Item(1)
}

$objExcel.Visible = $True

#########Add Header####

$objWorksheet.Cells.Item(1, 1) = "HostName"
$objWorksheet.Cells.Item(1, 2) = "Result"
$objWorksheet.Cells.Item(1, 3) = "MachineIP"

$machines = gc .\machinelist.txt
$count = $machines.count

$row=2

$machines | foreach-object{
$ping=$null
$iname =$null
$machine = $_
$ping = Test-Connection $machine -Count 1 -ea silentlycontinue

if($ping){

$objWorksheet.Cells.Item($row,1) = $machine
$objWorksheet.Cells.Item($row,2) = "UP"
	
$iname = $ping.IPV4Address.IPAddressToString

$objWorksheet.Cells.Item($row,3) = $iname
		
$row++}
else {

$objWorksheet.Cells.Item($row,1) = $machine
$objWorksheet.Cells.Item($row,2) = "DOWN"

$row++}
}

#################################################################


