@echo off
setlocal
cd /d "%~dp0"
title CUBIK

rem  Serve CUBIK da localhost invece che da disco.
rem  Da localhost il browser tiene una memoria sola: quello che salvi resta anche
rem  quando passi a una versione nuova del file. Aperto da disco, invece, ogni copia
rem  e' un mondo a se'.
rem
rem  Lascia questa finestra aperta mentre lavori. Per chiudere: premi Ctrl+C.

set PORTA=8765

echo.
echo   CUBIK
echo   ---------------------------------------------
echo   Apro il browser su http://localhost:%PORTA%/cubik.html
echo   Lascia aperta questa finestra mentre lavori.
echo.

start "" "http://localhost:%PORTA%/cubik.html"

where python >nul 2>nul
if %errorlevel%==0 (
  python -m http.server %PORTA%
  goto :fine
)

where py >nul 2>nul
if %errorlevel%==0 (
  py -m http.server %PORTA%
  goto :fine
)

where node >nul 2>nul
if %errorlevel%==0 (
  echo   Uso Node al posto di Python.
  node -e "const h=require('http'),f=require('fs'),p=require('path');h.createServer((q,s)=>{let u=decodeURIComponent(q.url.split('?')[0]);if(u==='/')u='/cubik.html';const t=p.join(process.cwd(),u);f.readFile(t,(e,d)=>{if(e){s.writeHead(404);s.end('non trovato');return;}const x=p.extname(t);s.writeHead(200,{'Content-Type':x==='.html'?'text/html; charset=utf-8':x==='.json'?'application/json':'text/plain; charset=utf-8'});s.end(d);});}).listen(%PORTA%,()=>console.log('   in ascolto sulla porta %PORTA%'));"
  goto :fine
)

echo.
echo   Non ho trovato ne' Python ne' Node su questo computer.
echo.
echo   Puoi installare Python da https://www.python.org/downloads/
echo   ricordandoti di spuntare "Add Python to PATH".
echo.
echo   Oppure continua ad aprire cubik.html con un doppio clic: funziona
echo   tutto lo stesso, solo che i dati salvati non passano da una
echo   versione del file all'altra, e per travasarli devi usare il codice
echo   che trovi in Configurazione.
echo.
pause

:fine
endlocal
