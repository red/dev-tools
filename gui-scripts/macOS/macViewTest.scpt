JsOsaDAS1.001.00bplist00�Vscript_var redDir = '/Users/peter/VMShare/Red/red';          // Red repo base dir
var redApp = 'macView';			                      // GUI console bundle name

var evaluate = function (str) {
	system.keystroke(str);
	system.keyCode(36);
	delay(0.3);
};
var testBlock = 'foreach script ['

var red = Application(redApp);
red.activate();
delay(1);

var system = Application('System Events');
red = system.processes[redApp];

var app = Application.currentApplication();
app.includeStandardAdditions = true;

evaluate('change-dir %' + redDir);
delay(0.5);
evaluate('do %quick-test/quick-test.red');

const allTestsFile = app.openForAccess(redDir + '/tests/source/units/all-tests.txt');
const testList = app.read(allTestsFile).split('\n');

evaluate('***start-run*** "Red tests in GUI console"');
//evaluate('do %tests/source/units/integer-test.red');
for (i in testList) {
	if (testList[i].endsWith('.red')) {
		testBlock += ' %tests/source/units/'
		testBlock += testList[i];
	} 
}
testBlock += ' ] [ do script ]';
evaluate(testBlock);
evaluate(' ***end-run***');
                              2jscr  ��ޭ