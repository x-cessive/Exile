@echo off
color 0a
title Server Starter
:Serverstart
echo Launching Server
echo Watching XCSV Arma 3 Exile Server
start "Arma3" /min /wait arma3server_x64 97.104.59.165 -port=2302 "-mod=@Exile;@Extended_Base_Mod;@NIArsenal;@ASDG_JR;@CBA_A3;" "-servermod=@exileserver;@ATS;" -config=@ExileServer\config.cfg -cfg=@ExileServer\basic.cfg -profiles=SC -name=sc -cpuCount=4 -exThreads=7 -enableHT -malloc=system -noPause -noSound -world=empty -autoinit
ping 127.0.0.1 -n 15 >NUL
echo Server with Exile has exited ... Restarting!
ping 127.0.0.1 -n 5 >NUL
cls
goto Serverstart