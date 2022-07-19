var ComponentSelectionPage = null;

var Dir = new function () {
    this.toNativeSparator = function (path) {
        if (systemInfo.productType === "windows")
            return path.replace(/\//g, '\\');
        return path;
    }
};


function getPythonInfo() {

}


function Component() {
    if (installer.isInstaller()) {
        console.log(component.name);
        component.loaded.connect(this, Component.prototype.installerLoaded);
    }
}

Component.prototype.installerLoaded = function () {
    var components = installer.components();
    console.log(components);
    components.forEach(component => {
      var compName = component.name;
      console.log(compName);
    })

    ComponentSelectionPage = gui.pageById(QInstaller.ComponentSelection);
    // ComponentSelectionPage.NextButton.clicked.connect(this, Component.prototype.showOrHidePythonTools)
    ComponentSelectionPage.left.connect(this, Component.prototype.pythonToolsWidgetEntered);


  if (installer.addWizardPage(component, "PythonToolsWidget", QInstaller.ReadyForInstallation)) {
    var widget = gui.pageWidgetByObjectName("DynamicPythonToolsWidget");
    if (widget != null) {
      widget.targetChooser.clicked.connect(this, Component.prototype.chooseTarget);
      widget.targetDirectory.textChanged.connect(this, Component.prototype.targetChanged);

      widget.windowTitle = "Python Tools";

      var sep = ":";
      if (systemInfo.productType === "windows") {
        sep = ";"
      }
      var paths = installer.environmentVariable("PATH").split(sep);

      console.log(paths);
      var pythonpath = installer.findPath("python", paths);
      // Component.prototype.targetChanged(pythonpath);

      widget.targetDirectory.text = Dir.toNativeSparator(pythonpath); // installer.value("TargetDir"));
    }
    var page = gui.pageByObjectName("DynamicPythonToolsWidget");
    if (page != null) {
      //  page.entered.connect(this, Component.prototype.pythonToolsWidgetEntered);
    }
  }
}

Component.prototype.targetChanged = function (text) {

    var widget = gui.pageWidgetByObjectName("DynamicPythonToolsWidget");
    widget.complete = false;

    if (widget != null) {
        if (text != "") {
          if (!installer.fileExists(text)) {
            widget.pythonInfo.html = "<p><strong style='color: red;'>Path does not exist:</strong> " + text + "</p>";

            return;
          }


            var program = `import sys
print(sys.version)
if (sys.version_info.major == 3 and sys.version_info.minor >= 6 and sys.version_info.minor <= 10):
    exit(0)
print('<strong style="color: red;">Wrong Python Version, expecting between 3.6 and 3.10 included')
exit(1)`;
            var python_info = installer.execute(text, ['-c', program]); // "import sys; print(sys.version)"]);
            console.log(python_info);
            if (python_info[1] == 0) {
              widget.pythonInfo.html = "<p><strong style='color: green;'>OK</p><p>" + python_info[0].replace('\n', '<br />') + "</p>";
              widget.complete = true;
              installer.setValue("PythonPath", text);
              return;
            } else {
              widget.pythonInfo.html = "<p><strong>Error calling Python:</strong></p><p>Return Code: " + python_info[1] + "</p><p>" + python_info[0] + "</p>";
            }
        } else {
          widget.pythonInfo.html = "<p><strong>Python not found:</strong></p>";
        }

    }
}

Component.prototype.chooseTarget = function () {
    var widget = gui.pageWidgetByObjectName("DynamicPythonToolsWidget");
    if (widget != null) {

       var fileName = QFileDialog.getOpenFileName("Python Executable",
                                                widget.targetDirectory.text,
                                                "Executable (*)");
        if (fileName != "") {
            widget.targetDirectory.text = Dir.toNativeSparator(fileName);
        }
    }
}

Component.prototype.pythonToolsWidgetEntered = function()
{
    var widget = gui.pageWidgetByObjectName("DynamicPythonToolsWidget");
    var page = gui.pageByObjectName("DynamicPythonToolsWidget");

    // var component = installer.componentByName("PythonTools");
    if (!component.installationRequested()) {
      console.log("No Python Tools Installation required")
      if (page != null) {
        installer.removeWizardPage(component, "PythonToolsWidget");
      }
      // page.hide();
      // widget.complete = true;
      return;
    }

    console.log("Python Tools Installation required")
    if (page != null) {
      page.show();
      return;
    }

    if (installer.addWizardPage(component, "PythonToolsWidget", QInstaller.ReadyForInstallation)) {
        var widget = gui.pageWidgetByObjectName("DynamicPythonToolsWidget");
        if (widget != null) {
            widget.targetChooser.clicked.connect(this, Component.prototype.chooseTarget);
            widget.targetDirectory.textChanged.connect(this, Component.prototype.targetChanged);

            widget.windowTitle = "Python Tools";

            var sep = ":";
            if (systemInfo.productType === "windows") {
              sep = ";"
            }
            var paths = installer.environmentVariable("PATH").split(sep);

            console.log(paths);
            var pythonpath = installer.findPath("python", paths);
            // Component.prototype.targetChanged(pythonpath);

            widget.targetDirectory.text = Dir.toNativeSparator(pythonpath); // installer.value("TargetDir"));
        }

        var page = gui.pageByObjectName("DynamicPythonToolsWidget");
        if (page != null) {
        //  page.entered.connect(this, Component.prototype.pythonToolsWidgetEntered);
        }
    }
}

Component.prototype.readyToInstallWidgetEntered = function () {
    var widget = gui.pageWidgetByObjectName("DynamicReadyToInstallWidget");
    if (widget != null) {
        var html = "<b>Components to install:</b><ul>";
        var components = installer.components();
        for (i = 0; i < components.length; ++i) {
            if (components[i].installationRequested())
                html = html + "<li>" + components[i].displayName + "</li>"
        }
        html = html + "</ul>";
        widget.showDetailsBrowser.html = html;
    }
}


// Regular install commands to be performed
Component.prototype.createOperations = function()
{
  // call default implementation
  component.createOperations();

  var pythonExe = installer.value("PythonPath");
  console.log("NOW READY TO PIP INSTALL SOME SHIT");
  console.log(pythonExe);

  component.addOperation("Execute", pythonExe, "-m", "pip", "install", "dummy_test");

}
