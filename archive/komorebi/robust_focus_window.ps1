param (
    [Parameter(Mandatory=$true)]
    [string]$ApplicationName
)

function Focus-RegularApp {
    param (
        [string]$AppName
    )
    
    $processes = Get-Process -Name $AppName -ErrorAction SilentlyContinue

    if ($processes) {
        # Add the Windows API functions needed
        Add-Type @"
            using System;
            using System.Runtime.InteropServices;
            public class AppFocusTools {
                [DllImport("user32.dll")]
                public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
                [DllImport("user32.dll")]
                public static extern bool SetForegroundWindow(IntPtr hWnd);
            }
"@

        # Find the first process with a valid window handle
        $focused = $false
        foreach ($proc in $processes) {
            if ($proc.MainWindowHandle -ne 0) {
                Write-Host "Focusing $AppName window..."
                [AppFocusTools]::ShowWindow($proc.MainWindowHandle, 9) # 9 = SW_RESTORE
                [AppFocusTools]::SetForegroundWindow($proc.MainWindowHandle)
                Write-Host "$AppName window has been focused"
                $focused = $true
                break
            }
        }
        
        if (-not $focused) {
            Write-Host "No visible $AppName window found to focus"
        }
    } else {
        Write-Host "$AppName is not running"
    }
}

function Focus-Explorer {
    # Add a type with a unique name to avoid conflicts
    Add-Type @"
        using System;
        using System.Runtime.InteropServices;
        using System.Text;
        
        public class ExplorerFocusTools {
            [DllImport("user32.dll")]
            public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);
            
            [DllImport("user32.dll")]
            public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
            
            [DllImport("user32.dll")]
            public static extern bool SetForegroundWindow(IntPtr hWnd);
            
            [DllImport("user32.dll")]
            public static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);
            
            [DllImport("user32.dll")]
            public static extern int GetClassName(IntPtr hWnd, StringBuilder lpClassName, int nMaxCount);
            
            [DllImport("user32.dll")]
            public static extern bool IsWindowVisible(IntPtr hWnd);
            
            public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);
        }
"@

    # Create a static variable to store the found window handle
    $script:explorerHandle = [IntPtr]::Zero
    
    # Create a delegate for EnumWindows
    $callback = [ExplorerFocusTools+EnumWindowsProc] {
        param($hwnd, $lparam)

        if ([ExplorerFocusTools]::IsWindowVisible($hwnd)) {
            $classname = New-Object System.Text.StringBuilder 256
            [ExplorerFocusTools]::GetClassName($hwnd, $classname, $classname.Capacity) | Out-Null
            
            if ($classname.ToString() -eq "CabinetWClass") {
                $script:explorerHandle = $hwnd
                return $false  # Stop enumeration
            }
        }
        return $true  # Continue enumeration
    }
    
    # Enumerate windows
    [ExplorerFocusTools]::EnumWindows($callback, [IntPtr]::Zero) | Out-Null
    
    if ($script:explorerHandle -ne [IntPtr]::Zero) {
        Write-Host "Focusing File Explorer window..."
        [ExplorerFocusTools]::ShowWindow($script:explorerHandle, 9)  # SW_RESTORE
        [ExplorerFocusTools]::SetForegroundWindow($script:explorerHandle)
        Write-Host "File Explorer window has been focused"
    } else {
        Write-Host "No File Explorer windows found to focus"
        Write-Host "Opening a new File Explorer window..."
        Start-Process "explorer.exe"
    }
}

# Main script logic
if ($ApplicationName -eq "Explorer" -or $ApplicationName -eq "FileExplorer" -or $ApplicationName -eq "explorer") {
    Focus-Explorer
} else {
    Focus-RegularApp -AppName $ApplicationName
}