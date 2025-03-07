#
# Module manifest for module 'PSScriptingInventory'
#


@{

# Script module or binary module file associated with this manifest.
RootModule = 'PSScriptingInventory.psm1'

# Version number of this module.
ModuleVersion = '0.5.1'

# Supported PSEditions
CompatiblePSEditions = @("Desktop","Core")

# ID used to uniquely identify this module
GUID = 'ee9a0a44-11ac-4b2c-bc89-436bcf055692'

# Author of this module
Author = 'Jeff Hicks'

# Company or vendor of this module
CompanyName = 'JDH Information Technology Solutions, Inc.'

# Copyright statement for this module
Copyright = '(c) 2020-2025 JDH Information Technology Solutions, Inc.'

# Description of the functionality provided by this module
Description = 'A set of commands for inventorying PowerShell script files.'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.1'

# Modules that must be imported into the global environment prior to importing this module
RequiredModules = @('Microsoft.PowerShell.ThreadJob')

# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = @('PSInventory.format.ps1xml')

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = 'Get-PSFile', 'Get-ASTToken', 'Measure-ScriptFile','Get-PSScriptInventory'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = ''

# Variables to export from this module
VariablesToExport = ''

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = 'msf','psi'

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @("AST","scripting")

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        # ProjectUri = ''

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

