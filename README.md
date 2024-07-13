# PhpVM
**Php Version Manager - Windows 10/11**

This utility was created in PowerShell (ps1). To execute scripts in your Windows terminal, you'll need to adjust the "Execution Policy." Run the following command to do so:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
```

For more information about execution policies, check out this [link](https://learn.microsoft.com/pt-br/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.4).

To install this tool, follow these steps:

1. Extract the [latest release](https://github.com/ThiagoDOM/PhpVM/releases) to the "C:\" directory. The path to the script should be "C:\PhpVM\bin\phpvm.ps1."

2. Next, add two paths to your PATH environment variables. I've provided a script to do this automatically, or you can add them manually:

   - **Automatic**: Run the following script:
     ```
     C:\PhpVM\src\setPaths.ps1
     ```

   - **Manual**: Add the following paths:
     ```
     C:\PhpVM\bin;
     C:\php;
     ```


After completing these steps, you may need to restart your Windows system.

Now, in your console, type the following command:
```bash
phpvm
```

## Screenshots

![](https://i.imgur.com/6lAZJ4q.png)