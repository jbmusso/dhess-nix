{ mkDerivation, base, base16-bytestring, bytestring, conduit
, conduit-extra, containers, cryptohash-sha1, deepseq, directory
, extra, fetchgit, file-embed, filepath, ghc, hslogger, process
, stdenv, tasty, tasty-hunit, temporary, text, time, transformers
, unix-compat, unordered-containers, vector, yaml
}:
mkDerivation {
  pname = "hie-bios";
  version = "0.3.0";
  src = fetchgit {
    url = "https://github.com/mpickering/hie-bios";
    sha256 = "1w3jam3rzkjr432s6lr804w4c44hx10kfnsgscm4ikn61bsnpakm";
    rev = "32c70fe232cfa6186c7e333205ec4ba103b8ad19";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base base16-bytestring bytestring conduit conduit-extra containers
    cryptohash-sha1 deepseq directory extra file-embed filepath ghc
    hslogger process temporary text time transformers unix-compat
    unordered-containers vector yaml
  ];
  executableHaskellDepends = [ base directory filepath ghc ];
  testHaskellDepends = [
    base directory filepath ghc tasty tasty-hunit
  ];
  homepage = "https://github.com/mpickering/hie-bios";
  description = "Set up a GHC API session";
  license = stdenv.lib.licenses.bsd3;
}
