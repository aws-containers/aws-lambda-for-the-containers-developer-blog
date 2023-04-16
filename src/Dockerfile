FROM public.ecr.aws/amazonlinux/amazonlinux:2023
RUN yum install -y jq tar gzip git unzip
RUN curl -Ls "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install
ADD startup.sh /startup.sh
ADD businesscode.sh /businesscode.sh
ENTRYPOINT /startup.sh