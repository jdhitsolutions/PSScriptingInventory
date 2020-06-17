---
external help file: PSScriptingInventory-help.xml
Module Name: PSScriptingInventory
online version:
schema: 2.0.0
---

# Get-PSScriptInventory

## SYNOPSIS

Get command measurements for all files in a directory.

## SYNTAX

```yaml
Get-PSScriptInventory [-Path] <String> [-Recurse] [-BatchSize <Int32>] [<CommonParameters>]
```

## DESCRIPTION

This command is designed to make it easy to process an entire folder of PowerShell files. You get the same result as if you had manually used Measure-ScriptFile. For small collections of files all you need to do is specify the path. For larger directories, with hundreds of files, you have an option to process the folder in batches. Specify a BatchSize value of 50,100,250, or 500. A value of 0 means do not use batch processing. The command will process the files roughly in parallel in batches. If you are running PowerShell 7 this command will use the -Parallel feature of ForEach-Object. Otherwise, it will use thread jobs.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-PSScriptInventory -path c:\scripts\psscriptinginventory


Name                         Total FileCount
----                         ----- ---------
Write-Verbose                   26         2
Write-Information               12         1
Get-Date                         4         1
Write-Host                       3         1
ForEach-Object                   3         1
Measure-ScriptFile               3         1
Get-PSFile                       3         1
Test-Path                        2         2
Start-ThreadJob                  2         1
New-TimeSpan                     2         1
Sort-Object                      2         1
Get-Command                      2         1
New-Variable                     2         1
Get-ASTToken                     1         1
Convert-Path                     1         1
Get-ChildItem                    1         1
Copy-Item                        1         1
Wait-Job                         1         1
Receive-Job                      1         1
Remove-Job                       1         1
Group-Object                     1         1
```

### Example 2

```powershell
PS C:\> $r = Get-PSScriptInventory -Path C:\scripts\PSScriptTools\ -Recurse -BatchSize 50

[01:34:12.2359] Processing Set2 in parallel
[01:34:12.2578] Processing Set1 in parallel
PS C:\> $r | Select-object -first 10


Name                         Total FileCount
----                         ----- ---------
Write-Verbose                    2        45
Write-Detail                     2         6
Test-Expression                  2         2
Sort-Object                      2        12
Select-Object                    2        15
Measure-Object                   2         8
Import-Module                    2         2
Get-Process                      2         3
Get-Alias                        2         3
Format-Table                     2         2
```

This example processes files in batches of 50 in a PowerShell 7 session.

## PARAMETERS

### -BatchSize

Specify the number of files to batch process. A value of 0 means do not run in batches or parallel. If you are running PowerShell 7, the command will use the -Parallel feature of ForEach-Object. For Windows PowerShell, it will use a series of thread jobs.

A value of 0 indicates to not run in batch mode.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:
Accepted values: 0, 50, 100, 250, 500

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path

Specify the root folder path

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Recurse

Recurse for files.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### PSInventory

## NOTES

This command has an alias of ps1.

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Measure-ScriptFile]()

[Get-PSFile]()
