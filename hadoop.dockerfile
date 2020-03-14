############################################ 
# desc : 安装JAVA  HADOOP 
############################################
 
FROM ubuntuforhadoop/withssh:v1
 
 
MAINTAINER yay 
  
#为hadoop集群提供dns服务
USER root
RUN sudo apt-get -y install dnsmasq

#安装和配置java环境
#安装和配置java 
ADD jdk-8u191-linux-x64.tar.gz /usr/local/
ENV JAVA_HOME /usr/local/jdk1.8.0_191
ENV CLASSPATH ${JAVA_HOME}/lib/dt.jar:$JAVA_HOME/lib/tools.jar
ENV PATH $PATH:${JAVA_HOME}/bin


#安装HADOOP
ADD hadoop-3.2.1.tar.gz /usr/local/
RUN cd /usr/local && ln -s ./hadoop-3.2.1 hadoop

ENV HADOOP_PREFIX /usr/local/hadoop
ENV HADOOP_HOME /usr/local/hadoop
ENV HADOOP_COMMON_HOME /usr/local/hadoop
ENV HADOOP_HDFS_HOME /usr/local/hadoop
ENV HADOOP_MAPRED_HOME /usr/local/hadoop
ENV HADOOP_YARN_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR /usr/local/hadoop/etc/hadoop
ENV PATH ${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:$PATH

RUN mkdir -p /home/hadooptmp


RUN echo "hadoop ALL= NOPASSWD: ALL" >> /etc/sudoers



#在每台主机上输入 ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa 创建一个无密码的公钥，-t是类型的意思，dsa是生成的密钥类型，-P是密码，’’表示无密码，-f后是秘钥生成后保存的位置
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
CMD ["/usr/sbin/sshd","-D"] 



ADD hadoop-conf/.       /usr/local/hadoop/etc/hadoop/
#ADD start/.             /usr/local/hadoop/sbin/

#在制定行插入
RUN sed -i "1i HADOOP_SECURE_DN_USER=hdfs"  /usr/local/hadoop/sbin/start-dfs.sh
RUN sed -i "1i HDFS_NAMENODE_USER=root"  /usr/local/hadoop/sbin/start-dfs.sh
RUN sed -i "1i HDFS_SECONDARYNAMENODE_USER=root"  /usr/local/hadoop/sbin/start-dfs.sh
RUN sed -i "1i HDFS_DATANODE_USER=root"  /usr/local/hadoop/sbin/start-dfs.sh


RUN sed -i "1i HADOOP_SECURE_DN_USER=hdfs"  /usr/local/hadoop/sbin/stop-dfs.sh
RUN sed -i "1i HDFS_NAMENODE_USER=root"  /usr/local/hadoop/sbin/stop-dfs.sh
RUN sed -i "1i HDFS_SECONDARYNAMENODE_USER=root"  /usr/local/hadoop/sbin/stop-dfs.sh
RUN sed -i "1i HDFS_DATANODE_USER=root"  /usr/local/hadoop/sbin/stop-dfs.sh

RUN sed -i "1i HADOOP_SECURE_DN_USER=yarn"  /usr/local/hadoop/sbin/start-yarn.sh
RUN sed -i "1i YARN_NODEMANAGER_USER=root"  /usr/local/hadoop/sbin/start-yarn.sh
RUN sed -i "1i YARN_RESOURCEMANAGER_USER=root"  /usr/local/hadoop/sbin/start-yarn.sh

RUN sed -i "1i HADOOP_SECURE_DN_USER=yarn"  /usr/local/hadoop/sbin/stop-yarn.sh
RUN sed -i "1i YARN_NODEMANAGER_USER=root"  /usr/local/hadoop/sbin/stop-yarn.sh
RUN sed -i "1i YARN_RESOURCEMANAGER_USER=root"  /usr/local/hadoop/sbin/stop-yarn.sh
