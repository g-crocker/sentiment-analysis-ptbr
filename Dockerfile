FROM noronhadataops/noronha:latest

ENV TZ America/Sao_Paulo

RUN apt -y update \
 && apt -y install curl wget vim iputils-ping \
 && apt clean \
 && rm -rf /var/lib/apt/lists/*

ADD requirements.txt requirements.txt

RUN bash -c "source ${CONDA_HOME}/bin/activate ${CONDA_VENV} \
 && pip install -r requirements.txt \
 && rm -rf requirements.txt"

ADD notebooks/ notebooks/

