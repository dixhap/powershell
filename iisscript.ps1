Set-StrictMode -Version Latest
Import-Module WebAdministration

function create-Newwebsite
{
 Write-Host "Loading configuration file $configFile"

 if((Test-Path $configFile) -eq $false)
    {
        throw "Config file not found: $configFile"
    }


$configfile = "DEV.xml"
[xml]$file = [xml](get-content -Path $configFile)

    #echo "Beginning the installation of  service $service"
    echo ""
    echo "Command line arguments:"
    echo "========================================="
    echo "configSourceFile = $configFile"
    echo "========================================="
    echo ""

$AppPoolName = $file.SelectNodes("/env/AppPools/AppPool/@apppool")[0].Value
echo "$AppPoolName"
$port=$file.SelectSingleNode("/env/IpAddresses/IpAddress/@useport").Value
echo "$Port"
$Address = $file.SelectNodes("/env/IpAddresses/IpAddress/@value2")[0].Value
 echo "$Address"
$Websitename=$file.SelectSingleNode("/env/Websitename/website/@name").Value
echo "$Websitename"

$homedir = $file.SelectNodes("/env/Server-Type/Services/Service/@homedir").Value
echo "$homedir"
$pysicalpath = "C:\test"

    #Check if website exits
    if(-Not(Get-Website | Where-Object {$_.Name -eq "$WebSiteName"}))
    {
        echo "The website $WebSiteName was not found on this server!"
    }
    else {
    echo  "Removing Website $WebSiteName"
       Remove-Website  -Name $WebSiteName
    }


    if(Test-Path "IIS:\Sites\$WebsiteName" -pathType Any)
    {
     write-host "website already exists"
    }
    else
    {
      Write-Output "Creating Website '$WebsiteName'"

        # Create the website
        New-Website -Name $WebsiteName -Port $port -PhysicalPath $pysicalpath -force -ApplicationPool $Apppoolname
    }

    #Check if required HTTPS binding is available
    if(-Not(Get-WebBinding -Name "$WebSiteName" -protocol 'http'))
    {
        echo "Not HTTPS binding was found for $WebSiteName website"
    }


    #Check installation path
    if ( $(Try {Test-Path $homedir.trim() } Catch { $false }) )
    {
       echo "TargetPath $homedir found on target machine. Removing old files."
        Remove-Item -path   "$homedir\*" -Force -Recurse
    }
    Else
    {
        echo "Creating target directory - $homedir."
        New-Item $homedir -type directory
    }

    $bindings = @( @{ protocol="http"; bindingInformation="$address`:$port"} )
    echo $bindings

    # Set the binding with the specified IP Address and port
    Set-WebConfigurationProperty "/system.applicationHost/sites/site[@name='$WebsiteName']" -PSPath IIS:\ -Name Bindings -Value $bindings


}
create-Newwebsite

function create-Newwebsite
{
 Write-Host "Loading configuration file $configFile"

 if((Test-Path $configFile) -eq $false)
    {
        throw "Config file not found: $configFile"
    }


$configfile = "DEV.xml"
[xml]$file = [xml](get-content -Path $configFile)

    #echo "Beginning the installation of  service $service"
    echo ""
    echo "Command line arguments:"
    echo "========================================="
    #echo "website          = $service"
    echo "configSourceFile = $configFile"
    echo "========================================="
    echo ""

$AppPoolName = $file.SelectNodes("/env/AppPools/AppPool/@apppool")[1].Value
echo "$AppPoolName"
$port=$file.SelectSingleNode("/env/IpAddresses/IpAddress/@useport").Value
echo "$Port"
$Address = $file.SelectNodes("/env/IpAddresses/IpAddress/@value2")[3].Value
 echo "$Address"
$Websitename=$file.SelectNodes("/env/Websitename/website/@name")[1].Value
echo "$Websitename"

$homedir = $file.SelectNodes("/env/Server-Type/Services/Service/@homedir").Value
echo "$homedir"

$pysicalpath = "C:\test"

    #Check if website exits
    if(-Not(Get-Website | Where-Object {$_.Name -eq "$WebSiteName"}))
    {
        echo "The website $WebSiteName was not found on this server!"
    }
    else {
    echo  "Removing Website $WebSiteName"
       Remove-Website  -Name $WebSiteName
    }


    if(Test-Path "IIS:\Sites\$WebsiteName" -pathType Any)
    {
     write-host "website already exists"
    }
    else
    {
      Write-Output "Creating Website '$WebsiteName'"

        # Create the website
        New-Website -Name $WebsiteName -Port $port -PhysicalPath $pysicalpath -force -ApplicationPool $Apppoolname
    }

    #Check if required HTTPS binding is available
    if(-Not(Get-WebBinding -Name "$WebSiteName" -protocol 'http'))
    {
        echo "Not HTTPS binding was found for $WebSiteName website"
    }


    #Check installation path
    if ( $(Try {Test-Path $homedir.trim() } Catch { $false }) )
    {
       echo "TargetPath $homedir found on target machine. Removing old files."
        Remove-Item -path   "$homedir\*" -Force -Recurse
    }
    Else
    {
        echo "Creating target directory - $homedir."
        New-Item $homedir -type directory
    }

    $bindings = @( @{ protocol="http"; bindingInformation="$address`:$port"} )
    echo $bindings

    # Set the binding with the specified IP Address and port
    Set-WebConfigurationProperty "/system.applicationHost/sites/site[@name='$WebsiteName']" -PSPath IIS:\ -Name Bindings -Value $bindings


}
create-Newwebsite

function Create-IISAppPool
{

$configfile = "DEV.xml"
[xml]$file = [xml](get-content -Path $configFile)
$AppPoolName = $file.SelectNodes("/env/AppPools/AppPool/@apppool")[0].Value
echo "$AppPoolName"

  $appPoolDotNetVersion = "v4.0"

    # Check that IIS is installed on this machine
    if(!(Get-Service W3SVC -ErrorAction SilentlyContinue))
    {
        throw "IIS is not installed on this machine"
    }

    # Create the app pool if it doesn't already exists
    if (Test-Path "IIS:\AppPools\$Apppoolname" -pathType container)
    {
        Write-Output "App Pool '$Apppoolname' already exists"
    }
    else
    {
        Write-Output "Creating App Pool '$Apppoolname'"

        # Create the app pool (managed pipeline mode: Integrated)
        $Apppoolname = New-WebAppPool -Name $Apppoolname
        $Apppoolname| Set-ItemProperty -Name "managedRuntimeVersion" -Value $appPoolDotNetVersion

    }

    <#if ((Get-WebAppPoolState -Name $Apppoolname).Value -ne "Started") {
        throw "App pool $Apppoolname was created but did not start automatically. Probably something is broken!"
    }#>


}

Create-IISAppPool

function Create-IISAppPool
{

$configfile = "DEV.xml"
[xml]$file = [xml](get-content -Path $configFile)
$AppPoolName = $file.SelectNodes("/env/AppPools/AppPool/@apppool")[1].Value
echo "$AppPoolName"

  $appPoolDotNetVersion = "v4.0"

    # Check that IIS is installed on this machine
    if(!(Get-Service W3SVC -ErrorAction SilentlyContinue))
    {
        throw "IIS is not installed on this machine"
    }

    # Create the app pool if it doesn't already exists
    if (Test-Path "IIS:\AppPools\$Apppoolname" -pathType container)
    {
        Write-Output "App Pool '$Apppoolname' already exists"
    }
    else
    {
        Write-Output "Creating App Pool '$Apppoolname'"

        # Create the app pool (managed pipeline mode: Integrated)
        $Apppoolname = New-WebAppPool -Name $Apppoolname
        $Apppoolname| Set-ItemProperty -Name "managedRuntimeVersion" -Value $appPoolDotNetVersion

    }

    <#if ((Get-WebAppPoolState -Name $Apppoolname).Value -ne "Started") {
        throw "App pool $Apppoolname was created but did not start automatically. Probably something is broken!"
    }#>

}

Create-IISAppPool
