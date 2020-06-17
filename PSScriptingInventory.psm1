#define an inventory class

class PSInventory {
 [string]$Name
 [int32]$Total
 [string[]]$Files
 hidden [string]$Computername = [System.Environment]::MachineName

 PSInventory([string]$Name) {
    $this.Name = $Name
 }
}

Function Get-PSFile {
[cmdletbinding()]
[OutputType([System.IO.Fileinfo])]

Param(
[Parameter(Position = 0, HelpMessage = "The root folder to search")]

[ValidateScript({
if (Test-Path $_) {
   $True
}
else {
   Throw "Cannot validate path $_"
}
})]

[string]$Path = ".",
[switch]$Recurse
)
Begin {
    Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"  
    $PSBoundParameters.Add("File",$True)
    $PSBoundParameters.Add("Filter","*.ps*")
    if (-Not $PSBoundParameters.ContainsKey("Path")) {
        #add the default to PSBoundParameters
        $PSBoundParameters.Add("Path",$Path)
    }
} #begin
Process {
    Write-Verbose "[PROCESS] Getting all PowerShell related files under $(Convert-Path $Path)"  
    #$psboundparameters | out-string | write-verbose
    #this should get .ps1, .psm1, .psd1 files
    (Get-ChildItem @PSBoundparameters).Where({$_.Extension -match "\.ps(m|d)?1$"})

} #process
End {
    Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
} #end
}

Function Get-ASTToken {
[CmdletBinding()]

Param (
[Parameter(Mandatory,Position=0)]
[string]$Path
)

Begin {
    Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"  
    New-Variable astTokens -force
    New-Variable astErr -force
} #begin

Process {
    $cPath = Convert-Path $Path
    Write-Verbose "[PROCESS] Getting AST Tokens from $cpath"
    $AST = [System.Management.Automation.Language.Parser]::ParseFile($cPath, [ref]$astTokens, [ref]$astErr)
    [void]$AST.FindAll({$args[0] -is [System.Management.Automation.Language.CommandAst]}, $true)
    $astTokens

} #process

End {
    Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
} #end
}

Function Measure-ScriptFile {
    [cmdletbinding()]
    [alias("msf")]
    [OutputType("PSInventory")]

    Param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [alias("fullname")]
        [string]$Path,
        [Parameter(HelpMessage = "Test possible command names against Get-Command.")]
        [switch]$ResolveCommands
    )

    Begin {
        Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"
        $start = Get-Date
        Write-Information "Start time $start" -Tags meta
        $filecounter = 0
        $all = @()
        if ($ResolveCommands) {
            #get all commands
            Write-Verbose "[BEGIN  ] Building command inventory"
            $cmds = (Get-Command -commandtype Filter, Function, Cmdlet).Name
            Write-Verbose "[BEGIN  ] Using $($cmds.count) command names"
        }
    } #begin

    Process {
        Write-Information "Processing $(Convert-Path $Path)" -Tags process
        $filecounter++
        $AST = Get-ASTToken -path $Path
        #filter for commands but not file system commands like notepad.exe
        $ASTTokens = ($AST).where({$_.tokenFlags -eq "commandname" -AND (-Not $_.nestedtokens) -AND ($_.text -notmatch "\.")})
        Write-Verbose "[PROCESS] Processing $($ASTTokens.count) tokens"
                 
        foreach ($Token in $ASTTokens) {
            #resolve alias            
            if ($_.kind -eq 'identifier') {
                Try {
                    Write-Information "[PROCESS] Resolving $($_.text) alias" -Tags process
                    $value = (Get-Command -Name $_.text -ErrorAction stop).ResolvedCommandName
                }
                Catch {
                    #ignore the error
                    $msg = "Unresolved: text:{1} in $filename" -f $filename, $token.text
                    Write-Information $msg -Tags process
                    $value = $null
                }
            }   #if identifier
            elseif ($token.text -eq '?') {
                Write-Information "[PROCESS] Resolving ? to Where-Object" -Tags process
                $Value = 'Where-Object'
            }
            elseif ($token.text -eq '%') {
                Write-Information "[PROCESS] Resolving % to ForEach-Object" -Tags process
                $value = 'ForEach-Object'
            }            
            elseif ($ResolveCommand -AND ($cmds -contains $token.text)) {
                Write-Information "[PROCESS] Using Resolved command $($Token.text)" -Tags process
                $value = $token.text
            }
            #test if the text looks like a command name
            elseif ($token.text -match "\w+-\w+") {
                Write-Information "[PROCESS] Using regex pattern for $($token.text)" -Tags process
                $value = $token.text
            }
            if ($Value) {
                if ($all.name -contains $Value) {
                    $item = $all.where({$_.name -eq $Value})[0]
                }
                else {
                    #create a new result
                    $item = [PSInventory]::new($Value)
                    $all+=$item
                }
                Write-Information "[PROCESS] Updating $($item.name) inventory object" -Tags process
                $item.Total++
                #only add the file if it doesn't already exist
                if ($item.files -notcontains $path) {
                    $item.Files+=$Path
                }
            }
        } #foreach
    } #process

    End {
        $all | Sort-Object -Property Total -Descending
        $end = Get-Date
        Write-Information "End time $end" -Tags meta
        $run = New-Timespan -Start $start -End $end
        Write-Verbose "[END    ] Processed $filecounter files in $run"
        Write-Information "Processed $filecounter files in $run" -Tags meta
        Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
    } #end
}

#Export-ModuleMember -function Get-PSFile,Get-ASTToken,Measure-ScriptFile -alias msf