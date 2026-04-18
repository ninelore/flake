{
  lib,
  python314Packages,
  fetchFromGitHub,
  libxcrypt,
}:
python314Packages.buildPythonApplication (finalAttrs: {
  pname = "archinstall";
  version = "4.2";

  src = fetchFromGitHub {
    owner = "archlinux";
    repo = "archinstall";
    rev = "${finalAttrs.version}";
    hash = "sha256-H1xpVEV+okbXxFxfFD8OWrAtIpKSiAgumhh8v1T02go=";
  };

  pyproject = true;
  build-system = with python314Packages; [ setuptools ];

  dependencies = with python314Packages; [
    pyparted
    pydantic
    cryptography
    textual
    markdown-it-py
    linkify-it-py
  ];

  pythonPath = [ libxcrypt ];
})
