install common packages:
  pkg.installed:
    - pkgs:
      - curl
      - wget
      - git
      - screen
      - htop
    - refresh: true
