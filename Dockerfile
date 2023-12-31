FROM ubuntu:jammy

# Set environment variable
ENV TZ=Asia/Ho_Chi_Minh
ENV DISPLAY=:0
ENV SCREEN_DPI=96
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH "/opt/bin/chromedriver-linux64:$PATH"

# Install necessary packages
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:alex-p/tesseract-ocr-devel
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        fontconfig \
        fonts-roboto \
        maven \
        curl \
        unzip \
        python3 \
        python3-pip \
        libopencv4.5-java \
        tesseract-ocr \
        libtesseract-dev \
        ca-certificates \
        wget \
        x11-apps \
        xserver-xorg-video-dummy && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Create a directory to store fonts
COPY Fonts/*.ttf /usr/share/fonts/X11/misc
RUN fc-cache -f -v

# Create the symbolic link for libopencv_java.so
RUN ln -s /usr/lib/jni/libopencv_java454.so /usr/lib/jni/libopencv_java.so

# Use curl to download the JDK tarball
RUN curl -o temurin.tar.gz -L "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17%2B35/OpenJDK17-jdk_x64_linux_hotspot_17_35.tar.gz" && \
    mkdir -p /usr/share/man/man1 && \
    tar -xvf temurin.tar.gz --directory=/usr/local/ && \
    rm temurin.tar.gz && \
    ln -sf /usr/local/jdk-17+35/bin/java /usr/bin/java && \
    echo 'JAVA_HOME="/usr/local/jdk-17+35"' >> /etc/environment

# Install Robot Framework and SikuliLibrary
RUN pip3 install robotframework XlsxWriter robotframework-SeleniumLibrary robotframework-AppiumSikuliLibrary

# Install Google Chrome and Driver
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list && \
    apt-get update -y && \
    apt-get install -y google-chrome-stable && \
    curl -s https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions.json | grep -Po '\d+\.\d+\.\d+\.\d+' | head -1 > chrome-version && \
    wget https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/`cat chrome-version`/linux64/chromedriver-linux64.zip && \
    unzip chromedriver-linux64.zip -d /opt/bin/ && \
    rm chromedriver-linux64.zip && \
    chmod +x /opt/bin/chromedriver-linux64

# Define working directory
WORKDIR /data
COPY robot.sh /robot.sh
RUN chmod +x /robot.sh

#Create default X Windows configuration file
COPY xorg.conf /etc/X11/xorg.conf.d/xorg-dummy.conf

# Start robot.sh script
ENTRYPOINT [ "/bin/bash", "/robot.sh" ]