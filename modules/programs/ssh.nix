{
  config,
  username,
  pkgs,
  lib,
  ...
}:
{
  sops = {
    secrets = {
      # SSH Keys
      id_github = {
        key = "ssh/github/private-key";
        owner = username;
      };
      id_gitlab = {
        key = "ssh/gitlab/private-key";
        owner = username;
      };
      id_codeberg = {
        key = "ssh/codeberg/private-key";
        owner = username;
      };
      id_git_blckr = {
        key = "ssh/git-blckr/private-key";
        owner = username;
      };
      id_scm_sra = {
        key = "ssh/scm-sra/private-key";
        owner = username;
      };
      id_condor = {
        key = "ssh/condor/private-key";
        owner = username;
      };
      id_condor_backup = {
        key = "ssh/condor-backup/private-key";
        owner = username;
      };
      id_linnet = {
        key = "ssh/linnet/private-key";
        owner = username;
      };
      id_redstart = {
        key = "ssh/redstart/private-key";
        owner = username;
      };
      id_lab = {
        key = "ssh/lab/private-key";
        owner = username;
      };

      # SSH Host/User/Port info
      github_hostname = {
        key = "ssh/github/host-name";
      };
      github_user = {
        key = "ssh/github/user";
      };
      gitlab_hostname = {
        key = "ssh/gitlab/host-name";
      };
      gitlab_user = {
        key = "ssh/gitlab/user";
      };
      codeberg_hostname = {
        key = "ssh/codeberg/host-name";
      };
      codeberg_user = {
        key = "ssh/codeberg/user";
      };
      git_blckr_hostname = {
        key = "ssh/git-blckr/host-name";
      };
      git_blckr_user = {
        key = "ssh/git-blckr/user";
      };
      scm_sra_hostname = {
        key = "ssh/scm-sra/host-name";
      };
      scm_sra_user = {
        key = "ssh/scm-sra/user";
      };
      condor_hostname = {
        key = "ssh/condor/host-name";
      };
      condor_user = {
        key = "ssh/condor/user";
      };
      condor_port = {
        key = "ssh/condor/port";
      };
      condor_backup_hostname = {
        key = "ssh/condor-backup/host-name";
      };
      condor_backup_user = {
        key = "ssh/condor-backup/user";
      };
      condor_backup_port = {
        key = "ssh/condor-backup/port";
      };
      linnet_hostname = {
        key = "ssh/linnet/host-name";
      };
      linnet_user = {
        key = "ssh/linnet/user";
      };
      redstart_hostname = {
        key = "ssh/redstart/host-name";
      };
      redstart_user = {
        key = "ssh/redstart/user";
      };
      lab_hostname = {
        key = "ssh/lab/host-name";
      };
      lab_user = {
        key = "ssh/lab/user";
      };
      lab_pc03_user = {
        key = "ssh/lab-pc03/user";
      };
      lab_pc30_user = {
        key = "ssh/lab-pc30/user";
      };
    };

    templates =
      let
        sshKeyTemplate = name: ''
          -----BEGIN OPENSSH PRIVATE KEY-----
          ${config.sops.placeholder.${name}}
          -----END OPENSSH PRIVATE KEY-----
        '';
      in
      {
        "id_github" = {
          content = sshKeyTemplate "id_github";
          owner = username;
          mode = "0600";
          path = "/home/${username}/.ssh/github-blckr";
        };
        "id_gitlab" = {
          content = sshKeyTemplate "id_gitlab";
          owner = username;
          mode = "0600";
          path = "/home/${username}/.ssh/gitlab";
        };
        "id_codeberg_blckr" = {
          content = sshKeyTemplate "id_codeberg";
          owner = username;
          mode = "0600";
          path = "/home/${username}/.ssh/codeberg-blckr";
        };
        "id_forgejo_blckr" = {
          content = sshKeyTemplate "id_git_blckr";
          owner = username;
          mode = "0600";
          path = "/home/${username}/.ssh/forgejo-blckr";
        };
        "id_sra_gitlab" = {
          content = sshKeyTemplate "id_scm_sra";
          owner = username;
          mode = "0600";
          path = "/home/${username}/.ssh/sra-gitlab";
        };
        "id_condor" = {
          content = sshKeyTemplate "id_condor";
          owner = username;
          mode = "0600";
          path = "/home/${username}/.ssh/condor";
        };
        "id_condor_backup" = {
          content = sshKeyTemplate "id_condor_backup";
          owner = username;
          mode = "0600";
          path = "/home/${username}/.ssh/hetzner-condorbackup";
        };
        "id_linnet" = {
          content = sshKeyTemplate "id_linnet";
          owner = username;
          mode = "0600";
          path = "/home/${username}/.ssh/linnet";
        };
        "id_redstart" = {
          content = sshKeyTemplate "id_redstart";
          owner = username;
          mode = "0600";
          path = "/home/${username}/.ssh/redstart";
        };
        "id_sra_lab" = {
          content = sshKeyTemplate "id_lab";
          owner = username;
          mode = "0600";
          path = "/home/${username}/.ssh/sra-lab";
        };

        "ssh-config" = {
          content = ''
            Host github.com
              HostName ${config.sops.placeholder.github_hostname}
              User ${config.sops.placeholder.github_user}
              IdentityFile /home/${username}/.ssh/github-blckr
              IdentitiesOnly yes

            Host gitlab.com
              HostName ${config.sops.placeholder.gitlab_hostname}
              User ${config.sops.placeholder.gitlab_user}
              IdentityFile /home/${username}/.ssh/gitlab
              IdentitiesOnly yes

            Host codeberg.org
              HostName ${config.sops.placeholder.codeberg_hostname}
              User ${config.sops.placeholder.codeberg_user}
              IdentityFile /home/${username}/.ssh/codeberg-blckr
              IdentitiesOnly yes

            Host scm.sra.uni-hannover.de
              HostName ${config.sops.placeholder.scm_sra_hostname}
              User ${config.sops.placeholder.scm_sra_user}
              IdentityFile /home/${username}/.ssh/sra-gitlab
              IdentitiesOnly yes

            Host git.blckr.dev
              HostName git.blckr.dev
              User git
              IdentityFile /home/${username}/.ssh/forgejo-blckr
              IdentitiesOnly yes

            Host condor
              HostName ${config.sops.placeholder.condor_hostname}
              User ${config.sops.placeholder.condor_user}
              Port ${config.sops.placeholder.condor_port}
              IdentityFile /home/${username}/.ssh/condor
              IdentitiesOnly yes

            Host condor-backup
              HostName ${config.sops.placeholder.condor_backup_hostname}
              User ${config.sops.placeholder.condor_backup_user}
              Port ${config.sops.placeholder.condor_backup_port}
              IdentityFile /home/${username}/.ssh/hetzner-condorbackup
              IdentitiesOnly yes

            Host linnet
              HostName ${config.sops.placeholder.linnet_hostname}
              User ${config.sops.placeholder.linnet_user}
              IdentityFile /home/${username}/.ssh/linnet
              IdentitiesOnly yes

            Host redstart
              HostName ${config.sops.placeholder.redstart_hostname}
              User ${config.sops.placeholder.redstart_user}
              IdentityFile /home/${username}/.ssh/redstart
              IdentitiesOnly yes

            Host lab
              HostName ${config.sops.placeholder.lab_hostname}
              User ${config.sops.placeholder.lab_user}
              IdentityFile /home/${username}/.ssh/sra-lab
              IdentitiesOnly yes

            Host lab-pc03
              User ${config.sops.placeholder.lab_pc03_user}
              ProxyJump lab
              IdentityFile /home/${username}/.ssh/sra-lab
              IdentitiesOnly yes

            Host lab-pc30
              User ${config.sops.placeholder.lab_pc30_user}
              ProxyJump lab
              IdentityFile /home/${username}/.ssh/sra-lab
              IdentitiesOnly yes
          '';
          owner = username;
          path = "/home/${username}/.ssh/config";
        };
      };
  };

  home-manager.users.${username} = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
    };
    home.file.".ssh/config".enable = false;
  };
}
