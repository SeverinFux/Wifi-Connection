#Holt den Namen der aktell verbundenen Internetvebindung
$wifiName = (Get-NetConnectionProfile | Select-Object -ExpandProperty Name)

#Path für die benötigten Apps
$teamsPath = "C:\Program Files\Microsoft Teams.lnk"
$riotPath = "C:\Riot Games\Riot Client\RiotClientServices.exe"
$minecraftPath = "C:\XboxGames\Minecraft Launcher\Content\Minecraft.exe"
$teampath = "C:\Program Files (x86)\Steam\steam.exe"
$youtubeplaylistLink = "https://www.youtube.com/watch?v=3xt8Mp8oWzc&list=RDMM&start_radio=1" 
$serverproLink = "https://server.pro/"
$inteliJ = "C:\Program Files\JetBrains\IntelliJ IDEA 2021.2\bin\idea64.exe" 


 function Close-Process {
    param (
      #1. Parameter wird auf "$ProcessName" referenziert
       $ProcessName
    )
    
    #Holt den Prozess mit dem Namen vom Parameter + unterdrückt bei errors
    $Process = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue

    #Überprüft ob der geholte Prozess befüllt ist
    if ($Process) {
      #Stop den Prozess anhand der ID
      Stop-Process -Id $Process.Id
      #Passende User ausgabe im Terminal
      Write-Output "$ProcessName process terminated."
    }
    else {
      #Fehler werden nicht weiter behandelt und gibt "not running" aus, wenn der Prozess ungültig / leer ist.
      Write-Output "$ProcessName is not running."
    }
}

function Start-Process-by-Path{
    param (
      #Parameter [ProcessPath] wird auf "$ProcessPath" referenziert
      #Parameter [ProcessName] wird auf "$ProcessName" referenziert
      [string]$ProcessPath,
      [string]$ProcessName
    )
    #Text im Terminal
    Write-Output "$ProcessName is starting."
    #Start den Prozess mit dem Pfad
    Start-Process -FilePath $ProcessPath
}
#Falls der -FilePath nicht funtktioniert, gibt es als Lösung die App-ID (Für Ausgabe der App-ID's im Terminal: "Get-StartApps")
function Open-Process-By-App-Id {
    param (
    [string]$ProcessAppId,
    [string]$ProcessName
    )
 	Write-Output "$ProcessName is starting."
	start shell:AppsFolder\$ProcessAppId
}
#------------------Close-Funktionen------------------

function CloseMinecraftLauncher {
 Close-Process -ProcessName "Minecraft"
}
function CloseSpotify{
  Close-Process -ProcessName "Spotify"
}
function CloseDiscord {
  Close-Process -ProcessName "Discord"
}
function CloseChrome {
  Close-Process -ProcessName "Chrome"
}
function CloseValorant {
  Close-Process -ProcessName "Valorant"
}
function CloseAll{
	#Holt jedes Fenster und jedes offene wird geschlossen (Für das stoppen (Nicht Schliessen) könnte "killall5 -9" verwendet werden jedoch nicht nötig.
	Get-Process | foreach { $_.CloseMainWindow() | Out-Null }
}
#------------------Open-Funktionen------------------

function OpenTeams {
    Start-Process-by-Path $teamsPath "Teams"
}
function OpenRiotClient {
    Start-Process-by-Path $riotPath "Riot Client"
}
function OpenMinecraftLauncher {
    Start-Process-by-Path $minecraftPath "Minecraft Client"
}
function OpenOtherGames {
    Start-Process-by-Path $teampath "Steam"
}
function OpenMusic {
	Start-Process-by-Path $youtubeplaylistLink "YouTube-Playlist for Muisc"
}

function OpenServerPro {
	Start-Process-by-Path $serverproLink "Server.pro"
}
function OpenInteliJ {
	Start-Process-by-Path $inteliJ "InteliJ"
}
function OpenDiscord {
	Open-Process-By-App-Id "com.squirrel.Discord.Discord" "Discord"
}


#------------------Check-Wifi------------------

#Switch für die Auswertung vom WifiName. Je nach Name werden unterschiedliche Methoden aufgerufen...
switch ($wifiName) {
    "BBW-Student" {
	CloseMinecraftLauncher
	CloseSpotify
	CloseDiscord
	CloseValorant
	CloseChrome
	OpenTeams
    }
    "Sunrise_5GHz_2CADE0" {
		do {
		#Beim Internet Zuhause wird gibt es 3 Möglichkeiten. Gefragt wird im Terminal.
    		$doing = Read-Host "Was will'ste machen?`n[0]-Valorant`n[1]-Minecraft`n[2]-Games`n[3]-Anderes`nEingabe"
		#Überpüft, ob der Input zwischen <= als 1 und >= als 2 ist
		} while (-not ($doing -ge 0 -and $doing -le 3))

		#
		switch ($doing) {
			0 {
				Write-Host "Valorant"
				OpenRiotClient
				CloseAll
			
			}
			1 {
				Write-Host "Minecraft"
				OpenMinecraftLauncher
				OpenDiscord
				OpenMusic
				ServerPro
			}
			2 {
				Write-Host "Games"
				OpenDiscord
				OpenMusic
				OpenOtherGames
				OpenServerPro
			}
			3 {
				Write-Host "Anderes"
				#Lässt alles wie es ist
			}
		}
    }
    "Swisscom_1"{
	CloseDiscord
	CloseValorant
	CloseMinecraftLauncher
        OpenInteliJ
	OpenMusic
    }
    default {
        # Falls kein's der 3 Verbindungen gewählt ist
         Write-Host "Du bist in einem, mir unbekannten Wlan. Mach dein zeug selbst!"
    }
}
#Close / Open (https://chat.openai.com/...)
#GetWifi-Name (https://chat.openai.com/...)
#killall5 -9  (https://superuser.com/questions/161531/how-to-kill-all-processes-in-linux)
#Input in Range (https://stackoverflow.com/questions/50521798/how-to-check-if-a-number-is-within-a-range-in-shell)