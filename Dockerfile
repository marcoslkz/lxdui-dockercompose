# docker run -it -p 15151:15151 -v /var/snap/lxd/common/lxd/unix.socket:/var/snap/lxd/common/lxd/unix.socket lxdui

# build stage
FROM python:3.7 AS builder
WORKDIR /opt/venv

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PATH="/opt/venv/bin:$PATH"
COPY requirements.txt .

RUN pip install --upgrade pip \    
  && pip install --upgrade setuptools \
  && python -m venv /opt/venv \ 
  && pip install pur
  && pip install -Ur requirements.txt 

# final stage
FROM python:3.7
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

ADD . /app
WORKDIR /app

RUN python3 setup.py install

EXPOSE 15151

ENTRYPOINT ["python3", "run.py", "start"]

