@{
    RootModule        = "devbox_manager.psm1"
    ModuleVersion     = "0.1.0"
    GUID              = "8ac3cc86-4b46-4411-b584-6beba54b5eb6"
    Author            = "Digitec Galaxus AG"
    Copyright         = "(c) 2018 Digitec Galaxus AG"
    Description       = "PowerShell module to support management devbox"
    PowerShellVersion = "5.0"
    NestedModules     = @("ConvertFromDocker") 
    FunctionsToExport = @("Devbox-Command")    
    AliasesToExport   = @("devbox")
}