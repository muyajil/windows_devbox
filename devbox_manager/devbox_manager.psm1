#requires -Version 5

[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseApprovedVerbs", "")]

$Help = @{};

function Devbox-ModuleShellHelp() {
    Write-Host
    Write-Host "Manage Devbox:" -ForegroundColor Yellow
    Get-Command -Module devbox_manager | Select-Object -OutVariable functions >$null
    $aliases = @{};
    Get-Alias | Where-Object { $_.Definition.StartsWith("Devbox-") } | ForEach-Object { $aliases.Add($_.Definition, $_.Name) } >$null
    
    $helpLines = @();
    foreach ($f in $functions) {
        $alias = $aliases[$f.Name]
        if ($alias) {
            $decription = $Help[$alias]
            if (-not($decription)) {
                $decription = $f.Name
            }
            $line = "  - devbox $($alias.PadRight(9, ' ')): $decription"
        }
        else {
            $line = $f.Name
        }
    
        if ($alias -ne "devbox") {
            $helpLines += $line
        }
    }

    $helpLines | Sort-Object | ForEach-Object { Write-Host $_ }
    Write-Host
}
Set-Alias help Devbox-ModuleShellHelp
$Help.Add("help", "Displays all available commands")

function Devbox-Update() {

    param(
        [String] $image_name = "anymodconrst001dg.azurecr.io/darwin.devbox"
    )
    
    Write-Host "Updating image $image_name"

    docker pull $image_name
}
Set-Alias update Devbox-Update
$Help.Add("update", "Update Devbox image")

function Devbox-Build() {

    param(
        [String] $image_name = "devbox-local"
    )
    
    Write-Host "Building image $image_name" -ForegroundColor Green

    docker build -t $image_name .
}
Set-Alias build Devbox-Build
$Help.Add("build", "Build Devbox image")

function Devbox-Logs() {
    param(
        [String] $container_name = "linux_devbox"
    )
    
    docker logs $container_name
}
Set-Alias logs Devbox-Logs
$Help.Add("logs", "Show logs of Devbox")


function Devbox-Run() {
    param(
        [String] $container_name = "linux_devbox",
        [String] $image_name = "registry.gitlab.com/mohammed4/devbox",
        [String] $user_name = "Mohammed Ajil",
        [String] $ssh_keys_path = "`"C:/Users/$user_name/.ssh`"",
        [String] $email = "mohammed@ajil.ch",
        [String] $repository_path = "D:/repositories"
    )

    docker ps --all --filter name=$container_name | ConvertFrom-Docker | Select-Object -OutVariable instances >$null
    if ($instances -and ($instances.Length -ne 0)) {
        $existing = $instances[0]
        if ($existing.Status.Contains("Up")) {
            Write-Host "Stopping '$container_name'" -ForegroundColor Yellow
            docker stop $container_name
        }
        Write-Host "Removing '$container_name'" -ForegroundColor Yellow
        docker rm $container_name
    }
    Write-Host "Creating and starting new container" -ForegroundColor Yellow
    Start-Process docker -Wait -ArgumentList @(
        "run", 
        "-h devbox"
        "-idt",
        "--security-opt seccomp=unconfined ",
        "--name $container_name", 
        "-v ${repository_path}:/repositories",
        "-v ${ssh_keys_path}:/ssh",
        "-p 8080:8080",
        "-p 8081:8081",
        "-p 8082:8082",
        "-p 8083:8083",
        "-p 8084:8084",
        "-p 8085:8085",
        "-p 8086:8086",
        "-p 6006:6006",
        "-p 8888:8888",
        "${image_name}:latest",
        "/bin/bash -c `"git-config.sh && startup.sh && /bin/bash`"")

    docker attach $container_name
}

Set-Alias run Devbox-Run
$Help.Add("run", "Runs Devbox")

function Devbox-RunLocal() {
    Devbox-Run -image_name "devbox-local"
}

Set-Alias runlocal Devbox-RunLocal
$Help.Add("runlocal", "Runs the local image of Devbox")

function Devbox-Attach() {
    param(
        [String] $container_name = "linux_devbox"
    )

    docker attach $container_name
}

Set-Alias attach Devbox-Attach
$Help.Add("attach", "Attaches to the console of the Devbox")

function Devbox-Restart() {
    param(
        [String] $container_name = "linux_devbox"
    )

    Write-Host "Restarting '$container_name'" -ForegroundColor Yellow
    docker restart $container_name
}

Set-Alias restart Devbox-Restart
$Help.Add("restart", "Restart the Devbox")

function Devbox-Stop() {
    param(
        [String] $container_name = "linux_devbox"
    )

    docker ps --all --filter name=$devbox_name | ConvertFrom-Docker | Select-Object -OutVariable instances >$null
    if ($instances -and ($instances.Length -eq 0)) {
        Write-Host "No container with name '$container_name' found" -ForegroundColor Yellow
        return
    }

    $existing = $instances[0]
    if ($existing.Status.Contains("Up")) {
        Write-Host "Stopping container $($existing.ContainerId)" -ForegroundColor Yellow
        docker container stop $existing.ContainerId
    }
    else {
        Write-Host "Container with name '$container_name' $($existing.ContainerId) is not running" -ForegroundColor Yellow
    }
}
Set-Alias stop Devbox-Stop
$Help.Add("stop", "Stops the devbox if it exists")

function Devbox-Command() {
    param(
        [String] $Command
    )

    $aliases = @();
    Get-Alias | Where-Object { $_.Definition.StartsWith("Devbox-") } | ForEach-Object { $aliases += $_.Name } >$null
    if ($aliases.Contains($Command)) {
        . "$Command"
    }
    else {
        if ($Command) {
            Write-Host 
            Write-Error "Command '$Command' is not supported"
            Write-Host
        }
        
        Devbox-ModuleShellHelp
    }
}
Set-Alias devbox Devbox-Command