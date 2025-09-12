{
  lib,
  stdenv,
  nodejs,
  electron,
  buildGoModule,
  fetchgit,
  npmHooks,
  fetchNpmDeps,
  wrapGAppsHook4,
  ...
}:
buildGoModule (finalAttrs: {
  pname = "fiedka";
  version = "1.5.2-unstable-2024-09-10";

  src = fetchgit {
    url = "https://github.com/fiedka/fiedka.git";
    rev = "2ba6095ea31fe5626fb54fdf6754c60b20247fd3";
    hash = "sha256-GCgIkbRPvM5WuWjMH7462YjtQjHjgp/2A6SWajDiBw0=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-gOZwAZj6BAEvYQzGMRDOg3tF58RHnW6/+LLJddGbOcU=";
  modRoot = "src";

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    electron
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

  propagatedBuildInputs = [ electron ];

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-erVXqLl9wtO94TyWqe6pjIzEwWY/LQWrFYefmAN/aQY=";
  };

  overrideModAttrs = oldAttrs: {
    nativeBuildInputs = lib.remove npmHooks.npmConfigHook oldAttrs.nativeBuildInputs;
  };

  buildPhase = ''
    npm run package
  '';

  installPhase = ''
    mkdir -p $out/{bin,share}

  '';

  meta = {
    description = "";
    homepage = "";
    license = lib.licenses.mit;
  };
})
