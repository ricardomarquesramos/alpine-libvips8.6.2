FROM alpine:3.5
ARG VIPS_VERSION=8.6.2

# Install dependencies
RUN apk update && apk upgrade && apk add --no-cache openssl ca-certificates && \
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.5/community" >> /etc/apk/repositories && \
    apk add --update \
    zlib-dev libxml2-dev glib-dev gobject-introspection-dev \
    libjpeg-turbo-dev libexif-dev lcms2-dev fftw-dev giflib-dev libpng-dev \
    libwebp-dev orc-dev tiff-dev poppler-dev librsvg-dev libgsf-dev openexr-dev && \
    apk add --no-cache --virtual .build-dependencies autoconf automake build-base \
    git libtool nasm  libxslt-dev \
    libexif-dev lcms2-dev fftw-dev giflib-dev libpng-dev libwebp-dev orc-dev tiff-dev \
    poppler-dev librsvg-dev wget && \
# Install libvips
    wget -O- https://github.com/jcupitt/libvips/releases/download/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.gz | tar xzC /tmp && \
    cd /tmp/vips-${VIPS_VERSION} && \
    ./configure --prefix=/usr \
                --without-python \
                --without-gsf \
                --enable-debug=no \
                --disable-dependency-tracking \
                --disable-static \
                --enable-silent-rules && \
    make -s install-strip && \
    cd $OLDPWD && \
# Cleanup
    rm -rf /tmp/vips-${VIPS_VERSION} && \
    apk del --purge .build-dependencies && \
    rm -rf /var/cache/apk/*