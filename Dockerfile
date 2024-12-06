ARG DOTNET_VERSION=9.0

FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_VERSION}

ARG NODE_VERSION=20.11.0

# Install Node.js dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -fsSL https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz | tar xzf - -C /usr/local --strip-components=1

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash


# Install Azure Functions Core Tools
RUN wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y azure-functions-core-tools-4

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y gh

    # After other apt-get installations, add:
# Install tools and Starship
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    gnupg \
    dotnet-sdk-8.0 \
    && rm -rf /var/lib/apt/lists/* \
    && wget -qO- https://starship.rs/install.sh | sh -s -- --yes

# Update dotnet workloads while still root
RUN dotnet workload update --no-http-cache

# Create non-root user and add environment variable to .bashrc
RUN useradd -m -s /bin/bash yooakim && \
    echo 'export TIME_STYLE=long-iso' >> /home/yooakim/.bashrc && \
    echo 'eval "$(starship init bash)"' >> /home/yooakim/.bashrc && \
    echo 'export PATH="$PATH:/home/yooakim/.dotnet/tools"' >> /home/yooakim/.bashrc


USER yooakim

# Install dotnet tools globally
RUN dotnet tool install --global dotnet-ef && \
    dotnet tool install --global upgrade-assistant && \
    dotnet tool install --global seqcli && \
    dotnet tool install --global snitch

WORKDIR /home/yooakim/workspace
