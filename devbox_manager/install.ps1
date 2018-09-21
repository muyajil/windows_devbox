$devbox_manager_path = "$((get-item $profile).Directory.FullName)\Modules\devbox_manager"
Copy-Item "." -Destination "$devbox_manager_path" -Recurse
Add-Content -Value "`r`nImport-Module `"$devbox_manager_path`"" -Path $profile
& $profile