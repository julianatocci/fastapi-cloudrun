# FROM python:3.12.8-slim

# #Do not use env as this would persist after the build and would impact your containers, children images
# ARG DEBIAN_FRONTEND=noninteractive

# # force the stdout and stderr streams to be unbuffered.
# ENV PYTHONUNBUFFERED=1

# RUN apt-get -y update \
#     && apt-get -y upgrade \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/* \
#     && useradd --uid 10000 -ms /bin/bash runner

# WORKDIR /home/runner/app

# USER 10000

# ENV PATH="${PATH}:/home/runner/.local/bin"

# COPY ./  ./

# RUN pip install --upgrade pip \
#     && pip install --no-cache-dir poetry \
#     && poetry install --only main

# EXPOSE 8000

# ENTRYPOINT [ "poetry", "run" ]

# CMD uvicorn app.main:app --host 0.0.0.0 --port 8000

# Escolha a imagem base
FROM python:3.12.8-slim

# Atualiza e cria usuário não-root
RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --uid 10000 -ms /bin/bash myuser

# Cria a pasta da aplicação e dá permissão ao usuário não-root
RUN mkdir -p /home/runner/app \
    && chown -R myuser:myuser /home/runner/app

# Define o usuário e o diretório de trabalho
USER myuser
WORKDIR /home/runner/app

# Copia os arquivos da aplicação
COPY ./ ./

# Instala Poetry e dependências da aplicação
RUN pip install --upgrade pip \
    && pip install --no-cache-dir poetry \
    && poetry config virtualenvs.create false \
    && poetry install --only main

# Exposição da porta e comando para rodar a aplicação
EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
