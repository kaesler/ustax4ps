./scripts/bundleGoogleSheetModule.sh
./scripts/editGoogleSheetModule.sc <dist/GoogleSheetModule.js >dist/GSheetScript.js
rm -f dist/GoogleSheetModule.js
cat src/GoogleSheetShim.js >> dist/GSheetScript.js


