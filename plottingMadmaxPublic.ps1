#Variablen nach deinen Wünschen anpassen 
$maxNumberOfPlots = 100
$maxNumberOfParallelPlots = 2
$minMinutesBetweenPlots = 15

#Funktion zum Überprüfen wie viele chia_plot.exe Prozesse laufen
function numInstances([string]$process)
{
    @(Get-Process $process -ErrorAction 0).Count
}

#So viele Plot-Prozesse hintereinander starten, wie unter $maxNumberOfPlots angegeben sind
for ($i = 1; $i -le $maxNumberOfPlots; $i++) {
	# Die Anzahl der laufenden Prozesse mit $maxNumberOfParallelPlots vergleichen
	# Wenn $maxNumberOfParallelPlots erreicht ist, 60 Sekunden warten und dann noch mal prüfen
	# Wenn $processCount < $maxNumberOfParallelPlots Schleife beenden
	Do {
		# Anzahl der chia_plot.exe-Prozesse holen
		$processCount = numInstances chia_plot
		# Aktuelle Uhrzeit holen
        	$date = Get-Date -format "yyyy-MM-dd hh:mm:ss"
        	# Ausgabe in PS
		"$date - $processCount/$maxNumberOfParallelPlots Plot-Prozesse gefunden"

		if ($processCount -eq $maxNumberOfParallelPlots) {
            		# Wenn $maxNumberOfParallelPlots erreicht ist, 60 Sekunden warten und dann noch mal prüfen
			"$date - Warten bis ein Plot beendet wurde"
            		start-Sleep 60    
        	} else {
            		"$date - Plot Nummer $i starten"
        	}
	} While ($processCount -eq $maxNumberOfParallelPlots)
	
	# Neuen Plot-Prozess starten
    	#Start-Process -FilePath powershell.exe -ArgumentList "C:\<pfad zu madmax plotter>\chia_plot.exe -n 1 -t F:\ -2 F:\ -d L:\ -c <contract> -f <farmerkey>"

    	# Ausgabe in PS
	"$date - $minMinutesBetweenPlots Minuten warten bis der nächste Plot gestartet wird"

	# Solange warten wie in $minMinutesBetweenPlots angegeben ist, minütlich Ausgabe in der PS
    	for ($min = 1; $min -le $minMinutesBetweenPlots; $min++) {
        	Start-Sleep 60
        	$date = Get-Date -format "yyyy-MM-dd hh:mm:ss"
        	$minAct = $minMinutesBetweenPlots - $min
        	"$date - $minAct Minuten warten bis der nächste Plot gestartet wird"
	}
}
