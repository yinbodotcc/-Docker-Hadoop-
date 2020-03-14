############################################
# version : yayubuntubase/withssh:v1
# desc : ubuntu14.04 上安装的ssh
############################################
# 设置继承自ubuntu14.04官方镜像
FROM ubuntu:14.04 

# 下面是一些创建者的基本信息
MAINTAINER yayubuntubase


RUN echo "root:root" | chpasswd


#安装ssh-server
RUN rm -rvf /var/lib/apt/lists/*
RUN apt-get update 
RUN apt-get install -y openssh-server openssh-client vim wget curl sudo



#配置ssh
RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
