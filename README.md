# PhpVM
**Php Version Manager - Windows 10/11**

This utility was created in PowerShell (ps1). To execute scripts in your Windows terminal, you'll need to adjust the "Execution Policy." Run the following command to do so:

These scripts are unsigned, run at your own risk!

```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass
```

For more information about execution policies, check out this [link](https://learn.microsoft.com/pt-br/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.4).

## How to use

The releases of this project already have the executable file, it is an exe file and works with a CLI interface. If you want to build the executable yourself, just run the "build.ps1" file from the project root and it will build the executable in the "/bin" folder, this must be listed in the "PATH" of your environment variables to work, PhpVM has a function to add the necessary variables. If you do not want to use the executable file and want to use the ps1 file as it is, just move the "/src/main.ps1" file to the "/bin" folder and rename it to "phpvm.ps1", note that neither the ps1 files nor the executable file are signed, above is a brief tutorial on how to run ps1 scripts without a signature, to run exe files without a signature just allow the execution in your antivirus.

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

3. Important!
If you have any PHP installation, you will need to remove the path of that installation.


After completing these steps, you may need to restart your Windows system.

Now, in your console, type the following command:
```bash
phpvm
```

## Screenshots

![](https://i.imgur.com/5Q4nXRx.png)


## Uninstall

To uninstall PhpVM follow these steps:

1. Remove the paths from the environment variables, the paths are "C:\PhpVM\bin", "C:\php".

2. Delete the symbolic link, it is located in "C:\php".

3. Delete the PhpVM folder, it is located at "C:\PhpVM"