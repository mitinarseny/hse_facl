FROM archlinux:base-20220424.0.54084

RUN pacman -Sy --noconfirm \
  sudo \
  glibc \
  tree

# Создадим непривелигированного пользователя `nonroot`,
# Это нужно, чтобы наглядно показать, как мы сможем входить через пользователя,
# т.к. в `/etc/pam.d/su` и `/etc/pam.d/su-l`, в том числе, прописано:
#   auth    sufficient    pam_rootok.so
# Это строка означает, что будут пропускаться все дальнейшие проверки,
# если `su` или `su --login` были запущены из-под суперпользователя.
RUN useradd --create-home nonroot

# Добавим опцию `nullok` для модуля PAM pam_unix.so для `su` и `su --login`:
RUN sed -i '/^auth.*pam_unix.so$/ s/$/ nullok/' /etc/pam.d/su /etc/pam.d/su-l
