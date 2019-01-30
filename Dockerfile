From maven:3.5.3-jdk-8

# Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update -qqy \
    && apt-get -qqy install google-chrome-stable \
    && rm /etc/apt/sources.list.d/google-chrome.list \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
    && sed -i 's/"$HERE\/chrome"/"$HERE\/chrome" --no-sandbox/g' /opt/google/chrome/google-chrome


ADD mobile-oreo /mobile-oreo

# ChromeDriver
ARG CHROME_DRIVER_VERSION=2.45
RUN wget --no-verbose -O /mobile-oreo/chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip \
    && rm -rf /chromedriver \
    && unzip /mobile-oreo/chromedriver_linux64.zip -d / \
    && rm /mobile-oreo/chromedriver_linux64.zip \
    && mv /chromedriver /chromedriver-$CHROME_DRIVER_VERSION \
    && chmod 755 /chromedriver-$CHROME_DRIVER_VERSION \
    && ln -fs /chromedriver-$CHROME_DRIVER_VERSION /usr/bin/chromedriver


WORKDIR /mobile-oreo

RUN mvn clean package
