<#	
	===========================================================================
	 Created on:   	1/8/2016 3:15 PM
	 Created by:   	sqlchow
	 Filename:     	    GetBotsToChat.ps1
	-------------------------------------------------------------------------
	 Scripts Name: GetBotsToChat
	 Description: This script should ideally, get both the bots to start chatting with each other.
					  Before importing the CleverBot module, you must create your own API keys
	===========================================================================
#>
Import-Module D:\Programming\PowerShell\CleverBot\CleverBot.psm1

$starter = Get-Content D:\Programming\PowerShell\CleverBot\Example\SamplePhrases.txt | Get-Random -Count 1

$cleverBotApiUser=<youruser>
$cleverBotApiKey=<yourkey>

$roberto = New-CleverBot -CleverBotAPIUser $cleverBotApiUser `
  -CleverBotAPIKey $cleverBotApiKey -CleverBotNick "Roberto"

$scrappie = New-CleverBot -CleverBotAPIUser $cleverBotApiUser `
 -CleverBotAPIKey $cleverBotApiKey -CleverBotNick "Scrappie"

$roberto.create()

$scrappie.create()

#Let's try 50 conversations
for($i=0; $i  -le 49; $i++){
	$rconvo = $roberto.ask($starter) 
	$sconvo = $scrappie.ask($rconvo)
	$starter = $sconvo
}