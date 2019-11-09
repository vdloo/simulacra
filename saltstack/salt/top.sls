base:
  '*':
    - common.common
  'role:(workstation|htpc)':
    - match: grain_pcre
    - desktop.desktop
  'role:htpc':
    - match: grain
    - htpc.htpc
