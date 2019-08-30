function Component()
{
  Component.prototype.createOperations = function()
  {
    // call default implementation
    component.createOperations();

    console.log("This is component " + component.name + ", display " + component.displayName + ", installed=" + component.installed);

    // ... add custom operations

    var kernel = systemInfo.kernelType;
    // if( kernel == "darwin" ) {

    component.addOperation("Mkdir", "@TargetDir@/OpenStudioApp.app/Contents/");
    // Copies the content of ./Resources/* into /OpenStudioApp.app/Contents/Resources/*
    // Be VERY mindful of the trailing slashes...
    component.addOperation("CopyDirectory", "@TargetDir@/Resources", "@TargetDir@/OpenStudioApp.app/Contents/");



    // Try1: Ok
    // Try1/Contents/Resources/resources.txt exists
    component.addOperation("Mkdir", "@TargetDir@/Try1/Contents/");
    component.addOperation("CopyDirectory", "@TargetDir@/Resources", "@TargetDir@/Try1/Contents/");

    // Try2: Not what I'm looking for, but makes sense
    // Try2/Contents/resources.txt exists
    component.addOperation("Mkdir", "@TargetDir@/Try2/Contents/");
    component.addOperation("CopyDirectory", "@TargetDir@/Resources/", "@TargetDir@/Try2/Contents/");

    // Try3: Not ok
    // Try3/Resources/resources.txt exists
    // Try3/Contents is empty
    // THIS MAKES NO SENSE!
    component.addOperation("Mkdir", "@TargetDir@/Try3/Contents/");
    component.addOperation("CopyDirectory", "@TargetDir@/Resources", "@TargetDir@/Try3/Contents");


    // Try4: Not Ok
    // Try4/resources.txt exists
    // Try4/Contents is empty
    component.addOperation("Mkdir", "@TargetDir@/Try4/Contents/");
    component.addOperation("CopyDirectory", "@TargetDir@/Resources/", "@TargetDir@/Try4/Contents");


    // Try5: Ok, this is litterally what OpenStudio's is doing right now
    // Try5/Contents/Resources/resources.txt exists
    component.addOperation("Mkdir", "@TargetDir@/Try5/Contents/Resources");
    component.addOperation("CopyDirectory", "@TargetDir@/Resources", "@TargetDir@/Try5/Contents/");

    // Try6: Not what I'm looking for, but makes sense
    // Try6/Contents/resources.txt exists
    component.addOperation("Mkdir", "@TargetDir@/Try6/Contents/Resources");
    component.addOperation("CopyDirectory", "@TargetDir@/Resources/", "@TargetDir@/Try6/Contents/Resources/");

    //}
  }
}


