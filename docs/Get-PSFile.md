---
external help file: PSScriptingInventory-help.xml
Module Name: PSScriptingInventory
online version:
schema: 2.0.0
---

# Get-PSFile

## SYNOPSIS

Get PowerShell related files

## SYNTAX

```yaml
Get-PSFile [[-Path] <String>] [-Recurse] [<CommonParameters>]
```

## DESCRIPTION

Get all PowerShell related files in a given path. This will be files with an extension of .ps1, .psm1 or .psm1.

## EXAMPLES

### Example 1

```powershell
PS C:\> $ps = Get-PSFile -path c:\scripts
```

## PARAMETERS

### -Path

The root folder to search.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: .
Accept pipeline input: False
Accept wildcard characters: False
```

### -Recurse

Search sub-folders for PowerShell files.

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

### System.IO.FileInfo

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-PSScriptInventory]()
