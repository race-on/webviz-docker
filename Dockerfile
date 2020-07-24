# Based on https://github.com/cruise-automation/webviz/blob/a8b01321896814f71032f4a9b75d6d42fadabcb9/Dockerfile-static-webviz
#
# The original work cruise-automation/webviz has Copyright (c) 2020-present, GM Cruise LLC
#
# This source code is licensed under the Apache License, Version 2.0,
# found in the LICENSE file in the root directory of this source tree.
# You may not use this file except in compliance with the License.

FROM node:10.16-slim AS build

# Might not be needed anymore, however, not part of the final image
# Install some general dependencies for stuff below and for CircleCI;
RUN apt-get update && apt-get install -yq gnupg libgconf-2-4 wget git ssh --no-install-recommends

# Get webviz code
RUN git clone https://github.com/cruise-automation/webviz.git && cd webviz && git checkout 73445ea

WORKDIR /webviz

# Build the static webviz.
RUN npm run install-ci
RUN npm run build
RUN npm run build-static-webviz

# Final image is based on Nginx
FROM nginx:stable-alpine

COPY --from=build /webviz/__static_webviz__/ /usr/share/nginx/html/
