{ pkgs, config, ... }:

let
  githubPublicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC776TRcad0SRyl/EDki/4efEhtH3A7P1oW/+Sy+Sx+fSGz+USrmlCqxrHcamJn6+wX94YdRHflKo5VDUVM9/BXcFHj3B7N7EVSpyGo7BfhFiqt/NKUonJeRB67sLMRv0ffGtxkDQEIxJBq0jttgclOteLWRv2VtMxj0AM6oYl8D6ISqiu0Nj76aoZW4YSTvGLNRcNgsSBRUVfP6hrt8ksatF/NelCn2Jyhk1pjx9S9CXhAH6Cwuphtq974zsep2F+tdx46PZE3d/JaQME+kfdA6t3lUpoG5knpB0BwNKt9nKhAnASpTIg6DV3ef5A7VnfR2GGfnq9tdfcr/Xcd4iGO9X6qQZhAPOR67hFM8pOrGGNfi7AbJ5myyjcA3HLcQm3+0juG07/DxLAWEARsxFq1eyLbnj8sMtwy5lUOB8bfHRiFZZlIMQnmtjccXQ73db4AAOYkSE2fCwDooGGICCgn5B4I2IoazN4FIswA7sBVDnQAGVAP2kwRNrjPD/AjySk= usrbinkat@decoy.home.arpa";
  githubPublicSigningKey = ''
    -----BEGIN PGP PUBLIC KEY BLOCK-----
    
    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
    oHZOIkO8M5c/en/4lyat3Q==
    =ZVQB
    -----END PGP PUBLIC KEY BLOCK-----
  '';
in

{
  # Initializes Emacs with org-mode so we can tangle the main config
  #
  # @todo: Get rid of this after we've upgraded to Emacs 29 on the Macbook
  # Emacs 29 includes org-mode now
  ".emacs.d/init.el" = {
    text = builtins.readFile ../shared/config/emacs/init.el;
  };

  ".ssh/id_github.pub" = {
    text = githubPublicKey;
  };

  ".ssh/pgp_github.pub" = {
    text = githubPublicSigningKey;
  };

  # Used in Emacs config.org to load projects and tasks in org-agenda
  ".emacs.d/agenda.txt" = {
    text = ''
      ~/.local/share/org-roam/20220419121404-todo.org
      ~/.local/share/org-roam/20230712154159-health.org
      ~/.local/share/org-roam/20230712154441-family_social.org
      ~/.local/share/org-roam/20230712154303-business.org
      ~/.local/share/org-roam/20210919225144-home_lab.org
    '';
  };
}
