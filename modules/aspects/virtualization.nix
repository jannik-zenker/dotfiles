# Virtualization via QEMU/KVM
{
  den.aspects.virtualization.nixos = {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
  };
}
