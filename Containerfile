FROM debian:stable
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ca-certificates curl gawk gnupg gnupg-pkcs11-scd libjson-c5 libcurl4
RUN curl -sSLf "https://github.com/gardenlinux/aws-kms-pkcs11/releases/download/latest/aws_kms_pkcs11-$(dpkg --print-architecture).so" > /aws_kms_pkcs11.so
RUN mkdir -m 700 /root/.gnupg
COPY gpg-agent.conf gnupg-pkcs11-scd.conf /root/.gnupg/
COPY init /
COPY mirror_apt_repo parse_pkgs /usr/local/bin/
RUN gpg --no-default-keyring --keyring /usr/share/keyrings/debian-archive-keyring.gpg --export > /keyring.gpg
ENTRYPOINT [ "/init", "mirror_apt_repo" ]
CMD [ "-t", "/repo" ]
