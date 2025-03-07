# PSScriptingInventory

A set of PowerShell tools for inventorying PowerShell commands. The code in this module should be considered educational and as proof-of-concept. This code was designed to meet a PowerShell scripting challenge described at [https://ironscripter.us/building-a-powershell-command-inventory/](https://ironscripter.us/building-a-powershell-command-inventory/). Early versions of these commands are described at [https://jdhitsolutions.com/blog/powershell/7549/building-a-powershell-inventory/](https://jdhitsolutions.com/blog/powershell/7549/building-a-powershell-inventory/).

## Concepts and Techniques

The functions are all contained in the .psm1 file. In the code you'll see that I'm taking advantage of these PowerShell concepts and scripting techniques.

- PowerShell Classes and custom objects
- The PowerShell AST
- Formatting .ps1xml files
- Parallelism with thread jobs in Windows PowerShell and `ForEach-Object -parallel` in PowerShell 7
- Regular Expressions
- Write-Verbose
- Write-Information

## Installing

There is no intention of publishing this to the PowerShell Gallery at this time since it doesn't fill a real production need. You are more than welcome to clone or fork this repository. You can also download the latest code in a zip file and extract locally. This project includes a script file, `deploy.ps`, which you can use to copy the module to your Windows PowerShell module location. You will need to deploy the module if you want to take advantage of the background or parallel features.

If you are running Windows PowerShell and want to use the job feature, you'll need to install the Microsoft.PowerShell.ThreadJob module from the PowerShell Gallery.

## Additional Reading

If you want to expand your PowerShell scripting knowledge, or learn more about some of the techniques used in the project, I recommend getting a copy of [The PowerShell Scripting and Toolmaking](https://leanpub.com/powershell-scripting-toolmaking) book.
