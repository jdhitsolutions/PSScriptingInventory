---
external help file: PSScriptingInventory-help.xml
Module Name: PSScriptingInventory
online version:
schema: 2.0.0
---

# Measure-ScriptFile

## SYNOPSIS

Get PowerShell commands used in a given file.

## SYNTAX

```yaml
Measure-ScriptFile [-Path] <String> [-ResolveCommands] [<CommonParameters>]
```

## DESCRIPTION

This command can be used to analyze a PowerShell script file and discover what commands it is using. Aliases should be detected and reported using their resolved command name. By default, all other commands will be treated as commands if the AST token is a command and the value matches a "word-word" regular expression pattern. As an alternative you can use the -ResolveCommands parameter to validate against all available commands on your computer. Note that this may not take into account valid commands that belong to modules no longer on your computer.

## EXAMPLES

### Example 1

```powershell
PS C:\> Measure-ScriptFile c:\scripts\deploy.ps1


Name                         Total FileCount
----                         ----- ---------
Write-Verbose                    3         1
Test-Path                        1         1
Copy-Item                        1         1
```

The resulting object shows you the total number of times the command is used. The FileCount property indicates the number of files that use this command.

### Example 2

```powershell
PS C:\> Get-PSFile c:\work | Measure-ScriptFile | Select-Object -First 1 -Property Name,Total,Files


Name       Total Files
----       ----- -----
Write-Host    21 {C:\work\Demo-UpdateList.ps1, C:\work\Install-PowerLab.ps1, C:\work\prom…
```

Get the most used command in files under C:\Work and display the specified properties.

## PARAMETERS

### -Path

The path to a PowerShell script file.

```yaml
Type: String
Parameter Sets: (All)
Aliases: fullname

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -ResolveCommands

Test possible command names against Get-Command.

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

### System.String

## OUTPUTS

### PSInventory

## NOTES

This command has an alias of msf.

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-PSScriptInventory]()
