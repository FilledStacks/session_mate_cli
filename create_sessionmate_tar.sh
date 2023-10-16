# Compiles session_mate executable, adds it to a tar and prints out the hash
echo "Compiling SessionMate CLI for Homebrew release"

dart compile exe bin/sessionmate.dart --output=sessionmate

echo "Compile complete. Add to tar ball"

tar -cvzf ./sessionmate.tar.gz ./sessionmate

echo "Tar compress complete. Get SHA checksum"

shasum -a 256 sessionmate.tar.gz
