<#	
	===========================================================================
	 Created on:   	1/8/2016 3:15 PM
	 Created by:   	sqlchow
	 Filename:     	CleverBot.psm1
	-------------------------------------------------------------------------
	 Module Name: CleverBot
	 Description: This CleverBot PowerShell module was built to give a  
        user the ability to interact with CleverBot API via Powershell.

		Before importing this module, you must create your own API keys
	===========================================================================
#>

#seems like the nick is used like a session id?? Need to validate this though.

Function New-CleverBot{
	param(
		[Parameter(Mandatory = $true)]
		[string]$CleverBotAPIUser,
		[Parameter(Mandatory = $true)]
		[string]$CleverBotAPIKey,
		[Parameter(Mandatory = $true)]   
		[ValidateNotNullOrEmpty()] 
		[string]$CleverBotNick
	)

	Begin{
	}

	Process{
		New-Object Object |            
			Add-Member NoteProperty nick $cleverBotNick -PassThru |
            Add-Member NoteProperty user $CleverBotAPIUser -PassThru |
            Add-Member NoteProperty key  $CleverBotAPIKey -PassThru |
			Add-Member ScriptMethod setnick{            
				param([string] $cleverBotNick)            
					$this.nick = $cleverBotNick
				} -PassThru |
			Add-Member ScriptMethod getnick {            
				$this.nick
			} -PassThru |
			Add-Member ScriptMethod create {            
			<#
			   .SYNOPSIS
				create cleverbot instance
			#>
				param([string] $CleverBotAPIUser, [string] $CleverBotAPIKey)            
					Connect-ToCleverBot $CleverBotAPIUser $CleverBotAPIKey $this.nick
				} -PassThru |
			Add-Member ScriptMethod ask {            
			<#
			   .SYNOPSIS
				Query cleverbot istance
			#>
				param($message)            
					Send-ToCleverBot $CleverBotAPIUser $CleverBotAPIKey $this.nick $message
				} -PassThru 
	}

	End{
	}

}

function Connect-ToCleverBot{
	param(
		[Parameter(Mandatory = $true)]
		[string]$CleverBotAPIUser,
		[Parameter(Mandatory = $true)]
		[string]$CleverBotAPIKey,
		[Parameter(Mandatory = $true)]   
		[ValidateNotNullOrEmpty()] 
		[string]$CleverBotNick
	)
	Begin
	{
		$cleverBotCreateUrl = "https://cleverbot.io/1.0/create"
		$cleverBotUserAgent="powershell / 1.0"
		$cleverBotContentType="application/json"
	}
	
	Process
	{
		$hashtable = [ordered]@{'user' = $CleverBotAPIUser;
										 'key'  = $CleverBotAPIKey;
										 'nick'  =$CleverBotNick;
									}
		$cleverBotRequestBody = ConvertTo-Json -InputObject $hashtable
		
		$cleverBotCreateBot = Invoke-RestMethod -Uri $cleverBotCreateUrl -Method Post `
											  -Body $cleverBotRequestBody `
											  -UserAgent $cleverBotUserAgent `
											  -ContentType $cleverBotContentType
		
		if($cleverBotCreateBot.status -eq 'success'){
			Write-Verbose "Sucessfully create session with nick: $($cleverBotCreateBot.nick)"
		}
	}
	
	End
	{
	}
}

function Send-ToCleverBot{
	param(
		[Parameter(Mandatory = $true)]
		[string]$CleverBotAPIUser,
		[Parameter(Mandatory = $true)]
		[string]$CleverBotAPIKey,
		[Parameter(Mandatory = $true)]   
		[ValidateNotNullOrEmpty()] 
		[string]$CleverBotNick,
		[Parameter(Mandatory = $true)]   
		[ValidateNotNullOrEmpty()] 
		[string]$CleverBotMsgToSend
	)
	Begin
	{
		$cleverBotAskUrl="https://cleverbot.io/1.0/ask"
		$cleverBotUserAgent="powershell / 1.0"
		$cleverBotContentType="application/json"
	}
	
	Process
	{
		$hashtable = [ordered]@{'user' = $CleverBotAPIUser;
										 'key'  = $CleverBotAPIKey;
										 'nick' = $CleverBotNick;
										 'text' = $CleverBotMsgToSend;
									}
		$cleverBotRequestBody = ConvertTo-Json -InputObject $hashtable
		
		$cleverBotAskBot = Invoke-RestMethod -Uri $cleverBotAskUrl -Method Post `
											  -Body $cleverBotRequestBody `
											  -UserAgent $cleverBotUserAgent `
											  -ContentType $cleverBotContentType
		
		if($cleverBotAskBot.status -eq 'success'){
			Write-Verbose "Sucessfully create session with nick: $($cleverBotCreateBot.nick)"
			Write-Host "`[$($CleverBotNick)`]: $($cleverBotAskBot.Response)"
            $hashtable = @{}
		}
	}
	
	End
	{
	}
}

Export-ModuleMember -function New-CleverBot
Export-ModuleMember -function Connect-ToCleverBot
Export-ModuleMember -function Send-ToCleverBot