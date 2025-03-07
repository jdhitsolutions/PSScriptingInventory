#define an inventory class

class PSInventory {
    [string]$Name
    [int32]$Total
    [string[]]$Files
    hidden [datetime]$Date = (Get-Date)
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
        [ValidateScript( {
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
        Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.MyCommand)"
        $PSBound@PSBoundParameters.Add("File", $True)
        $PSBound@PSBoundParameters.Add("Filter", "*.ps*")
        if (-Not $PSBound@PSBoundParameters.ContainsKey("Path")) {
            #add the default to PSBound@PSBoundParameters
            $PSBound@PSBoundParameters.Add("Path", $Path)
        }
    } #begin
    Process {
        Write-Verbose "[PROCESS] Getting all PowerShell related files under $(Convert-Path $Path)"
        #$PSBound@PSBoundParameters | out-string | write-verbose
        #this should get .ps1, .psm1, .psd1 files
        (Get-ChildItem @PSBoundParameters).Where({$_.Extension -match "\.ps(m|d)?1$"})

    } #process
    End {
        Write-Verbose "[END    ] Ending: $($MyInvocation.MyCommand)"
    } #end
}

Function Get-ASTToken {
    [CmdletBinding()]

    Param (
        [Parameter(Mandatory, Position = 0)]
        [string]$Path
    )

    Begin {
        Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.MyCommand)"
        New-Variable astTokens -force
        New-Variable astErr -force
    } #begin

    Process {
        $cPath = Convert-Path $Path
        Write-Verbose "[PROCESS] Getting AST Tokens from $cPath"
        $AST = [System.Management.Automation.Language.Parser]::ParseFile($cPath, [ref]$astTokens, [ref]$astErr)
        [void]$AST.FindAll({$args[0] -is [System.Management.Automation.Language.CommandAst]}, $true)
        $astTokens
    } #process

    End {
        Write-Verbose "[END    ] Ending: $($MyInvocation.MyCommand)"
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
        Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.MyCommand)"
        $start = Get-Date
        Write-Information "Starting $($MyInvocation.MyCommand)" -Tags meta
        $fileCounter = 0
        $all = @()
        if ($ResolveCommands) {
            #get all commands
            Write-Verbose "[BEGIN  ] Building command inventory"
            $cmds = (Get-Command -CommandType Filter, Function, Cmdlet).Name
            Write-Verbose "[BEGIN  ] Using $($cmds.count) command names"
        }
        #get TextInfo object to be used later for formatting commands to title case
        $TextInfo = (Get-Culture).TextInfo
    } #begin

    Process {
        Write-Information "Processing $(Convert-Path $Path)" -Tags process
        $fileCounter++
        $AST = Get-ASTToken -path $Path
        $ASTTokens = ($AST).where( {$_.tokenFlags -eq "CommandName" -AND (-Not $_.NestedTokens)})
        Write-Verbose "[PROCESS] Processing $($ASTTokens.count) tokens"

        foreach ($Token in $ASTTokens) {
            #resolve alias
            Write-Information "Token: $($token.text) Kind: $($token.kind)"
            if ($token.kind -eq 'identifier') {
                Try {
                    Write-Information "[PROCESS] Resolving $($token.text) alias" -Tags process
                    $value = (Get-Command -Name $token.text -ErrorAction stop).ResolvedCommandName
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
                    $item = $all.where( {$_.name -eq $Value})[0]
                }
                else {
                    #create a new result
                    $item = [PSInventory]::new($TextInfo.ToTitleCase($Value.ToLower()))
                    $all += $item
                }
                Write-Information "[PROCESS] Updating $($item.name) inventory object" -Tags process
                $item.Total++
                #only add the file if it doesn't already exist
                if ($item.files -notcontains $path) {
                    $item.Files += $Path
                }
            }
        } #foreach
    } #process

    End {
        $all | Sort-Object -Property Total -Descending
        $end = Get-Date
        Write-Information "End time $end" -Tags meta
        $run = New-TimeSpan -Start $start -End $end
        Write-Verbose "[END    ] Processed $fileCounter files in $run"
        Write-Information "Processed $fileCounter files in $run" -Tags meta
        Write-Verbose "[END    ] Ending: $($MyInvocation.MyCommand)"
    } #end
}

Function Get-PSScriptInventory {
    [cmdletbinding()]
    [alias("psi")]
    [OutputType("PSInventory")]

    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = "Specify the root folder path")]
        [string]$Path,
        [Parameter(HelpMessage = "Recurse for files")]
        [switch]$Recurse,
        [Parameter(HelpMessage = "Specify the number of files to batch process. A value of 0 means do not run in batches or parallel.")]
        [ValidateSet(0,50,100,250,500)]
        [int]$batchSize = 0
    )
    Begin {
        Write-Verbose "[BEGIN  ] Starting $($MyInvocation.MyCommand)"
        $starttime = Get-Date
        Write-Verbose "[BEGIN  ] $Starttime"
        Write-Information "Starting $($MyInvocation.MyCommand)" -tags meta
    } #begin
    Process {
        Write-Verbose "[PROCESS] Processing $Path"
        if ($batchSize -eq 0) {
            Get-PSFile -Path $Path -Recurse:$Recurse -OutVariable f |
            Measure-ScriptFile
            $totalFileCount = $f.count
        }
        else {
            Write-Verbose "[PROCESS] Processing batch size $batchSize"
            Write-Information "Using batch processing size $batchSize" -Tags meta
            #use Foreach-Parallel if PowerShell 7
            if ($IsCoreCLR) {
                Write-Verbose "[PROCESS] Processing in parallel"
                $files = Get-PSFile -Path $Path -Recurse:$Recurse
                $totalFileCount = $files.count
                $sets = @{}
                $c = 0
                for ($i = 0 ; $i -lt $files.count; $i += $batchSize) {
                    $c++
                    $start = $i
                    $end = $i + ($batchSize-1)
                    $sets.Add("Set$C", @($files[$start..$end]))
                }
                $results = $sets.GetEnumerator() | ForEach-Object -Parallel {
                    Write-Host "[$(Get-Date -format 'hh:mm:ss.ffff')] Processing $($_.name) in parallel" -ForegroundColor cyan
                    Write-Information "Processing $($_.name)" -tags meta
                    $_.value | Measure-ScriptFile
                }
            } #coreCLR
            else {
                Write-Verbose "[PROCESS] Processing with thread jobs"
                Get-PSFile -Path $Path -Recurse:$Recurse |
                ForEach-Object -begin {
                    $totalFileCount = 0
                    $tmp = [System.Collections.Generic.List[object]]::new()
                    $jobs = @()

                    #define the scriptblock to run in a thread job
                    $sb = {
                        Param([object[]]$Files)
                        $files | Measure-ScriptFile
                    }
                } -process {
                    if ($tmp.Count -ge $batchSize) {
                        Write-Host "[$(Get-Date -format 'hh:mm:ss.ffff')] Processing set of $($tmp.count) files" -ForegroundColor cyan
                        Write-Information "Starting thread job" -Tags meta
                        $jobs += Start-ThreadJob -ScriptBlock $sb -ArgumentList @(, $tmp.ToArray()) -Name tmpJob
                        $tmp.Clear()
                    }
                    $totalFileCount++
                    $tmp.Add($_)
                } -end {
                    #use the remaining objects
                    Write-Host "[$(Get-Date -format 'hh:mm:ss.ffff')] Processing remaining set of $($tmp.count) of files" -ForegroundColor cyan
                    $jobs += Start-ThreadJob -ScriptBlock $sb -ArgumentList @(, $tmp.ToArray()) -name tmpJob
                }
                #wait for jobs to complete
                Write-Verbose "[PROCESS] Waiting for $($jobs.count) jobs to complete"
                $results = $jobs | Wait-Job | Receive-Job
                $jobs | Remove-Job
            } #Windows PowerShell

            Write-Verbose "[PROCESS] Merging $($results.count) results"
            Write-Information "Merging $($results.count) results" -tags meta
            $output = $results | Group-Object -Property Name | Foreach-Object {
                #create a new PSInventory object from the merged results
                $r = [PSInventory]::New($_.Name)
                $r.Total = ($_.group | Measure-Object -Property Total -sum).sum
                $r.files = $_.group.files
                $r
            }
            $output | Sort-Object -Property Total,Name -Descending
        }
    } #process
    End {
        $endtime = Get-Date
        Write-Verbose "[END    ] $endtime"
        $runtime = New-TimeSpan -Start $starttime -End $endtime
        Write-Verbose "[END    ] Processed $totalFileCount files in $runtime"
        Write-Verbose "[END    ] Ending $($MyInvocation.MyCommand)"
        Write-Information "PSScriptInventory processed $totalFileCount files in $runtime" -tags meta
        Write-Information "Ending $($MyInvocation.MyCommand)" -tags meta
    } #end
}