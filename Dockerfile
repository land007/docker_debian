FROM debian:latest

MAINTAINER Yiqiu Jia <yiqiujia@hotmail.com>

RUN apt-get update && apt-get upgrade -y && apt-get clean
RUN apt-get install -y net-tools vim curl wget unzip screen openssh-server git subversion locales

ENV DEBIAN_FRONTEND noninteractive

## Set LOCALE to UTF8
RUN echo "zh_CN.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen zh_CN.UTF-8 && \
    dpkg-reconfigure locales && \
    /usr/sbin/update-locale LANG=zh_CN.UTF-8
ENV LC_ALL zh_CN.UTF-8

RUN echo "MaxAuthTries 20" >> /etc/ssh/sshd_config && echo "ClientAliveInterval 30" >> /etc/ssh/sshd_config && echo "ClientAliveCountMax 3" >> /etc/ssh/sshd_config && echo "TMOUT=90" >> /etc/profile
RUN sed -i 's/#Port 22/Port 20022/g' /etc/ssh/sshd_config

RUN useradd -s /bin/bash -m land007
RUN echo "land007:1234567" | /usr/sbin/chpasswd
#land007:x:1000:1000::/home/land007:/bin/bash
RUN sed -i "s/^land007:x.*/land007:x:0:1000::\/home\/land007:\/bin\/bash/g" /etc/passwd
RUN set /files/etc/ssh/sshd_config/PermitRootLogin yes
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

CMD /etc/init.d/ssh start && bash
#ENTRYPOINT /etc/init.d/ssh start && bash
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#ENTRYPOINT /etc/init.d/ssh start && bash
EXPOSE 20022/tcp

#docker stop debian ; docker rm debian ; docker run -it --privileged --name debian land007/debian:latest


