

execute_manual_test() {

  /bin/rm -Rf ./build/test-install/manual_test
  mkdir -p ./build/test-install/manual_test/
  cp -R ./resources ./build/test-install/manual_test/Resources

  mkdir -p ./build/test-install/manual_test/OpenStudioApp.app/Contents/
  if [ ! -f ./build/test-install/manual_test/Resources/resources.txt ]; then
    echo "Something went wrong"
    exit 1
  fi;

  echo "Test $1: cp -R '$2' '$3'"
  cp -R "./build/test-install/manual_test/$2" "./build/test-install/manual_test/$3"

  if [ -f ./build/test-install/manual_test/OpenStudioApp.app/Contents/Resources/resources.txt ]; then
    echo "Test $1 Passed"
  else
    echo "Test $2 Failed"
  fi;
}


execute_manual_test "1" "Resources/" "OpenStudioApp.app/Contents/"
execute_manual_test "2" "Resources/" "OpenStudioApp.app/Contents"
execute_manual_test "3" "Resources" "OpenStudioApp.app/Contents"
execute_manual_test "4" "Resources" "OpenStudioApp.app/Contents/"



