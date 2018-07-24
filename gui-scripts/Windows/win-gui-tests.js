var redDir = 'E:\\Red\\red\\';						// Note: backslashes
var redGUIConsole = redDir + 'gui-console.exe';		// need to be escaped

var WshShell = WScript.CreateObject("WScript.Shell");
WshShell.CurrentDirectory = redDir;                 
WshShell.Run(redGUIConsole);
WScript.Sleep(200);

var fs = WScript.CreateObject("Scripting.FileSystemObject");
var allTestsPath = redDir + "\\tests\\source\\units\\all-tests.txt";
var allTestsFile = fs.OpenTextFile(allTestsPath, 1);

WshShell.SendKeys('do to file! "quick-test/quick-test.red"~');
WshShell.SendKeys('***start-run*** "Red tests in GUI console"~');
while (!allTestsFile.AtEndOfStream) {
	cmd = 'do clean-path to file! "tests/source/units/' + 
				  allTestsFile.ReadLine() + '"';
    WshShell.SendKeys(cmd + '~');
}
allTestsFile.Close();
WshShell.SendKeys('***end-run***~');
