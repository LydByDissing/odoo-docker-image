FROM ubuntu:jammy

RUN apt update \
    && apt install -y wget gpg curl

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt install -y tzdata

RUN curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg \
    && sh -c 'echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/jammy pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update' \
    && apt install -y pgadmin4 \
    && apt upgrade -y

RUN  wget -q -O - https://nightly.odoo.com/odoo.key | gpg --dearmor -o /usr/share/keyrings/odoo-archive-keyring.gpg \
     && echo 'deb [signed-by=/usr/share/keyrings/odoo-archive-keyring.gpg] https://nightly.odoo.com/17.0/nightly/deb/ ./' | tee /etc/apt/sources.list.d/odoo.list \
     && apt update && apt install -y odoo

RUN echo "deb http://security.ubuntu.com/ubuntu focal-security main" | tee /etc/apt/sources.list.d/focal-security.list \
    && apt update \
    && apt --fix-broken install -y \
    && apt install -y libssl1.1
RUN wget -O /tmp/wkhtmltox_0.12.6-1.focal_amd64.deb https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_amd64.deb \
    && apt -f install -y /tmp/wkhtmltox_0.12.6-1.focal_amd64.deb \
    && rm /tmp/wkhtmltox_0.12.6-1.focal_amd64.deb

RUN apt install -y fonts-roboto \
    && fc-cache -f -v

USER odoo
ENTRYPOINT [ "/usr/bin/odoo"]
CMD [ "server" ]