FROM jenkins/jenkins:lts
USER root

RUN sed -i 's/deb.debian.org/mirrors.cloud.tencent.com/g' /etc/apt/sources.list
RUN sed -i 's/security.debian.org/mirrors.cloud.tencent.com/g' /etc/apt/sources.list
RUN sed -i 's/ftp.debian.org/mirrors.cloud.tencent.com/g' /etc/apt/sources.list
RUN apt-get clean

# Install .NET CLI dependencies、
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libc6 \
        libgcc1 \
        libgssapi-krb5-2 \
        libicu57 \
        liblttng-ust0 \
        libssl1.0.2 \
        libstdc++6 \
        zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Install .NET Core SDK 3.1
RUN dotnet_sdk_version=3.1.301 \
    && curl -SL --output dotnet_3.1.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/$dotnet_sdk_version/dotnet-sdk-$dotnet_sdk_version-linux-x64.tar.gz \
    && dotnet_sha512='dd39931df438b8c1561f9a3bdb50f72372e29e5706d3fb4c490692f04a3d55f5acc0b46b8049bc7ea34dedba63c71b4c64c57032740cbea81eef1dce41929b4e' \
    && echo "$dotnet_sha512 dotnet_3.1.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -ozxf dotnet_3.1.tar.gz -C /usr/share/dotnet \
    && rm dotnet_3.1.tar.gz \
    && ln -s /usr/share/dotnet/dotnet_3.1 /usr/bin/dotnet_3.1

# Install .NET Core SDK 2.1
RUN dotnet_sdk_version=2.1.807 \
    && curl -SL --output dotnet_2.1.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/$dotnet_sdk_version/dotnet-sdk-$dotnet_sdk_version-linux-x64.tar.gz \
    && dotnet_sha512='85bfe356d1b6ac19ae5abe9f34f4cc4437f65c87ac8dff90613f447da619724ddcda5cbd1a403cd2ab96db8456d964fa60b83c468f7803d3caadbee4e8d134ec' \
    && echo "$dotnet_sha512 dotnet_2.1.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf dotnet_2.1.tar.gz -C /usr/share/dotnet \
    && rm dotnet_2.1.tar.gz \
    && ln -s /usr/share/dotnet/dotnet_2.1 /usr/bin/dotnet_2.1

RUN dotnet --list-sdks
