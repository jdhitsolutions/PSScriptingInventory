[cmdletbinding(SupportsShouldProcess)]
Param(

[ValidateScript({
if (Test-Path $_) {
   $True
}
else {
   Throw "Cannot validate path $_"
}
})]
[string]$Path = "C:\Program Files\WindowsPowerShell\Modules"
)
Begin {
    Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"
} #begin
Process {
    Write-Verbose "[PROCESS] Copying $PSScriptRoot to $Path"
    Copy-Item -Path $PSScriptRoot -Destination $Path -Container -Recurse -Force
} #process
End {
    Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
} #end
