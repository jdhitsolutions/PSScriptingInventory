---
external help file: PSScriptingInventory-help.xml
Module Name: PSScriptingInventory
online version:
schema: 2.0.0
---

# Get-ASTToken

## SYNOPSIS

Process a PowerShell file for its AST tokens

## SYNTAX

```yaml
Get-ASTToken [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION

This command will analyze a PowerShell script file and return a collection of AST tokens.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-ASTToken c:\scripts\test.ps1
```

## PARAMETERS

### -Path

The path to a PowerShell script file. It should be a .ps1 or .psm1 file.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS
