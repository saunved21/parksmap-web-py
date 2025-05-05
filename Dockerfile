FROM registry.redhat.io/rhel8/python-36:latest

USER root

# Upgrade pip to the latest version
RUN python -m pip install --upgrade pip

# Copy the source code to the container
COPY . /tmp/src

# Remove unnecessary files and adjust permissions
RUN rm -rf /tmp/src/.git* && \
    chown -R 1001 /tmp/src && \
    chgrp -R 0 /tmp/src && \
    chmod -R g+w /tmp/src

# Install dependencies (if you have a requirements.txt)
WORKDIR /tmp/src
RUN if [ -f "requirements.txt" ]; then pip install -r requirements.txt; fi

# Switch to the non-root user
USER 1001

# Assemble the application
RUN /usr/libexec/s2i/assemble

# Use the S2I runtime to start the app
CMD [ "/usr/libexec/s2i/run" ]
