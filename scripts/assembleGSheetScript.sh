spago bundle-module --main GoogleSheetModule --to dist/GoogleSheetModule.js
# Remove the exports section.
./scripts/editGoogleSheetModule.sc <dist/GoogleSheetModule.js >dist/GSheetScript.js
rm -f dist/GoogleSheetModule.js

# Append the shim
cat src/GoogleSheetShim.js >> dist/GSheetScript.js
sha=`git rev-parse --short HEAD`
echo "function TIR_VERSION() { return '$sha'; }" >> dist/GSheetScript.js
