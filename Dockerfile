# """
#     The MIT License (MIT)

#     Copyright (c) 2023 pkjmesra

#     Permission is hereby granted, free of charge, to any person obtaining a copy
#     of this software and associated documentation files (the "Software"), to deal
#     in the Software without restriction, including without limitation the rights
#     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#     copies of the Software, and to permit persons to whom the Software is
#     furnished to do so, subject to the following conditions:

#     The above copyright notice and this permission notice shall be included in all
#     copies or substantial portions of the Software.

#     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#     SOFTWARE.

# """
# docker buildx build --push --platform linux/arm/v7,linux/arm64/v8,linux/amd64 --tag pkjmesra/pkscreener:latest .
# docker buildx build --load --platform linux/arm64/v8,linux/amd64 --tag pkjmesra/pkscreener:latest . --no-cache
# docker buildx build --push --platform linux/arm64/v8,linux/amd64 --tag pkjmesra/pkscreener:latest . --no-cache

FROM pkjmesra/pkscreener:latest as base
ENV PYTHONUNBUFFERED 1
WORKDIR /
RUN rm -rf /PKScreener-main
RUN rm -rf main.zip main.zip.*
RUN curl -JL https://github.com/pkjmesra/PKScreener/archive/refs/heads/main.zip -o main.zip && unzip main.zip
RUN rm -rf main.zip main.zip.*
WORKDIR /PKScreener-main
RUN pip3 install --upgrade pip
RUN pip3 uninstall pkscreener -y
RUN pip3 uninstall PKNSETools -y
RUN pip3 uninstall PKDevTools -y
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install .
RUN export TERM=xterm
ENV PKSCREENER_DOCKER=1

ENTRYPOINT ["python3","pkscreener/pkscreenercli.py"]
# Run with 
# docker run -it pkjmesra/pkscreener:latest
