# ChangeLog for PSScriptingInventory

## 0.5.1

- Changed required module to `Microsoft.PowerShell.ThreadJob`.
- Minor updates to `README.md`.
- Minor code and manifest cleanup.

## 0.5.0

- Added a `Date` hidden property to the `PSInventory` class.
- Updated `README.md`

## 0.4.0

- Fixed bug in `Get-PSScriptInventory` that was reporting the wrong number of total uses.
- Added code to format all command names to title case.
- Added `Write-Information` statements to `Get-PSScriptInventory`.

## 0.3.0

- Added help documents
- Modified AST filtering to not worry about external commands like notepad.exe.
- Fixed bug in `Measure-ScriptFile` that wasn't detecting aliases.
- Added `PSInventory.format.ps1xml`.
- Added `Get-PSScriptInventory`.

## 0.2.0

- initial git commit
