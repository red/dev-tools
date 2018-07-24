var redDir = 'E:\\Red\\red\\';						// Note: backslashes
var redGUIConsole = redDir + 'gui-console.exe';		// need to be escaped

var WshShell = WScript.CreateObject("WScript.Shell");
WshShell.CurrentDirectory = redDir;                 
WshShell.Run(redGUIConsole);
WScript.Sleep(200);

WshShell.SendKeys('do to file! "quick-test/quick-test.red"~');
WshShell.SendKeys('***start-run*** "Red simple gc tests in GUI console"~');
WshShell.SendKeys('do to file! "tests/run-all-simple-gc.red"~');
WshShell.SendKeys('***end-run***~');
