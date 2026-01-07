FROM archlinux

RUN pacman -Syu --noconfirm git base-devel debugedit sudo

RUN useradd -m neovimenjoyer && \
    usermod -aG wheel neovimenjoyer && \
    echo "neovimenjoyer ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

USER neovimenjoyer 

WORKDIR /home/neovimenjoyer
