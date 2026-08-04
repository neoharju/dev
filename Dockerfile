FROM archlinux

RUN pacman -Syu --noconfirm git base-devel debugedit sudo && \
    pacman -Scc --noconfirm

RUN useradd -m neovimenjoyer && \
    usermod -aG wheel neovimenjoyer && \
    echo "neovimenjoyer ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers.d/neovimenjoyer && \
    chmod 0440 /etc/sudoers.d/neovimenjoyer

USER neovimenjoyer 

WORKDIR /home/neovimenjoyer
