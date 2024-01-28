FROM ubuntu:jammy

RUN apt update \
    && apt install -y wget gpg curl

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt install -y tzdata

RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt jammy-pgdg main" > /etc/apt/sources.list.d/pgdg.list' \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://apt.postgresql.org/pub/repos/apt jammy-pgdg main" > /etc/apt/sources.list.d/pgdg.list' \
    && apt update \
    && apt-get autoremove -y --purge postgresql-client-14 postgresql-client-common postgresql-common \
    && apt install -y postgresql-client-15

RUN  wget -q -O - https://nightly.odoo.com/odoo.key | gpg --dearmor -o /usr/share/keyrings/odoo-archive-keyring.gpg \
     && echo 'deb [signed-by=/usr/share/keyrings/odoo-archive-keyring.gpg] https://nightly.odoo.com/17.0/nightly/deb/ ./' | tee /etc/apt/sources.list.d/odoo.list \
     && apt update && apt install -y odoo

RUN echo "deb http://security.ubuntu.com/ubuntu focal-security main" | tee /etc/apt/sources.list.d/focal-security.list \
    && apt update \
    && apt --fix-broken install -y \
    && apt install -y libssl1.1

#RUN wget -O /tmp/wkhtmltox_0.12.6-1.focal_amd64.deb https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_amd64.deb \
#    && apt -f install -y /tmp/wkhtmltox_0.12.6-1.focal_amd64.deb \
#    && rm /tmp/wkhtmltox_0.12.6-1.focal_amd64.deb

RUN wget -O /tmp/wkhtmltox.bionic_amd64.deb https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.bionic_amd64.deb \
    && apt -f install -y /tmp/wkhtmltox.bionic_amd64.deb \
    && rm /tmp/wkhtmltox.bionic_amd64.deb

RUN apt install -y fonts-roboto \
    && fc-cache -f -v

## Make sure the odoo user has a predictable user id
USER odoo
ENTRYPOINT [ "/usr/bin/odoo"]
CMD [ "server" ]